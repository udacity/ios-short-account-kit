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
    ///
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

    ///
    func fetchProfilePicture(identifier: String, completion: @escaping (String?) -> Void) {
        guard let graphRequest = FBSDKGraphRequest(graphPath: "\(identifier)/picture", parameters:  ["type": "normal"]) else {
            fatalError("Unable to create graph request")
        }
        _ = graphRequest.start { (_, result, error) in
            if let error = error {
                print("Unable to fetch facebook user picture: \(error)")
                // Handle error
                completion(nil)
                return
            }

            // Call the completion handler with the result
            if let dictionary = result as? [String: Any], let url = dictionary["url"] as? String {
                completion(url)
            } else {
                print("Unexpected result format in picture request")
                // Handle
                completion(nil)
            }
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
