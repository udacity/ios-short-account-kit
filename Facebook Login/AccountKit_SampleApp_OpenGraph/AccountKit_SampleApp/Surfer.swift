//
//  Surfer.swift
//  AccountKit_SampleApp
//
//  Created by Josh Svatek on 2017-04-20.
//  Copyright © 2017 Gabrielle Miller-Messner. All rights reserved.
//

import UIKit

// A surfer is a minimal class that describes another user of the system that
// the logged-in user is connected with via a social graph.

/// A simple struct describing another surfer
internal final class Surfer {
    let identifier: String

    /// The surfer's full name
    let name: String

    /// The `SurferType` (real facebook user, test facebook user, or hardcoded)
    let surferType: SurferType

    /// An URL for the user's profile image, if available
    let imageUrl: String?

    /// An image for the user, if available
    var image: UIImage?

    /// Indicates if the Surfer is being followd by the logged-in user
    var isFollowedByUser: Bool

    init(identifier: String, name: String, surferType: SurferType, imageUrl: String? = nil, image: UIImage? = nil, isFollowedByUser: Bool = false) {
        self.identifier = identifier
        self.name = name
        self.surferType = surferType
        self.imageUrl = imageUrl
        self.image = image
        self.isFollowedByUser = isFollowedByUser
    }

    enum SurferType { case facebookUser, facebookTestUser, hardcoded }
}

// -----------------------------------------------------------------------------
// MARK: - Image loading

internal extension Surfer {
    /// Returns `true` if the `Surfer` has no `image`, but has an `imageUrl`
    var readyToLoadImage: Bool { return image == nil && imageUrl != nil }

    /// Loads the Surfer's profile image if an URL is set and the image is not
    /// already loaded
    func loadImage(completion: @escaping (UIImage?) -> Void) {
        guard let imageUrl = imageUrl else {
            print("Can't load image – no image URL is set")
            return
        }
        ImageLoader.sharedInstance.load(url: imageUrl) { image in
            if let image = image {
                self.image = image
            }
            DispatchQueue.main.async { completion(image) }
        }
    }
}
