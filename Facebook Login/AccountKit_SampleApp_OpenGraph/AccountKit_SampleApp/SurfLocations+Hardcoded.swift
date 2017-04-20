//
//  SurfLocations+Hardcoded.swift
//  AccountKit_SampleApp
//
//  Created by Josh Svatek on 2017-05-03.
//  Copyright © 2017 Gabrielle Miller-Messner. All rights reserved.
//

import Foundation

// Some hardcoded locations

internal extension SurfLocation {
    static func makeHardcodedLocations() -> [SurfLocation] {
        let surfers1 = [Surfer.FakeSurfer.evelyn, .kenneth, .crystal, .jeremy, .blank1, .blank2, .blank3].map { $0.rawValue }
        let surfers2 = [Surfer.FakeSurfer.jeremy, .joan, .tyler].map { $0.rawValue }
        let surfers3 = [Surfer.FakeSurfer.crystal, .evelyn, .blank1, .blank2].map { $0.rawValue }
        return [
            SurfLocation(name: "Ocean Beach", conditions: .good, visitors: surfers1, imageName: "imageOceanBeach"),
            SurfLocation(name: "Bolinas", conditions: .fair, visitors: surfers2, imageName: "imageBolinas"),
            SurfLocation(name: "Cowell's Cove", conditions: .poor, visitors: surfers3, imageName: "imageCowellsCove")
        ]
    }
}
