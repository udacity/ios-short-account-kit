//
//  Profile.swift
//  AccountKit_SampleApp
//
//  Created by Josh Svatek on 2017-04-27.
//  Copyright © 2017 Gabrielle Miller-Messner. All rights reserved.
//

import UIKit
import AccountKit
import FBSDKCoreKit

// A profile contains information about the current logged in user. The profile
// can have either a Facebook or AccountKit login type. In this example, the
// profile's data is stored in a `ProfileData` struct associated with the
// login type to allow the profile data. (For example, we might want different
// profile data types for the two login types.)

internal final class Profile {
    var profileImage: UIImage?

    /// A profile can be logged in via Facebook (`.facebook`), AccountKit
    /// (`.accountKit`) or not logged in (`.none`). A non-`.none` login type
    /// has an access token associated with it, and optionally profile data.
    var loginType: LoginType

    init(loginType: LoginType = .none) {
        self.loginType = loginType
    }
}


internal extension Profile {
    /// The login type for the current profile. The `data` struct is identical
    /// in both cases, but need not be.
    enum LoginType {
        case none
        case facebook(token: FBSDKAccessToken, data: ProfileData?)
        case accountKit(token: AKFAccessToken, data: ProfileData?)
    }

    struct ProfileData {
        let id: String
        let name: String?
        let email: String?
        let phone: String?
        let pictureUrl: String?
        let friends: [Surfer]?
        let friendsCount: Int?
    }

    /// Loads profile data
    func loadProfileData(completion: @escaping () -> Void) {
        switch loginType {
        case .facebook: loadFacebookProfileData(completion: completion)
        case .accountKit: loadAccountKitProfileData(completion: completion)
        case .none: ()
        }
    }

    /// A helper method that replaces `profileData` with the supplied `ProfileData`
    func replaceProfileData(_ profileData: ProfileData) {
        switch loginType {
        case let .facebook(token: token, data: _): loginType = .facebook(token: token, data: profileData)
        case let .accountKit(token: token, data: _): loginType = .accountKit(token: token, data: profileData)
        case .none: ()
        }
    }

    func logOut() {
        switch loginType {
        case .facebook: logOutFacebook()
        case .accountKit: logOutAccountKit()
        case .none: ()
        }
    }
}

// -----------------------------------------------------------------------------
// MARK: - Convenience initializers

internal extension Profile{
    /// A convenience initializer that creates a new `Profile` with login type
    /// `.facebook` with the provided token and `data = nil`
    convenience init(token: FBSDKAccessToken) {
        self.init(loginType: .facebook(token: token, data: nil))
    }

    /// A convenience initializer that creates a new `Profile` with login type
    /// `.accountKit` with the provided token and `data = nil`
    convenience init(token: AKFAccessToken) {
        self.init(loginType: .accountKit(token: token, data: nil))
    }
}

// -----------------------------------------------------------------------------
// MARK: - Convenience computed properties

internal extension Profile {
    /// Returns `true` if the profile is logged in via Facebook
    var isFacebookLogin: Bool {
        if case .facebook = loginType { return true }
        return false
    }

    /// Returns `true` if the profile is logged in via AccountKit
    var isAccountKitLogin: Bool {
        if case .accountKit = loginType { return true }
        return false
    }

    /// Returns the `ProfileData` if the user is logged in and any is available
    var data: ProfileData? {
        switch loginType {
        case let .facebook(_, data): return data
        case let .accountKit(_, data): return data
        case .none: return nil
        }
    }

    /// Returns `true` if the `Profile`'s `ProfileData is non-`nil`
    var isDataLoaded: Bool { return data != nil }

    /// Returns a `FBSDKAccessToken` if the user has logged in with Facebook
    var facebookToken: FBSDKAccessToken? {
        if case let .facebook(token, _) = loginType {
            return token
        }
        return nil
    }

    /// Returns a `AKFAccessToken` if the user has logged in with Account Kit
    var accountKitToken: AKFAccessToken? {
        if case let .accountKit(token, _) = loginType {
            return token
        }
        return nil
    }
}


