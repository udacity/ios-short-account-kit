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
import FBSDKCoreKit
import FBSDKLoginKit


// MARK: - LoginViewController: UIViewController

final class LoginViewController: UIViewController {

    // MARK: Properties
    
    fileprivate var accountKit = AKFAccountKit(responseType: .accessToken)
    fileprivate var dataEntryViewController: AKFViewController? = nil
    fileprivate var showAccountOnAppear = false

    fileprivate var profile = Profile(loginType: .none)
    
    @IBOutlet weak var facebookButton: UIButton!
    @IBOutlet weak var surfConnectLabel: UILabel!

    // MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Account Kit
        showAccountOnAppear = accountKit.currentAccessToken != nil
        dataEntryViewController = accountKit.viewControllerForLoginResume() as? AKFViewController
    
        // Styling
        facebookButton.titleLabel?.addTextSpacing(2.0)
        surfConnectLabel.addTextSpacing(4.0)
    
        // Facebook Login

        // Check if user is logged in
        if let fbToken = FBSDKAccessToken.current() {
            profile = Profile(token: fbToken)
            showSurfLocations()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()

        navigationController?.setNavigationBarHidden(true, animated: false)

        // AccountKit
        if showAccountOnAppear {
            showAccountOnAppear = false
            showSurfLocations()
        } else if let viewController = dataEntryViewController {
            if let viewController = viewController as? UIViewController {
                present(viewController, animated: animated, completion: nil)
                dataEntryViewController = nil
            }
        }

        // Facebook Login
    }
    
    // MARK: Actions
    
    @IBAction func loginWithPhone(_ sender: AnyObject) {
        FBSDKAppEvents.logEvent("loginWithPhone clicked")
        if let viewController = accountKit.viewControllerForPhoneLogin() as? AKFViewController {
            prepareDataEntryViewController(viewController)
            if let viewController = viewController as? UIViewController {
                present(viewController, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func loginWithEmail(_ sender: AnyObject) {
        FBSDKAppEvents.logEvent("loginWithEmail clicked")
        if let viewController = accountKit.viewControllerForEmailLogin() as? AKFViewController {
            prepareDataEntryViewController(viewController)
            if let viewController = viewController as? UIViewController {
                present(viewController, animated: true, completion: nil)
            }
        }
    }
    
    // Facebook Login
    @IBAction func loginWithFacebook(_ sender: Any) {
        let readPermissions = ["public_profile"]
        let loginManager = FBSDKLoginManager()
        loginManager.logIn(withReadPermissions: readPermissions, from: self) { (result, error) in
            if let error = error {
                print("login failed with error: \(error)")
            } else if (result?.isCancelled)! {
                print("login cancelled")
            } else if let result = result {
                //present the Surf locations view controller
                self.profile = Profile(token: result.token)
                self.presentWithSegueIdentifier(.showSurfLocations,animated: true)
            }
        }
    }
    
    // MARK: Helper Functions

    private func restoreExistingLoginState() {
        // Check for a Facebook token
        if let fbToken = FBSDKAccessToken.current() {
            profile = Profile(token: fbToken)
            showAccountViewController()
        }
    }
    
    func prepareDataEntryViewController(_ viewController: AKFViewController){
        viewController.delegate = self
    }

}

// MARK: - Segues

extension LoginViewController {
    ///
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if let vc = segue.destination as? SurfLocationsViewController {
            vc.profile = profile
        }
    }

    ///
    fileprivate enum SegueIdentifier: String {
        case showAccount = "ShowAccount"
        case showSurfLocations = "ShowSurfLocations"
    }
    /// 
    fileprivate func showAccountViewController() {
        presentWithSegueIdentifier(.showAccount, animated: true)
    }

    ///
    fileprivate func showSurfLocations() {
        presentWithSegueIdentifier(.showSurfLocations, animated: true)
    }

    fileprivate func presentWithSegueIdentifier(_ segueIdentifier: SegueIdentifier, animated: Bool) {
        if animated {
                performSegue(withIdentifier: segueIdentifier.rawValue, sender: nil)
        } else {
            UIView.performWithoutAnimation {
                self.performSegue(withIdentifier: segueIdentifier.rawValue, sender: nil)
            }
        }
    }
    
}

// MARK: - LoginViewController: AKFViewControllerDelegate

extension LoginViewController: AKFViewControllerDelegate {
    
    func viewController(_ viewController: UIViewController!, didCompleteLoginWith accessToken: AKFAccessToken, state: String!) {
        profile = Profile(token: accessToken)
        showSurfLocations()
    }
    
    func viewController(_ viewController: UIViewController, didFailWithError error: Error!) {
        print("\(viewController) did fail with error: \(error)")
    }
}
