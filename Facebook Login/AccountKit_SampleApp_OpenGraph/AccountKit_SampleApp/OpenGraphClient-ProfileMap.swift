//
//  OpenGraphClient-ProfileMap.swift
//  AccountKit_SampleApp
//
//  Created by Josh Svatek on 2017-05-05.
//  Copyright © 2017 Gabrielle Miller-Messner. All rights reserved.
//

import Foundation
import FBSDKCoreKit

internal extension OpenGraphClient {
    /// OpenGraphClient.ProfileMap contains static methods that map results from
    /// open graph calls to `Profile`-relevant data types
    struct ProfileMap {
        /// Maps a facebook user dictionary to `FacebookProfileData`
        static func makeProfileData(with dictionary: [String: Any]) -> Profile.FacebookProfileData? {
            // Make sure we at least have an identifier, or bail
            guard let id = dictionary["id"] as? String else { return nil }

            let data = Profile.FacebookProfileData()
            data.id = id
            data.name = dictionary["name"] as? String
            data.email = dictionary["email"] as? String
            data.phone = dictionary["phone"] as? String

            if let pictureDictionary = dictionary["picture"] as? [String: Any],
                let pictureDataDictionary = pictureDictionary["data"] as? [String: Any],
                let pictureUrl = pictureDataDictionary["url"] as? String {
                data.picture = .url(pictureUrl)
            } else {
                data.picture = .none
            }
            
            return data
        }

        /// Maps an array of friend data to an array of `Surfer`s
        static func makeSurfers(with array: [[String: Any]]) -> [Surfer] {
            return array.flatMap(makeSurfer)
        }

        /// Maps a friend data dictionary to a `Surfer`
        static func makeSurfer(with dictionary: [String: Any]) -> Surfer? {
            guard let id = dictionary["id"] as? String,
                let name = dictionary["name"] as? String,
                let picture = dictionary["picture"] as? [String: Any],
                let pictureData = picture["data"] as? [String: Any],
                let url = pictureData["url"] as? String else {
                    return nil
            }
            return Surfer(identifier: id, name: name, imageUrl: url, image: nil, isFollowedByUser: false)
        }
    }
}
