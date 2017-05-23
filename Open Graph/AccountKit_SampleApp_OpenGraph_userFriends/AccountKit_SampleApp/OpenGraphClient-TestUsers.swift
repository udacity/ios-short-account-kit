//
//  OpenGraphClient-TestUsers.swift
//  AccountKit_SampleApp
//
//  Created by Josh Svatek on 2017-05-05.
//  Copyright © 2017 Gabrielle Miller-Messner. All rights reserved.
//

import UIKit
import FBSDKCoreKit

internal extension OpenGraphClient {
    /// `TestUsers` provides helper methods for creating and fetching test users
    struct TestUsers {
        /// `FBSDKTestUsersManager` provides methods for most of the test user
        /// operations we will perform. We'll construct `FBSDKGraphRequest`s
        /// for the others.

        static var primaryToken: FBSDKAccessToken?
    }
}

// -----------------------------------------------------------------------------
// MARK: - Making Surfers from test users

internal extension OpenGraphClient.TestUsers {
    ///
    static func makeTestUserSurfers(completion: @escaping ([Surfer]) -> Void) {
//        createTestAccounts {
//            makeSurfers(completion: completion)
//        }
    }

    ///
    private static func makeSurfers(completion: @escaping ([Surfer]) -> Void) {
        guard let primaryTestUserTokenString = primaryToken?.tokenString else {
            print("Unable to create test users. Called makeSurfers() before primary token was set.")
            completion([])
            return
        }

        // Construct a request using the primary test user's token
        let request = FBSDKGraphRequest(graphPath: "me/friends",
                                        parameters: ["fields": "id,name,picture"],
                                        tokenString: primaryTestUserTokenString,
                                        version: nil,
                                        httpMethod: "GET")!

        // Execute the request (use `ProfileMap` to construct the `Surfer`s)
        request.start { (_, result, error) in
            if let error = error {
                fatalError("Error fetching test user friends: \(error.localizedDescription)")
            }
            guard let dict = result as? [String: Any], let friendsArray = dict["data"] as? [[String: Any]] else {
                fatalError("Unexpected result type")
            }

            let surfers = OpenGraphClient.ProfileMap.makeTestUserSurfers(with: friendsArray)
            completion(surfers)
        }
    }
}

// -----------------------------------------------------------------------------
// MARK: - Creating and configuring test users

internal extension OpenGraphClient.TestUsers {
    /// Fetches or creates a set of test user accounts, configures them set
    /// names, and makes each of them friends with the first (primary) test user


//    private static func handleTestAccountsResponse(tokens allTokens: [FBSDKAccessToken], completion: @escaping () -> Void) {
//        // Separate out the tokens into a primary + the rest
//        self.primaryToken = allTokens[0]
//        self.tokens = Array(allTokens.dropFirst(1))
//
//        // Rename all the test users (including the primary)
//        updateNames(allTokens: allTokens)
//
//        // Make all the non-primary test users friends with the primary
//        makeFriends(primaryToken: primaryToken!, otherTokens: self.tokens)
//
//        dispatchGroup.notify(queue: .main) {
//            completion()
//        }
//    }
}
