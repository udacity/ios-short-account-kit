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
//TODO: Import LoginKit


// MARK: - AccountViewController: UIViewController

class AccountViewController: UIViewController {

    // MARK: Outlets

    @IBOutlet weak var accountIDTitleLabel: UILabel!
    @IBOutlet weak var accountIDLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    
    // MARK: Properties
    
    fileprivate var accountKit = AKFAccountKit(responseType: .accessToken)

    // MARK: View Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        applyStyling()
        

// TODO: Uncomment request for account information once there is a way to differentiate Facebook Login from Account Kit login
            
//            accountKit.requestAccount { [weak self] (account, error) in
//                //Populate account view
//                if let error = error {
//                    self?.accountIDLabel.text = "N/A"
//                    self?.titleLabel.text = "Error"
//                    self?.valueLabel.text = error.localizedDescription
//                } else {
//                    self?.accountIDLabel.text = account?.accountID
//
//                    if let emailAddress = account?.emailAddress, emailAddress.characters.count > 0 {
//                        self?.titleLabel.text = "Email Address"
//                        self?.valueLabel.text = emailAddress
//                    } else if let phoneNumber = account?.phoneNumber {
//                        self?.titleLabel.text = "Phone Number"
//                        self?.valueLabel.text = phoneNumber.stringRepresentation()
//                    }
//                }
//            }


        // TODO: Only display account ID labels if after an AccountKit login

    }

    // MARK: Helpers

    func applyStyling() {
        UIApplication.shared.statusBarStyle = .lightContent
        navigationController?.navigationBar.barTintColor = UIColor(colorLiteralRed: 97/255, green: 114/255, blue: 127/255, alpha: 1.0)
        navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "Avenir-Heavy", size: 17)!]
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        navigationController?.navigationBar.tintColor = UIColor.white
    }
    
    /// TODO: Add a flag indicating the presence of an AccountKit access token


    /// TODO: Add a flag indicating the presence of an Facebook SDK access token


    // MARK: Actions
// TODO: Differentiate between Account Kit logout and Facebook Login logout
    
//    @IBAction func logOut(_ sender: Any) {
//        accountKit.logOut()
//        _ = self.navigationController?.popToRootViewController(animated: true)
//    }
}
