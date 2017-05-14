//
//  FriendCell.swift
//  AccountKit_SampleApp
//
//  Created by Josh Svatek on 2017-05-03.
//  Copyright © 2017 Gabrielle Miller-Messner. All rights reserved.
//

import UIKit

internal final class FriendCell: UITableViewCell {
    // Outlets
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var followButton: UIButton!

    // Layout constraints
    @IBOutlet weak var followButtonWidthConstraint: NSLayoutConstraint!

    // The identifier of the surfer the cell was configured with. This is
    // retained for the purpose of identifying the cell when the follow button
    // is tapped.
    var surferIdentifier: String?

    weak var delegate: FriendCellDelegate?

    @IBAction func followButtonTapped(sender: UIButton) {
        guard let identifier = surferIdentifier else {
            fatalError("surferIdentifier not set")
        }
        delegate?.friendCell(self, didTapFollowWithIdentifier: identifier)
    }

    // Setup

    func configure(with surfer: Surfer) {
        surferIdentifier = surfer.identifier
        nameLabel.text = surfer.name
        setFollowButtonState(isFollowedByUser: surfer.isFollowedByUser)

        // Image
        thumbnailImageView.layer.cornerRadius = thumbnailImageView.bounds.width / 2
        thumbnailImageView.image = #imageLiteral(resourceName: "icon_profile-empty")
        thumbnailImageView.loadImage(for: surfer)
    }

    func setFollowButtonState(isFollowedByUser: Bool) {
        let attributes: [String: Any] = [
            NSFontAttributeName: Appearance.Fonts.buttonLabel,
            NSForegroundColorAttributeName: UIColor.white,
            NSKernAttributeName: 2
        ]
        let text = isFollowedByUser ? "UNFOLLOW" : "FOLLOW"
        let attributedText = NSAttributedString(string: text, attributes: attributes)

        followButton.setAttributedTitle(attributedText, for: .normal)
        followButton.backgroundColor = isFollowedByUser ? Appearance.Colors.blueGray : Appearance.Colors.green
        followButtonWidthConstraint.constant = isFollowedByUser ? 116 : 100
    }
}

protocol FriendCellDelegate: class {
    /// Informs the delegate that the follow button was tapped
    func friendCell(_ cell: FriendCell, didTapFollowWithIdentifier identifier: String)
}
