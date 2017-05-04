//
//  Appearance.swift
//  AccountKit_SampleApp
//
//  Created by Josh Svatek on 2017-05-02.
//  Copyright © 2017 Gabrielle Miller-Messner. All rights reserved.
//

import UIKit

internal struct Appearance {
    /// Sets the app wide navigation bar style via appearance proxies
    static func applyNavigationBarStyle() {
        // Navigation bar
        UINavigationBar.appearance().titleTextAttributes = [
            NSForegroundColorAttributeName: Colors.white,
            NSFontAttributeName: Fonts.navigationBarTitle
        ]
    }
}

// MARK: - Colors

internal extension Appearance {
    struct Colors {
        static let green = UIColor(red: 9/255, green: 212/255, blue: 182/255, alpha: 1)
        static let orange = UIColor(red: 255/255, green: 162/255, blue: 52/255, alpha: 1)
        static let red = UIColor(red: 252/255, green: 98/255, blue: 64/255, alpha: 1)
        static let lightBlue = UIColor(red: 237/255, green: 242/255, blue: 246/255, alpha: 1)
        static let blueGray = UIColor(red: 125/255, green: 151/255, blue: 173/255, alpha: 1)
        static let gray = UIColor(red: 125/255, green: 151/255, blue: 173/255, alpha: 1)
        static let white = UIColor.white
    }
}

// MARK: - Fonts

internal extension Appearance {
    struct Fonts {
        static let navigationBarTitle: UIFont = UIFont(name: "Avenir-Heavy", size: 17)!
        static let tiny: UIFont = UIFont(name: "Avenir-Black", size: 10)!
        static let buttonLabel: UIFont = UIFont(name: "Avenir-Black", size: 13)!
    }
}
