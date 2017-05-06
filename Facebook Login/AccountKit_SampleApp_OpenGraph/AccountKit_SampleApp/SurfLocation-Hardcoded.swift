//
//  SurfLocation-Hardcoded.swift
//  AccountKit_SampleApp
//
//  Created by Josh Svatek on 2017-05-03.
//  Copyright © 2017 Gabrielle Miller-Messner. All rights reserved.
//

import Foundation

internal extension SurfLocation {
    /// SurfLocation.Hardcoded contains helper methods for generating Hardcoded
    /// locations
    struct Hardcoded {
        /// Create several hardcoded locations
        static func makeLocations() -> [SurfLocation] {
            return [
                SurfLocation(name: "Ocean Beach", conditions: .good, imageName: "imageOceanBeach", visitors: surferCohort1),
                SurfLocation(name: "Bolinas", conditions: .good, imageName: "imageBolinas", visitors: surferCohort2),
                SurfLocation(name: "Cowell's Cove", conditions: .good, imageName: "imageCowellsCove", visitors: surferCohort3)
            ]
        }
    }
}

// -----------------------------------------------------------------------------
// MARK: - Add fake / hardcoded visitors to locations

internal extension SurfLocation.Hardcoded {
    /// Returns cohort 1 of fake / hardcoded surfers
    static var surferCohort1: [String] {
        return makeSurferIdentifiers(for: [.evelyn, .kenneth, .crystal, .jeremy, .blank1, .blank2, .blank3])
    }

    /// Returns cohort 2 of fake / hardcoded surfers
    static var surferCohort2: [String] {
        return makeSurferIdentifiers(for: [.jeremy, .joan, .tyler])
    }

    /// Returns cohort 3 of fake / hardcoded surfers
    static var surferCohort3: [String] {
        return makeSurferIdentifiers(for: [.crystal, .evelyn, .blank1, .blank2])
    }

    private static func makeSurferIdentifiers(for names: [Surfer.Hardcoded.SurferName]) -> [String] {
        return names
            .map(Surfer.Hardcoded.makeSurfer)
            .map { $0.identifier }
    }
}
