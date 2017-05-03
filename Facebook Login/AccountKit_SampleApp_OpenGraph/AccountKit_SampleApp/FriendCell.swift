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

    @IBAction func followButtonTapped(sender: UIButton) {

    }

    func configure(with surfer: Surfer) {
        nameLabel.text = surfer.name
        setFollowButtonState(alreadyFollowing: surfer.following)

        // Image
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

    }
}
