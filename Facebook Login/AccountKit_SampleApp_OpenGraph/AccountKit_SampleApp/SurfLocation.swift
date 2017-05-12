//
//  SurfLocation.swift
//  AccountKit_SampleApp
//
//  Created by Josh Svatek on 2017-04-20.
//  Copyright © 2017 Gabrielle Miller-Messner. All rights reserved.
//

import UIKit

// A surf location

internal final class SurfLocation {
    /// The user-visible name for the location
    internal let name: String

    /// The conditions at this location
    internal let conditions: Conditions

    /// The identifiers of people visiting this location
    internal var visitors: [String]

    /// The name of an image for the location
    internal let imageName: String

    init(name: String, conditions: Conditions, imageName: String, visitors: [String] = []) {
        self.name = name
        self.conditions = conditions
        self.imageName = imageName
        self.visitors = visitors
    }

    func add(surfer: Surfer) {
        visitors.append(surfer.identifier)
    }

    func add(surfers: [Surfer]) {
        visitors.append(contentsOf: surfers.map({ $0.identifier }))
    }
}

// MARK: - Conditions

extension SurfLocation {
    /// Describes the conditions at a `SurfLocation`
    internal enum Conditions {
        case good, fair, poor
    }
}

// MARK: - Helper methods

extension SurfLocation {
    /// Returns a styled `NSAttributedString` describing the current conditions
    internal var conditionsAttributedString: NSAttributedString {
        let firstAttributes = [
            NSFontAttributeName : Appearance.Fonts.tiny,
            NSForegroundColorAttributeName : tintColor(for: conditions)
        ]
        let attributedString = NSMutableAttributedString(string: conditions.descriptiveStringForWaves + " ", attributes: firstAttributes)

        let secondAttributes = [
            NSFontAttributeName : Appearance.Fonts.tiny,
            NSForegroundColorAttributeName : Appearance.Colors.gray
        ]
        attributedString.append(NSAttributedString(string: conditions.heightStringForWaves, attributes: secondAttributes))

        return attributedString.copy() as! NSAttributedString
    }

    private func tintColor(for conditions: Conditions) -> UIColor {
        switch conditions {
        case .good: return Appearance.Colors.green
        case .fair: return Appearance.Colors.orange
        case .poor: return Appearance.Colors.red
        }
    }
}

extension SurfLocation.Conditions {
    /// Returns a wave-oriented `String` describing the conditions
    fileprivate var descriptiveStringForWaves: String {
        switch self {
        case .good: return "GOOD WAVES"
        case .fair: return "FAIR WAVES"
        case .poor: return "POOR WAVES"
        }
    }

    /// Returns a `String` describing the wave height for the conditions
    fileprivate var heightStringForWaves: String {
        switch self {
        case .good: return "4-6 FT"
        case .fair: return "3-4 FT"
        case .poor: return "2-3 FT"
        }
    }
}

