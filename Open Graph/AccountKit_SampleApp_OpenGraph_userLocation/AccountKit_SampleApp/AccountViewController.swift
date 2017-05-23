// Copyright (c) 2014-present, Facebook, Inc. All rights reserved.
//
// You are hereby granted a non-exclusive, worldwide, royalty-free license to use,
// copy, modify, and distribute this software in source code or binary form for use
// in connection with the web services and APIs provided by Facebook.
//
// As with any software that integrates with the Facebook platform, your use of
// this software is subject to the Facebook Developer Principles and Policies
// [http://developers.facebook.com/policy/]. This copyright notice shall be
// included in all copies or substantial portions of the software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
// FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
// COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
// IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
// CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

import UIKit
import AccountKit
import FBSDKLoginKit


// MARK: - AccountViewController: UIViewController

class AccountViewController: UIViewController {

    // MARK: Outlets

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!

    @IBOutlet weak var accountIDTitleLabel: UILabel!
    @IBOutlet weak var accountIDLabel: UILabel!

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var residenceLabel: UILabel!
    
    // MARK: Properties
    
    var profile: Profile!

    // MARK: View Life Cycle

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.setNavigationBarHidden(false, animated: false)

        imageView.layer.cornerRadius = imageView.bounds.width / 2

        if let image = profile.profileImage {
            imageView.image = image
        } else {
            imageView.image = #imageLiteral(resourceName: "icon_profile-empty")
            profile.loadProfileImage { [weak self] image in
                self?.imageView.image = image
            }
        }

        switch profile.loginType {
        case .accountKit: configureForAccountKitLogin()
        case .facebook: configureForFacebookLogin()
        case .none: configureForNoLogin()
        }
    }

    private func configureForAccountKitLogin() {
        setBottomLabelsHidden(false)
        nameLabel.text = profile.accountKitData?.name ?? "Unknown"
        accountIDLabel.text = profile.accountKitData?.id ?? "Unknown"

        // If we have email, show that. If not, use phone number. If neither,
        // hide the fields.
        if let email = profile.accountKitData?.email {
            titleLabel.text = "Email"
            valueLabel.text = email
        } else if let phone = profile.accountKitData?.phone {
            titleLabel.text = "Phone"
            valueLabel.text = phone
        } else {
            titleLabel.isHidden = true
            valueLabel.isHidden = true
        }
    }

    private func configureForFacebookLogin() {
        setBottomLabelsHidden(false)
        nameLabel.text = profile.facebookData?.name ?? "Unknown"
        accountIDLabel.text = profile.facebookData?.id ?? "Unknown"
        titleLabel.text = "Email"
        valueLabel.text = profile.facebookData?.email ?? "Unknown"
        residenceLabel.text = profile.facebookData?.cityOfResidence ?? "Unknown"
    }

    private func configureForNoLogin() {
        setBottomLabelsHidden(true)
        nameLabel.text = "Unknown"
        residenceLabel.text = "Unknown"
    }

    private func setBottomLabelsHidden(_ hidden: Bool) {
        accountIDTitleLabel.isHidden = hidden
        accountIDLabel.isHidden = hidden
        titleLabel.isHidden = hidden
        valueLabel.isHidden = hidden
    }

    // MARK: Actions
    @IBAction func logOut(_ sender: Any) {
        profile.logOut()
        let _ = navigationController?.popToRootViewController(animated: true)
    }
}
