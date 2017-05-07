//
//  Surfer-Hardcoded.swift
//  AccountKit_SampleApp
//
//  Created by Josh Svatek on 2017-05-03.
//  Copyright © 2017 Gabrielle Miller-Messner. All rights reserved.
//

import UIKit

internal extension Surfer {
    /// Surfer.Hardcoded contains helper methods for generating Hardcoded
    /// surfers / friends
    struct Hardcoded {
        /// Identifiers for hardcoded users
        enum SurferName: String {
            case kenneth, mary, tyler, crystal, evelyn, jeremy, joan, blank1, blank2, blank3, blank4
        }

        /// Fake surfers
        static func makeSurfers() -> [Surfer] {
            return [SurferName.kenneth, .mary, .tyler, .crystal, .evelyn, .jeremy, .joan ]
                .map(makeHardcodedSurfer)
        }

        static func makeHardcodedSurfer(name: SurferName) -> Surfer {
            let fullName = fullFakeName(for: name)
            let image = imageName(for: name).flatMap(UIImage.init(named:))
            return Surfer(identifier: name.rawValue,
                          name: fullName,
                          surferType: .hardcoded,
                          imageUrl: nil,
                          image: image,
                          isFollowedByUser: false)
        }
    }
}

// -----------------------------------------------------------------------------
// MARK: - Private helper methods

fileprivate extension Surfer.Hardcoded {
    /// Full names for hardcoded surfers
    static func fullFakeName(for name: SurferName) -> String {
        switch name {
        case .kenneth: return "Kenneth Fowler"
        case .mary: return "Mary Keller"
        case .tyler: return "Tyler Jenkins"
        case .crystal: return "Crystal Harris"
        case .evelyn: return "Evelyn Hall"
        case .jeremy: return "Jeremy Palmer"
        case .joan: return "Joan Newman"
        case .blank1: return "Blank1"
        case .blank2: return "Blank2"
        case .blank3: return "Blank3"
        case .blank4: return "Blank4"
        }
    }

    /// Image names for hardcoded surfers
    static func imageName(for name: SurferName) -> String? {
        switch name {
        case .kenneth: return "thumb-KennethFowler"
        case .mary: return "thumb-MaryKeller"
        case .tyler: return "thumb-TylerJenkins"
        case .crystal: return "thumb-CrystalHarris"
        case .evelyn: return "thumb-EvelynHall"
        case .jeremy: return "thumb-JeremyPalmer"
        case .joan: return "thumb-JoanNewman"
        case .blank1, .blank2, .blank3, .blank4: return nil
        }
    }
}
