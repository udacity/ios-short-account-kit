//
//  Surfer+Hardcoded.swift
//  AccountKit_SampleApp
//
//  Created by Josh Svatek on 2017-05-03.
//  Copyright © 2017 Gabrielle Miller-Messner. All rights reserved.
//

import Foundation

// Some made up people

internal extension Surfer {
    /// Identifiers for fake users
    enum FakeSurfer: String {
        case kenneth, mary, tyler, crystal, evelyn, jeremy, joan, blank1, blank2, blank3, blank4
    }

    /// Fake surfers
    static func makeHardcodedSurfers() -> [Surfer] {
        return [FakeSurfer.kenneth, .mary, .tyler, .crystal, .evelyn, .jeremy, .joan ]
            .map(makeHardcodedSurfer)
    }

    static private func fullFakeName(fakeSurfer: FakeSurfer) -> String {
        switch fakeSurfer {
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

    static private func fakeImageDescriptor(fakeSurfer: FakeSurfer) -> ImageDescriptor? {
        let filename: String?
        switch fakeSurfer {
        case .kenneth: filename = "thumb-KennethFowler"
        case .mary: filename = "thumb-MaryKeller"
        case .tyler: filename = "thumb-TylerJenkins"
        case .crystal: filename = "thumb-CrystalHarris"
        case .evelyn: filename = "thumb-EvelynHall"
        case .jeremy: filename = "thumb-JeremyPalmer"
        case .joan: filename = "thumb-JoanNewman"
        case .blank1, .blank2, .blank3, .blank4: filename = nil
        }
        if let name = filename {
            return .hardcoded(name)
        } else {
            return nil
        }
    }

    static private func makeHardcodedSurfer(fakeSurfer: FakeSurfer) -> Surfer {
        return Surfer(identifier: fakeSurfer.rawValue,
                      name: fullFakeName(fakeSurfer: fakeSurfer),
                      imageDescriptor: fakeImageDescriptor(fakeSurfer: fakeSurfer),
                      following: false,
                      fakeAccount: true)
    }
}

