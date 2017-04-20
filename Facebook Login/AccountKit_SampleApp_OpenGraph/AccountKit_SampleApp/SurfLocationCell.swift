//
//  SurfLocationCell.swift
//  AccountKit_SampleApp
//
//  Created by Josh Svatek on 2017-04-20.
//  Copyright © 2017 Gabrielle Miller-Messner. All rights reserved.
//

import UIKit

class SurfLocationCell: UITableViewCell {
    ///
    @IBOutlet weak internal var locationImageView: UIImageView!

    ///
    @IBOutlet weak internal var nameLabel: UILabel!

    ///
    @IBOutlet weak internal var conditionsLabel: UILabel!

    ///
    @IBOutlet weak internal var visitorsStackView: UIStackView!

    override func prepareForReuse() {
        super.prepareForReuse()
        for view in visitorsStackView.subviews {
            view.removeFromSuperview()
        }
    }
}
