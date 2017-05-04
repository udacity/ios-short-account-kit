//
//  Surfer.swift
//  AccountKit_SampleApp
//
//  Created by Josh Svatek on 2017-04-20.
//  Copyright © 2017 Gabrielle Miller-Messner. All rights reserved.
//

import Foundation

// This is a simple struct that describes another user that the current user
// is connected to via a social graph. In this example we only track the
// name, profileImage and whether or not the surfer is tracking the current
// user.

/// A simple struct describing another surfer
internal struct Surfer {
    let identifier: String

    /// The surfer's full name
    let name: String

    /// To bootstrap our example, we include a number of hardcoded users with
    /// hardcoded profile images. The `imageDescriptor` holds either a `real`
    /// remote image URL, or a hardcoded image name
    let imageDescriptor: ImageDescriptor?

    /// Indicates if this Surfer is following the current user.
    var following = false

    /// A flag indicating this is a fake user account
    let fakeAccount: Bool
}

internal extension Surfer {
    /// Describes a hardcoded (fake) image name or remote (real) image URL
    enum ImageDescriptor {
        case hardcoded(String) // Local image name
        case remote(String) // URL string
    }
}
