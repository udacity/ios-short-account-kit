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

    @IBOutlet weak var accountIDTitleLabel: UILabel!
    @IBOutlet weak var accountIDLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    
    // MARK: Properties
    
    var profile: Profile!

    // MARK: View Life Cycle

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.setNavigationBarHidden(false, animated: false)

//
//        UIApplication.shared.statusBarStyle = .lightContent
//        navigationController?.navigationBar.barTintColor = UIColor(colorLiteralRed: 97/255, green: 114/255, blue: 127/255, alpha: 1.0)
//        navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "Avenir-Heavy", size: 17)!]
//        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
//        navigationController?.navigationBar.tintColor = UIColor.white

        accountIDTitleLabel.isHidden = !profile.isDataLoaded
        accountIDLabel.isHidden = !profile.isDataLoaded

        if profile.isDataLoaded == false {
            titleLabel.text = "Error"
        } else if profile.isAccountKitLogin {
            if let emailAddress = profile.data?.email, !emailAddress.isEmpty {
                titleLabel.text = "Email Address"
                valueLabel.text = emailAddress
            } else if let phoneNumber = profile.data?.phone, !phoneNumber.isEmpty {
                titleLabel.text = "Phone Number"
                valueLabel.text = phoneNumber
            }
        } else if profile.isFacebookLogin {
            // ...
        }

        // Only display account ID labels if after an AccountKit login
    }

    // MARK: Actions
    @IBAction func logOut(_ sender: Any) {
        profile.logOut()
        let _ = navigationController?.popToRootViewController(animated: true)
    }
}
