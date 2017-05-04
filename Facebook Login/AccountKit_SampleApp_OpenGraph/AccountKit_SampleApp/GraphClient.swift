//
//  GraphClient.swift
//  AccountKit_SampleApp
//
//  Created by Josh Svatek on 2017-05-01.
//  Copyright © 2017 Gabrielle Miller-Messner. All rights reserved.
//

import UIKit
import FBSDKCoreKit

// GraphClient provides an interface for fetching profile and other data
// via the Facebook graph API via `FBSDKGraphRequest` and 
// `FBSDKGraphRequestConnection`.

internal struct GraphClient { }

// MARK: - Updating profile information

internal extension GraphClient {
    /// Fetches a dictionary of user content for the current profile
    func fetchProfileDictionary(for profile: Profile, completion: @escaping ([String: Any]?, Error?) -> Void) {
        // Make sure this is a Facebook login
        guard profile.isFacebookLogin else {
            print("We can only perform Open Graph API calls for Facebook logins.")
            return
        }

        // Ensure we can create a graph request
        let parameters = ["fields": fields.joined(separator: ",")]
        guard let graphRequest = FBSDKGraphRequest(graphPath: "me", parameters: parameters) else {
            fatalError("Unable to create graph request")
        }

        // Make the request
        _ = graphRequest.start { (_, result, error) in
            if let error = error {
                print("Unable to fetch facebook user dictionary: \(error)")
                // Handle error
                completion(nil, error)
                return
            }

            // Call the completion handler with the result
            completion(result as? [String: Any], error)
        }
    }

    /// Fetches an array of friend dictionaries including picture urls
    func fetchProfileFriends(completion: @escaping ([[String: Any]]?, Error?) -> Void) {
        let fields: [FieldType] = [.id, .name, .picture]
        let parameters = ["fields": fields.map{($0.rawValue)}.joined(separator: ",")]
        guard let graphRequest = FBSDKGraphRequest(graphPath: "me/friends", parameters: parameters) else {
            fatalError("Unable to create graph request")
        }

        _ = graphRequest.start { (_, result, error) in
            if let error = error {
                print("Error fetching friends: \(error)")
            }

            let data = (result as? [String: Any])?["data"] as? [[String: Any]]
            completion(data, error)
        }
    }

    // Profile field types

    fileprivate enum FieldType: String {
        case id, name, email, picture, friends
    }

    fileprivate var fields: [String] {
        return [FieldType.id, .name, .email, .picture, .friends]
            .map { $0.rawValue }
    }

}
