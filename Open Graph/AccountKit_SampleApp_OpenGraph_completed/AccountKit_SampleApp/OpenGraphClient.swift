//
//  OpenGraphClient.swift
//  AccountKit_SampleApp
//
//  Created by Josh Svatek on 2017-05-05.
//  Copyright © 2017 Gabrielle Miller-Messner. All rights reserved.
//

import UIKit
import FBSDKLoginKit

// This class implements helper methods for using Facebook SDK methods with our
// data model

internal final class OpenGraphClient {
    static let sharedInstance = OpenGraphClient()
}

// -----------------------------------------------------------------------------
// MARK: - Fetching open graph content

fileprivate extension OpenGraphClient {
    enum FieldType: String {
        case id, name, email, picture, friends
    }
}

internal extension OpenGraphClient {
    /// Uses the Open Graph SDK to fetch profile data for the logged in user
    func fetchProfileDictionary(completion: @escaping ([String: Any]?, Error?) -> Void) {
        let graphRequest = makeGraphRequest(path: "me", fields: [.id, .name, .email, .picture])
        graphRequest.start { (_, result, error) in
            if let error = error {
                print("Error fetching facebook user data: \(error)")
            }
            completion(result as? [String: Any], error)
        }
    }

    /// Uses the Open Graph SDK for fetch friends for the logged in user
    func fetchProfileFriends(completion: @escaping ([[String: Any]]?, Error?) -> Void) {
        let graphRequest = makeGraphRequest(path: "me/friends", fields: [.id, .name, .picture])
        graphRequest.start { (_, result, error) in
            if let error = error {
                print("Error fetching friends: \(error)")
            }
            let resultDict = result as? [String: Any]
            let friendDicts = resultDict?["data"] as? [[String: Any]]
            completion(friendDicts, error)
        }
    }
}

// -----------------------------------------------------------------------------
// MARK: - Fetching Profile Data

internal extension OpenGraphClient {
    /// Returns a `FacebookProfileData` object including friend data
    func fetchProfileData(completion: @escaping (Profile.FacebookProfileData?) -> Void) {
        // Fetch profile data
        fetchProfileDictionary { (dictionary, _) in
            guard let profileData = dictionary.flatMap(ProfileMap.makeProfileData) else {
                // No profile data
                completion(nil)
                return
            }

            // Fill in the friend data
            self.fetchProfileFriends { (result, error) in
                guard let friends = result.flatMap(ProfileMap.makeFacebookSurfers) else {
                    // No additional friend data
                    completion(profileData)
                    return
                }

                // Add the test users if we're configured to do so
                if Profile.includeTestUserSurfers {
                    TestUsers.makeTestUserSurfers { testUserSurfers in
                        // Augment with test users
                        profileData.friends = friends + testUserSurfers
                        completion(profileData)
                    }
                } else {
                    // Not using test users
                    profileData.friends = friends
                    completion(profileData)
                }
            }
        }
    }
}

// -----------------------------------------------------------------------------
// MARK: - Logout

internal extension OpenGraphClient {
    func logOut() {
        FBSDKLoginManager().logOut()
    }
}

// -----------------------------------------------------------------------------
// MARK: - Private helper methods

fileprivate extension OpenGraphClient {
    /// Construct a graph request
    func makeGraphRequest(path: String, fields: [FieldType]) -> FBSDKGraphRequest {
        let fieldsString = fields
            .map { $0.rawValue }
            .joined(separator: ",")

        guard let graphRequest = FBSDKGraphRequest(graphPath: path, parameters: ["fields" : fieldsString]) else {
            fatalError("Unable to create graph request")
        }
        return graphRequest
    }
}
