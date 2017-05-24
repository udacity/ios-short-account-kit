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
        case picture = "picture"
        case friends = "friends"
    }
}

internal extension OpenGraphClient {
    /// Uses the Open Graph SDK to fetch profile data for the logged in user
    func fetchProfileDictionary(completion: @escaping ([String: Any]?, Error?) -> Void) {

        // TODO: Complete method implementation
    }

    /// Uses the Open Graph SDK for fetch friends for the logged in user

}

// -----------------------------------------------------------------------------
// MARK: - Fetching Profile Data

internal extension OpenGraphClient {
    /// Returns a `FacebookProfileData` object including friend data
    func fetchProfileData(completion: @escaping (Profile.FacebookProfileData?) -> Void) {
       // TODO: Uncomment below
        // Fetch profile data
//        fetchProfileDictionary { (dictionary, _) in
//            guard let profileData = dictionary.flatMap(ProfileMap.makeProfileData) else {
//                // No profile data
//                completion(nil)
//                return
//            }
//            
//            //Fill in the friend data
//            
//            completion(profileData)
//        }
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
    // TODO: Add makeGraphRequest() method here!

}
