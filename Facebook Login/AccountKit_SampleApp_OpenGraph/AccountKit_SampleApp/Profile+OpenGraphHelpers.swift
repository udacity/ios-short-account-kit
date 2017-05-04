//
//  Profile+OpenGraphHelpers.swift
//  AccountKit_SampleApp
//
//  Created by Josh Svatek on 2017-05-03.
//  Copyright © 2017 Gabrielle Miller-Messner. All rights reserved.
//

import UIKit
import FBSDKLoginKit

// This file contains helper methods for updating a `Profile` using the
// Facebook SDK. Use `loadProfileData(completion:)` to populate or update a
// profile's `profileData`. Call `loadImage(completion:)` after the profile
// data is available to load the profile picture data. The completion
// closure in each will be called on the main thread.

// -----------------------------------------------------------------------------
// MARK: - Loading user data

internal extension Profile {
    /// This method fetches data for the user using our `GraphClient` helper
    /// type, which in turn calls `FBSDKGraphRequest`. Once it has data for the
    /// user, it update's the Profile's `profileData` property.
    func loadFacebookProfileData(completion: @escaping () -> Void) {
        GraphClient().fetchProfileDictionary(for: self) { (dictionary, error) in
            if let error = error {
                print("Received an error fetching FB user data: \(error.localizedDescription)")
                // Handle the error
                DispatchQueue.main.async {
                    completion()
                }
                return
            }

            guard let dictionary = dictionary else {
                DispatchQueue.main.async {
                    completion()
                }
                return
            }

            Profile.makeProfileData(with: dictionary) { [weak self] result in
                if let profileData = result {
                    self?.replaceProfileData(profileData)
                }
                DispatchQueue.main.async {
                    completion()
                }
            }
        }
    }

    /// Maps a dictionary of data returned by `FBSDKGraphRequest` -> ProfileData
    fileprivate static func makeProfileData(with dictionary: [String: Any], completion: @escaping (ProfileData?) -> Void) {
        // We must at least have the identifier. The rest is optional.
        guard let id = dictionary["id"] as? String else {
            completion(nil)
            return
        }

        let name = dictionary["name"] as? String
        let email = dictionary["email"] as? String
        let pictureDictionary = dictionary["picture"] as? [String: Any]
        let pictureDataDictionary = pictureDictionary?["data"] as? [String: Any]
        let friendsDictionary = dictionary["friends"] as? [String: Any]
        let friendsSummaryDictionary = friendsDictionary?["summary"] as? [String: Any]

        // For the friends, we'll mix in some hardcoded people with actual
        // facebook friends

        let hardcodedFriends = Surfer.makeHardcodedSurfers()

        var foundFriends: [String: Surfer] = [:]
        for surfer in friendsDictionary.flatMap(makeSurfers) ?? [] {
            foundFriends[surfer.identifier] = surfer
        }

        // This is a little duplicative, but to fetch the picture URLs for
        // friends, we'll make a second Open Graph call merging in the friends
        // returned
        GraphClient().fetchProfileFriends { (result, error) in
            // Update foundFriends
            for item in result ?? [] {
                guard let id = item["id"] as? String,
                    let name = item["name"] as? String,
                    let picture = item["picture"] as? [String: Any],
                    let pictureData = picture["data"] as? [String: Any],
                    let url = pictureData["url"] as? String else {
                        continue
                }
                foundFriends[id] = Surfer(identifier: id, name: name, imageDescriptor: .remote(url), following: false, fakeAccount: false)
            }

            let profileData = ProfileData(id: id,
                                          name: name,
                                          email: email,
                                          phone: nil,
                                          pictureUrl: pictureDataDictionary?["url"] as? String,
                                          friends: hardcodedFriends + foundFriends.values,
                                          friendsCount: friendsSummaryDictionary?["total_count"] as? Int)
            completion(profileData)
        }
    }

    fileprivate static func makeSurfers(from dictionary: [String: Any]) -> [Surfer] {
        guard let friends = dictionary["data"] as? [[String: Any]] else {
            print("No friends data included")
            return []
        }

        return friends.flatMap { item in
            guard let name = item["name"] as? String, let id = item["id"] as? String else {
                return nil
            }
            return Surfer(identifier: id, name: name, imageDescriptor: nil, following: false, fakeAccount: false)
        }
    }
}

// -----------------------------------------------------------------------------
// MARK: - Loading the profile picture

internal extension Profile {
    /// Returns `true` if `profileImage != nil`
    var isProfileImageLoaded: Bool { return profileImage != nil }

    /// Fetches the profile image from the `profileData`'s `pictureUrl`
    /// property
    func loadImage(completion: @escaping (UIImage?) -> Void) {
        // Return if we don't yet have a picture URL string
        guard let urlString = data?.pictureUrl else {
            print("No picture URL available. Canot load")
            DispatchQueue.main.async {
                completion(nil)
            }
            return
        }

        ImageLoader.sharedInstance.load(url: urlString) { [weak self] image in
            self?.profileImage = image
            completion(image)
        }
    }
}

// MARK: - Others

internal extension Profile {
    func logOutFacebook() {
        FBSDKLoginManager().logOut()
    }
}
