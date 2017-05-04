//
//  FriendCell.swift
//  AccountKit_SampleApp
//
//  Created by Josh Svatek on 2017-05-03.
//  Copyright © 2017 Gabrielle Miller-Messner. All rights reserved.
//

import UIKit

internal final class FriendCell: UITableViewCell {

    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var followButton: UIButton!

    @IBOutlet weak var followButtonWidthConstraint: NSLayoutConstraint!

    var surferIdentifier: String?

    weak var delegate: FriendCellDelegate?

    @IBAction func followButtonTapped(sender: UIButton) {
        guard let identifier = surferIdentifier else {
            fatalError("surferIdentifier not set")
        }
        delegate?.friendCell(self, didTapFollowWithIdentifier: identifier)
    }

    func configure(with surfer: Surfer) {
        surferIdentifier = surfer.identifier
        nameLabel.text = surfer.name
        setFollowButtonState(alreadyFollowing: surfer.following)

        // Image
        thumbnailImageView.layer.cornerRadius = thumbnailImageView.bounds.width / 2
        thumbnailImageView.image = #imageLiteral(resourceName: "icon_profile-empty")
        if let imageDescriptor = surfer.imageDescriptor {
            loadImage(for: imageDescriptor)
        }
    }

    func loadImage(for imageDescriptor: Surfer.ImageDescriptor) {
        switch imageDescriptor {
        case let .hardcoded(name):
            thumbnailImageView.image = UIImage(named: name)
        case let .remote(urlString):
            ImageLoader.sharedInstance.load(url: urlString) { [weak self] image in
                if let image = image {
                    self?.thumbnailImageView.image = image
                }
            }
        }
    }

    func setFollowButtonState(alreadyFollowing: Bool) {
        let attributes: [String: Any] = [
            NSFontAttributeName: Appearance.Fonts.buttonLabel,
            NSForegroundColorAttributeName: UIColor.white,
            NSKernAttributeName: 2
        ]
        let text = alreadyFollowing ? "UNFOLLOW" : "FOLLOW"
        let attributedText = NSAttributedString(string: text, attributes: attributes)

        followButton.setAttributedTitle(attributedText, for: .normal)
        followButton.backgroundColor = alreadyFollowing ? Appearance.Colors.blueGray : Appearance.Colors.green
        followButtonWidthConstraint.constant = alreadyFollowing ? 116 : 100
    }
}

protocol FriendCellDelegate: class {
    ///
    func friendCell(_ cell: FriendCell, didTapFollowWithIdentifier identifier: String)
}
