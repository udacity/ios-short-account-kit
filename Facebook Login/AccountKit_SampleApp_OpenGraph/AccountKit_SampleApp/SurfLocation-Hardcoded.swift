//
//  SurfLocation-Hardcoded.swift
//  AccountKit_SampleApp
//
//  Created by Josh Svatek on 2017-05-03.
//  Copyright © 2017 Gabrielle Miller-Messner. All rights reserved.
//

import Foundation
import GameplayKit

internal extension SurfLocation {
    /// SurfLocation.Hardcoded contains helper methods for generating Hardcoded
    /// locations
    struct Hardcoded {
        /// Create several hardcoded locations
        static func makeLocations(for profile: Profile) -> [SurfLocation] {
            var visitors1 = someFacebookFriendIdentifiers(with: profile)
            var visitors2 = someFacebookFriendIdentifiers(with: profile)
            var visitors3 = someFacebookFriendIdentifiers(with: profile)

            if Profile.includeHardcodedSurfers {
                visitors1 += hardcodedCohort1
                visitors2 += hardcodedCohort2
                visitors3 += hardcodedCohort3
            }

            if Profile.includeTestUserSurfers {
                visitors1 += someTestUserFriendIdentifiers(with: profile)
                visitors2 += someTestUserFriendIdentifiers(with: profile)
                visitors3 += someTestUserFriendIdentifiers(with: profile)
            }

            return [
                SurfLocation(name: "Ocean Beach", conditions: .good, imageName: "imageOceanBeach", visitors: visitors1),
                SurfLocation(name: "Bolinas", conditions: .good, imageName: "imageBolinas", visitors: visitors2),
                SurfLocation(name: "Cowell's Cove", conditions: .good, imageName: "imageCowellsCove", visitors: visitors3)
            ]
        }
    }
}

// -----------------------------------------------------------------------------
// MARK: - Add real / test / hardcoded visitors to locations

internal extension SurfLocation.Hardcoded {
    /// Returns cohort 1 of fake / hardcoded surfers
    static var hardcodedCohort1: [String] {
        return makeSurferIdentifiers(for: [.evelyn, .kenneth, .crystal, .jeremy, .blank1, .blank2, .blank3])
    }

    /// Returns cohort 2 of fake / hardcoded surfers
    static var hardcodedCohort2: [String] {
        return makeSurferIdentifiers(for: [.jeremy, .joan, .tyler])
    }

    /// Returns cohort 3 of fake / hardcoded surfers
    static var hardcodedCohort3: [String] {
        return makeSurferIdentifiers(for: [.crystal, .evelyn, .blank1, .blank2])
    }

    private static func makeSurferIdentifiers(for names: [Surfer.Hardcoded.SurferName]) -> [String] {
        return names
            .map(Surfer.Hardcoded.makeHardcodedSurfer)
            .map { $0.identifier }
    }

    /// Returns ~half of the facebook friends from the specified profile
    fileprivate static func someFacebookFriendIdentifiers(with profile: Profile) -> [String] {
        return profile.friends(matching: .facebookUser).halfTheElementsShuffled.map { $0.identifier }
    }

    /// Returns ~half of the test user friends from the specified profile
    fileprivate static func someTestUserFriendIdentifiers(with profile: Profile) -> [String] {
        return profile.friends(matching: .facebookTestUser).halfTheElementsShuffled.map { $0.identifier }
    }
}

// -----------------------------------------------------------------------------
// MARK: - Helper methods

fileprivate extension Array {
    /// Returns half of the elements of the array (rounding up), shuffled.
    var halfTheElementsShuffled: [Element] {
        if count == 0 { return [] }
        if count == 1 { return self }
        let shuffledArray = GKRandomSource().arrayByShufflingObjects(in: self) as! Array<Element>
        let lastIndex =  Int(ceil(Double(shuffledArray.count) / 2))
        return Array<Element>(shuffledArray[0..<lastIndex])
    }

}
