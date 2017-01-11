//
//  UILabel+TextSpacing.swift
//  AccountKit_SampleApp
//
//  Created by Gabrielle Miller-Messner on 1/9/17.
//  Copyright © 2017 Gabrielle Miller-Messner. All rights reserved.
//  Modified from:  http://stackoverflow.com/questions/27535901/ios-8-change-character-spacing-on-uilabel-within-interface-builder
//  budidino Apr 24 '16 at 11:32

import Foundation
import UIKit

// MARK: - UILabel (Text Spacing)

extension UILabel {
    func addTextSpacing(_ spacing: CGFloat){
        let attributedString = NSMutableAttributedString(string: text!)
        attributedString.addAttribute(NSKernAttributeName, value: spacing, range: NSRange(location: 0, length: text!.characters.count))
        attributedText = attributedString
    }
}
