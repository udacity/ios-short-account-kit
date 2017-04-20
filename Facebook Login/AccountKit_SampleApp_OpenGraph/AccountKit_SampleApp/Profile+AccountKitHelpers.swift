//
//  Profile+AccountKitHelpers.swift
//  AccountKit_SampleApp
//
//  Created by Josh Svatek on 2017-05-03.
//  Copyright © 2017 Gabrielle Miller-Messner. All rights reserved.
//

import UIKit
import AccountKit

// This file contains a helper method for updating a `Profile` using the
// AccountKit API

internal extension Profile {
    var accountKit: AKFAccountKit { return AKFAccountKit(responseType: .accessToken) }

    /// This method fetches data for the user using AccountKit, and updates
    /// the profile's `profileData` with the result
    func loadAccountKitProfileData(completion: @escaping () -> Void) {
        accountKit.requestAccount { [weak self] (account, error) in
            if let error = error {
                print("An error occurred requesting AccountKit data: \(error.localizedDescription)")
                // handle error
                DispatchQueue.main.async(execute: completion)
                return
            }

            if let account = account, let profileData = self?.makeProfileData(with: account) {
                self?.replaceProfileData(profileData)
            }

            DispatchQueue.main.async(execute: completion)
        }
    }

    private func makeProfileData(with account: AKFAccount) -> ProfileData {
        return ProfileData(id: account.accountID,
                           name: nil,
                           email: account.emailAddress,
                           phone: account.phoneNumber?.stringRepresentation(),
                           pictureUrl: nil,
                           friends: nil,
                           friendsCount: nil)
    }

    func logOutAccountKit() {
        accountKit.logOut()
    }
}
