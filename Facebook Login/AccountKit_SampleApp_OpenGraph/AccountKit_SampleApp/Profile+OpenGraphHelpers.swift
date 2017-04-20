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
            if let dictionary = dictionary, let profileData = Profile.makeProfileData(with: dictionary) {
                self.replaceProfileData(profileData)
            }
            DispatchQueue.main.async {
                completion()
            }
        }
    }

    /// Maps a dictionary of data returned by `FBSDKGraphRequest` -> ProfileData
    fileprivate static func makeProfileData(with dictionary: [String: Any]) -> ProfileData? {
        // We must at least have the identifier. The rest is optional.
        guard let id = dictionary["id"] as? String else {
            return nil
        }

        let name = dictionary["name"] as? String
        let email = dictionary["email"] as? String
        let pictureDictionary = dictionary["picture"] as? [String: Any]
        let pictureDataDictionary = pictureDictionary?["data"] as? [String: Any]
        let friendsDictionary = dictionary["friends"] as? [String: Any]
        let friendsSummaryDictionary = friendsDictionary?["summary"] as? [String: Any]

        // For the friends, we'll mix in some hardcoded people with whatever we
        // get back

        let hardcodedFriends = Surfer.makeHardcodedSurfers()
        let foundFriends: [Surfer] = [] // From freindsDictionary?["data"]

        return ProfileData(id: id,
                           name: name,
                           email: email,
                           phone: nil,
                           pictureUrl: pictureDataDictionary?["url"] as? String,
                           friends: hardcodedFriends + foundFriends,
                           friendsCount: friendsSummaryDictionary?["total_count"] as? Int)
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

        // Ensure we can form a URL
        guard let url = URL(string: urlString) else {
            fatalError("Could not construct URL from string \(urlString)")
        }

        // Create and result a data task on the shared URLSession
        let dataTask = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            DispatchQueue.main.async {
                if let data = data, let image = UIImage(data: data) {
                    self?.profileImage = image
                    completion(image)
                } else {
                    completion(nil)
                }
            }
        }
        dataTask.resume()
    }
}

// MARK: - Others

internal extension Profile {
    func logOutFacebook() {
        FBSDKLoginManager().logOut()
    }
}
