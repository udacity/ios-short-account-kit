//
//  AccountKitClient-ProfileMap.swift
//  AccountKit_SampleApp
//
//  Created by Josh Svatek on 2017-05-05.
//  Copyright © 2017 Gabrielle Miller-Messner. All rights reserved.
//

import UIKit
import AccountKit

internal extension AccountKitClient {
    /// AccoutKitClient.ProfileMap contains static methods that map results from
    /// an AKFAccount object to `Profile`-relevant data types
    struct ProfileMap {
        /// Maps an account kit AKFAccount object to `AccountKitProfileData`
        static func makeProfileData(with account: AKFAccount) -> Profile.AccountKitProfileData {
            let profileData = Profile.AccountKitProfileData()
            profileData.email = account.emailAddress
            profileData.phone = account.phoneNumber?.stringRepresentation()
            return profileData
        }
    }
}
