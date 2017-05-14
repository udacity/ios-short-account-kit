//
//  VisitorBadge.swift
//  AccountKit_SampleApp
//
//  Created by Josh Svatek on 2017-05-03.
//  Copyright © 2017 Gabrielle Miller-Messner. All rights reserved.
//

import UIKit

// A small profile thumbnail displaying a visitor at a surf location. It has
// two modes, depending on how it is initialized. It can either display a single
// visitor with a profile picture in its image view, or it can be initialized
// to display an (aggregate) count of additional visitors.

internal final class VisitorBadge: UIView {
    // If no picture, used to display a count
    var label: UILabel?

    // If a picture is available, the imageview displats it
    var imageView: UIImageView?

    fileprivate struct Metrics {
        // The size of the visitor badge
        static let size = CGSize(width: 30, height: 30)
    }

    /// Initializer when displaying an aggregate count of visitors
    init(withRemainderCount count: Int) {
        super.init(frame: CGRect(origin: .zero, size: Metrics.size))
        commonConfiguration()
        label = UILabel(frame: bounds)
        label!.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        label!.textColor = Appearance.Colors.white
        label!.text = count > 0 ? "\(count)+" : "0"
        label!.font = Appearance.Fonts.tiny
        label!.textAlignment = .center
        addSubview(label!)
        label!.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
        label!.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
    }

    /// Initializer for displaying a single surfer with a picture
    init(surfer: Surfer) {
        super.init(frame: CGRect(origin: .zero, size: Metrics.size))
        commonConfiguration()
        imageView = UIImageView(frame: bounds)
        imageView!.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        imageView!.contentMode = .scaleAspectFill
        imageView!.image = #imageLiteral(resourceName: "icon_profile-empty")
        addSubview(imageView!)
        imageView!.loadImage(for: surfer)
    }

    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    /// Common configuration for convenience initializers above
    private func commonConfiguration() {
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: Metrics.size.height).isActive = true
        widthAnchor.constraint(equalToConstant: Metrics.size.width).isActive = true
        backgroundColor = Appearance.Colors.gray
        clipsToBounds = true
        layer.cornerRadius = Metrics.size.width / 2
        layer.borderWidth = 2
        layer.borderColor = Appearance.Colors.lightBlue.cgColor
    }
}
