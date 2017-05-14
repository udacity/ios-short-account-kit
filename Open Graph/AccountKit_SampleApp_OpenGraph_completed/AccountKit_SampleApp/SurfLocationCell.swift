//
//  SurfLocationCell.swift
//  AccountKit_SampleApp
//
//  Created by Josh Svatek on 2017-04-20.
//  Copyright © 2017 Gabrielle Miller-Messner. All rights reserved.
//

import UIKit

class SurfLocationCell: UITableViewCell {
    /// Banner image of location
    @IBOutlet weak internal var locationImageView: UIImageView!

    /// Label for name of location
    @IBOutlet weak internal var nameLabel: UILabel!

    /// Label for description of current conditions
    @IBOutlet weak internal var conditionsLabel: UILabel!

    /// A stack view displaying thumbnails of current visitors at this location
    @IBOutlet weak internal var visitorsStackView: UIStackView!

    override func prepareForReuse() {
        super.prepareForReuse()
        for view in visitorsStackView.subviews {
            view.removeFromSuperview()
        }
    }
}
