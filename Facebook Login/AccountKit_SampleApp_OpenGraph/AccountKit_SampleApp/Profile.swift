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
// profile's data is stored in a data class associated with the login type.

internal final class Profile {
    /// A profile can be logged in via Facebook (`.facebook`), AccountKit
    /// (`.accountKit`) or not logged in (`.none`). A non-`.none` login type
    /// has an access token associated with it, and optionally profile data.
    var loginType: LoginType

    /// A configuration option that will augment the facebook-fetched users
    /// with a set of hardcoded users to demonstrate the UI
    static let includeHardcodedSurfers = true

    /// A configuration option that will augment the facebook-fetched real users
    /// with several facebook test users created programatically as needed
    static let includeTestUserSurfers = true

    init(loginType: LoginType = .none) {
        self.loginType = loginType
    }

    /// The login type for the current profile. The `data` struct is identical
    /// in both cases, but need not be.
    enum LoginType {
        case none
        case accountKit(token: AKFAccessToken, data: AccountKitProfileData?)
        case facebook(token: FBSDKAccessToken, data: FacebookProfileData?)
    }

    convenience init(token: AKFAccessToken) {
        self.init(loginType: .accountKit(token: token, data: nil))
    }

    convenience init(token: FBSDKAccessToken) {
        self.init(loginType: .facebook(token: token, data: nil))
    }
}

// -----------------------------------------------------------------------------
// MARK: - Profile data that is specific to the login type

internal extension Profile {
    class BaseProfileData {
        /// A unique identifier for the user
        var id: String?

        /// The full name of the user
        var name: String?

        /// The email address associated with the user
        var email: String?

        /// The phone number associated with the user represented as a String
        var phone: String?
    }

    final class AccountKitProfileData: BaseProfileData { }

    final class FacebookProfileData: BaseProfileData {
        /// The profile picture for the user. Always `.none` for a non-Facebook
        /// login.
        var picture: ProfilePicture = .none

        /// Friends that have authorized the app. Always `[]` for a non-Facebook
        /// login.
        var friends: [Surfer] = []

        /// The total friend count for the user. (May be different than the friends
        /// we can see who have authorized the app.)
        var friendsTotalCount: Int?
    }

    /// A `ProfilePicture` can be either an URL for an image, the image itself,
    /// or none.
    enum ProfilePicture {
        case none
        case url(String)
        case image(UIImage)
    }

    func update(profileData: FacebookProfileData) {
        guard let token = facebookToken else { fatalError("Can only call on facebook login types") }
        loginType = .facebook(token: token, data: profileData)
    }

    func update(profileData: AccountKitProfileData) {
        guard let token = accountKitToken else { fatalError("Can only call on account kit login types") }
        loginType = .accountKit(token: token, data: profileData)
    }

    func update(picture: ProfilePicture) {
        guard let token = facebookToken, let data = facebookData else { fatalError("Error: Can only call on facebook login types, or login data not yet loaded") }
        data.picture = picture
        loginType = .facebook(token: token, data: data)
    }
}


// -----------------------------------------------------------------------------
// MARK: - Loading data

internal extension Profile {
    /// Calls a load method for the associated login type. Fetches image URLs
    /// but does not immediately fetch image data.
    func loadProfileData(completion: @escaping () -> Void) {
        switch loginType {
        case .facebook: loadFacebookProfileData(completion: completion)
        case .accountKit: loadAccountKitProfileData(completion: completion)
        case .none: ()
        }
    }

    /// If no profile image is set but an image URL is available, attempts to
    /// load the image data
    func loadProfileImage(completion: @escaping (UIImage?) -> Void) {
        if let picture = facebookData?.picture, case let .url(url) = picture {
            ImageLoader.sharedInstance.load(url: url) { [weak self] image in
                if let image = image {
                    self?.update(picture: .image(image))
                }
                completion(image)
            }
        } else {
            completion(nil)
        }
    }

    private func loadFacebookProfileData(completion: @escaping () -> Void) {
        OpenGraphClient.sharedInstance.fetchProfileData { [weak self] profileData in
            if let profileData = profileData {
                if Profile.includeHardcodedSurfers {
                    profileData.friends += Surfer.Hardcoded.makeSurfers()
                }
                self?.update(profileData: profileData)
            }
            completion()
        }
    }

    private func loadAccountKitProfileData(completion: @escaping () -> Void) {
        AccountKitClient.sharedInstance.fetchProfileData { [weak self] profileData in
            if let profileData = profileData {
                self?.update(profileData: profileData)
            }
            completion()
        }
    }

    func loadFriendsProfilePictures(completion: @escaping () -> Void) {
        guard let surfers = facebookData?.friends, !surfers.isEmpty else {
            print("Facebook data not loaded, not a facebook login, or no friends")
            completion()
            return
        }
        ImageLoader.sharedInstance.loadImages(for: surfers, completion: completion)
    }
}

// -----------------------------------------------------------------------------
// MARK: - Logging out

extension Profile {
    /// Log out of an AccountKit or Facebook login
    func logOut() {
        switch loginType {
        case .facebook: OpenGraphClient.sharedInstance.logOut()
        case .accountKit: AccountKitClient.sharedInstance.logOut()
        case .none: ()
        }
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

    /// Returns the associated `FacebookProfileData` if the user is logged in
    /// via Facebook and the data is available
    var facebookData: FacebookProfileData? {
        switch loginType {
        case let .facebook(_, data): return data
        case .accountKit, .none: return nil
        }
    }

    /// Returns the associated `AccountKitProfileData` if the user is logged in
    /// via AccountKit and the data is available
    var accountKitData: AccountKitProfileData? {
        switch loginType {
        case let .accountKit(_, data): return data
        case .facebook, .none: return nil
        }
    }

    /// Returns `true` if the `Profile`'s AK or FB data is non-`nil`
    var isDataLoaded: Bool { return facebookData != nil || accountKitData != nil }

    /// Returns a image if the profile picture is loaded, or nil
    var profileImage: UIImage? {
        switch facebookData?.picture {
        case let .image(image)?: return image
        default: return nil
        }
    }

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
