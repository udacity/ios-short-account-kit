//
//  ProfileViewController.swift
//  AccountKit_SampleApp
//
//  Created by Gabrielle Miller-Messner on 3/18/17.
//  Copyright © 2017 Gabrielle Miller-Messner. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class ProfileViewController: UIViewController {

    // MARK: Properties
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    
    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        getUserData()
        userNameLabel.text = "Namey McNamerson"
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // MARK: Set user data
    
    func setUserProfileImage(userID: NSString)
    {
        let facebookProfileUrl = NSURL(string: "http://graph.facebook.com/\(userID)/picture?type=large")
        
        if let data = NSData(contentsOf: facebookProfileUrl! as URL) {
            userImageView.image = UIImage(data: data as Data)
        }
    }
    
    // MARK: Graph Request
    
    func getUserData()
    {
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"picture,name"])
        graphRequest.start(completionHandler: { (connection, result, error) -> Void in
            
            if ((error) != nil)
            {
                // Process error
                print("Error: \(error)")
            }
            else
            {
                let resultDict = result as! NSDictionary
                if let userName : NSString = resultDict.value(forKey: "name") as? NSString {
                    self.userNameLabel.text = userName as String
                } else {
                    print("Name is null")
                }
                
                if let id: NSString = resultDict.value(forKey: "id") as? NSString {
                    self.setUserProfileImage(userID: id)
                } else {
                    print("ID is null")
                }
            }
        })
    }

    // MARK: Actions
    
    @IBAction func logOut(_ sender: Any) {
        let loginManager = FBSDKLoginManager()
        loginManager.logOut()
        _ = self.navigationController?.popToRootViewController(animated: true)
    }
}
