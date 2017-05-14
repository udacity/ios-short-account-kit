//
//  AccountKitClient.swift
//  AccountKit_SampleApp
//
//  Created by Josh Svatek on 2017-05-05.
//  Copyright © 2017 Gabrielle Miller-Messner. All rights reserved.
//

import UIKit
import AccountKit

// This class implements helper methods for using Facebook SDK methods with our
// data model

internal final class AccountKitClient {
    static let sharedInstance = AccountKitClient()

    var accountKit: AKFAccountKit { return AKFAccountKit(responseType: .accessToken) }
}

// -----------------------------------------------------------------------------
// MARK: - Requesting account kit data

internal extension AccountKitClient {
    /// Uses Account Kit to fetch an AKFAccount object
    func fetchAccount(completion: @escaping (AKFAccount?, Error?) -> Void) {
        accountKit.requestAccount { (account, error) in
            if let error = error {
                print("An error occurred requesting AccountKit data: \(error.localizedDescription)")
            }
            completion(account, error)
        }
    }
}

// -----------------------------------------------------------------------------
// MARK: - Requesting AccountKitProfileData

internal extension AccountKitClient {
    /// Returns an `AccountKitProfileData` object
    func fetchProfileData(completion: @escaping (Profile.AccountKitProfileData?) -> Void) {
        // Fetch an account
        fetchAccount { (account, _) in
            // Create profile data or nil
            let profileData = account.flatMap(ProfileMap.makeProfileData)
            completion(profileData)
        }
    }
}

// -----------------------------------------------------------------------------
// MARK: - Logout

internal extension AccountKitClient {
    func logOut() {
        accountKit.logOut()
    }
}
