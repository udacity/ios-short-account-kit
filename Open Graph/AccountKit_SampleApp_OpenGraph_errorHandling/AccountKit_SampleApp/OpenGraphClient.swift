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
        case id = "id"
        case name = "name"
        case email = "email"
        case picture = "picture.width(300).height(300)"
        case friends = "friends"
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

    // MARK: Error Handling Demo
    
    func postToFeed() {
        let params = ["message": "This message probably won't post"]
        guard let postRequest = FBSDKGraphRequest(graphPath:"me/feed", parameters: params, httpMethod: "POST") else {
            fatalError("Unable to create graph request")
        }
        
        postRequest.start { (_, result, error) in
            if let error = error as NSError? {
                let errorDict = error.userInfo
                let errorCode = errorDict[FBSDKGraphRequestErrorGraphErrorCode] as? Int64
                
                if errorCode == 200 {
                    self.requestMorePermissions()
                }
                
                print("Error posting to feed: \(error)")
            }
        }
    }
    
    func createErrorAlert(withMessage message: String) {
        let alertController = UIAlertController(title: "Something is Amiss", message: message, preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
            (result : UIAlertAction) -> Void in
            print("OK")
        }
        alertController.addAction(okAction)
        UIApplication.shared.keyWindow?.rootViewController?.present(alertController, animated: true, completion: nil)
    }

func requestMorePermissions() {
    let fbLoginManager: FBSDKLoginManager = FBSDKLoginManager()
    let rootViewController = UIApplication.shared.keyWindow?.rootViewController
    
    fbLoginManager.logIn(withPublishPermissions: ["publish_actions"], from: rootViewController) { (result, error) in
        
        if let error = error {
            print("Login failed with error: \(error)")
        } else if (result?.isCancelled)!{
            //Handle cancellation
        } else {
            let grantedPermissions = result?.grantedPermissions
            
            // Request the data you have been granted permission to access
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

    // Construct a POST request
    func makePostRequest(path: String, parameters: [String: String], httpMethod: String) -> FBSDKGraphRequest {
        let params = ["message": "This message probably won't post"]
        guard let postRequest = FBSDKGraphRequest(graphPath:path, parameters: params, httpMethod: httpMethod) else {
            fatalError("Unable to create graph request")
        }
        return postRequest
    }
}

