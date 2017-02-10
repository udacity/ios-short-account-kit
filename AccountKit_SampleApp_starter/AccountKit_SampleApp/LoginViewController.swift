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

// MARK: - LoginViewController: UIViewController

final class LoginViewController: UIViewController {

    // MARK: Properties
    
    // TODO: Declare and initialize showAccountOnAppear
    // TODO: Declare and initialize dataEntryViewController
    
    @IBOutlet weak var facebookButton: UIButton!
    @IBOutlet weak var surfConnectLabel: UILabel!
    
    // MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
     // TODO: Set the value of showAccountOnAppear
     // TODO: Set the value of dataEntryViewController
    
        facebookButton.titleLabel?.addTextSpacing(2.0)
        surfConnectLabel.addTextSpacing(4.0)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
     // TODO: If showAccountOnAppear is true, present the AccountViewController
     
     // TODO: If showAccountOnAppear is false, prepare and present the
     //       dataEntryViewController
    
        self.navigationController?.isNavigationBarHidden = true
    
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    // MARK: Actions
    
    // TODO: Add the IBAction, loginWithPhone(_ sender: )
    // TODO: Add the IBAction, loginWithEmail(_ sender: )
    

    // MARK: Helper Methods
    
    // TODO: Add the helper method, prepareDataEntryViewController
    // TODO: Add the helper method, presentWithSegueIdentifier
   
}

// MARK: - LoginViewController: AKFViewControllerDelegate

    // TODO: Add the AKFViewControllerDelegate as an extension

    // TODO: Handle callback on successful login
    // TODO: Handle callback on failed login.


