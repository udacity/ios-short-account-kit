//
//  SurfLocationsViewController.swift
//  AccountKit_SampleApp
//
//  Created by Josh Svatek on 2017-04-20.
//  Copyright © 2017 Gabrielle Miller-Messner. All rights reserved.
//

import UIKit
import FBSDKShareKit

internal final class SurfLocationsViewController: UIViewController {
    // Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var accountButton: UIButton!
    @IBOutlet weak var setLocationTextField: UITextField!
    @IBOutlet weak var setLocationButton: UIButton!

    var shareButton: FBSDKShareButton?

    var profile: Profile!

    var dataSource: SurfLocationsDataSource!

    var currentLocation: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        guard profile != nil else {
            fatalError("profile must be set on SurfLocationsViewController before it is presented")
        }

        if let button = navigationItem.rightBarButtonItem?.customView {
            button.layer.cornerRadius = button.bounds.size.width / 2
            button.clipsToBounds = true
        }

        navigationItem.leftBarButtonItem?.customView?.isHidden = !profile.isFacebookLogin

        if !profile.isDataLoaded {
            profile.loadProfileData {
                self.dataSource = SurfLocationsDataSource(profile: self.profile, locations: SurfLocation.Hardcoded.makeLocations())
                self.tableView.dataSource = self.dataSource
                self.tableView.reloadData()
                // Fetch the profile image now that we have an URL
                self.updateAccountButton()
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.setNavigationBarHidden(false, animated: false)
    }
}

// -----------------------------------------------------------------------------
// MARK: - IBActions

internal extension SurfLocationsViewController {
    @IBAction func setLocationButtonTapped(sender: UIButton) {
        setLocationTextField(visible: true)
        setLocationTextField.becomeFirstResponder()
    }

    @IBAction func shareLocationButtonTapped(sender: UIButton) {
        guard let content = shareButton?.shareContent else {
            fatalError()
        }
        FBSDKShareDialog.show(from: self, with: content, delegate: nil)
    }

    // Helpers

    fileprivate func setLocationTextField(visible: Bool) {
        setLocationTextField.isHidden = !visible
        setLocationButton.isHidden = visible
        updateShareButton(visible: !visible)
    }

    fileprivate func updateForCurrentLocation() {
        setLocationButton.setTitle(currentLocation, for: .normal)
        setLocationTextField.text = currentLocation
    }

    func updateShareButton(visible: Bool) {
        if !visible {
            shareButton?.removeFromSuperview()
            shareButton = nil
            return
        }

        // Set up share button
        let containingView = self.setLocationButton.superview!

        let photo = FBSDKSharePhoto(image: #imageLiteral(resourceName: "imageOceanBeach"), userGenerated: false)!
        let photoContent = FBSDKSharePhotoContent()
        photoContent.photos = [photo]

        let button = FBSDKShareButton()
        button.addTarget(self, action: #selector(shareLocationButtonTapped(sender:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.shareContent = photoContent

        containingView.addSubview(button)
        self.shareButton = button
        button.centerYAnchor.constraint(equalTo: setLocationButton.centerYAnchor).isActive = true
        button.rightAnchor.constraint(equalTo: containingView.rightAnchor, constant: -18).isActive = true
    }
}

// -----------------------------------------------------------------------------
// MARK: - Text field delegate

extension SurfLocationsViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let text = textField.text, !text.isEmpty {
            currentLocation = text
        } else {
            currentLocation = nil
        }
        updateForCurrentLocation()

        setLocationTextField(visible: currentLocation == nil)
        setLocationTextField.resignFirstResponder()

        return true
    }
}

// -----------------------------------------------------------------------------
// MARK: - Updating navigation bar buttons

internal extension SurfLocationsViewController {
    func updateAccountButton() {
        // If we have a profile image – use it and return
        if let image = profile.profileImage {
            accountButton.setImage(image, for: .normal)
        } else {
            accountButton.setImage(#imageLiteral(resourceName: "icon_profile-empty"), for: .normal)
            profile.loadProfileImage { [weak self] image in
                if let image = image {
                    self?.accountButton.setImage(image, for: .normal)
                }
            }
        }
    }
}

// -----------------------------------------------------------------------------
// MARK: - Segues

extension SurfLocationsViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? AccountViewController {
            vc.profile = profile
        } else if let nc = segue.destination as? UINavigationController, let vc = nc.topViewController as? FollowFriendsViewController {
            vc.profile = profile
        }
    }
}
