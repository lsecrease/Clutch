//
//  LoginViewController.swift
//  CL
//
//  Created by iwritecode on 11/26/16.
//  Copyright © 2016 iwritecode. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    let slideRightTransiton = SlideRightTransitionManager()

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if FBSDKAccessToken.currentAccessToken() != nil {
            // Movie to next screen
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Segues
    
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if segue.identifier == "loginToMain" {
//            if let mainVC = segue.destinationViewController as? MainViewController2 {
//                mainVC.transitioningDelegate = slideRightTransiton
//            }
//        }
//    }
    
    @IBAction func fbLoginButtonPressed(sender: UIButton) {
        
//        // Call FB Login Manager
//        let fbLoginManager = FBSDKLoginManager()
//        
//        //
//        fbLoginManager.logInWithReadPermissions(["email"], fromViewController: self) { (result, error) in
//            
//            if error != nil {
//                return
//            } else {
//                let fbLoginResult: FBSDKLoginManagerLoginResult = result
//                
//                if fbLoginResult.isCancelled {
//                    return
//                } else if (fbLoginResult.grantedPermissions.contains("email")) {
//                    self.getFBUserData()
//                }
//            }
//        }
        
        self.performSegueWithIdentifier(Constants.Segues.loginToMain, sender: self)
    }
    
    // MARK: Facebook Login Methods
    
    func getFBUserData() {
        if FBSDKAccessToken.currentAccessToken() != nil {
            
            let parameters = ["fields" : "id, name, email, picture.type(large)"]
            FBSDKGraphRequest(graphPath: "/me", parameters: parameters).startWithCompletionHandler({ (connection, result, error) in
                if error != nil {
                    return
                } else {
                    
                    let defaults = NSUserDefaults.standardUserDefaults()
                    
                    // Get facebook data
                    // Name
                    if let name = result["name"] as? String {
                        defaults.setObject(name, forKey: nameKey)
                    }
                    
                    // Email
                    if let email = result["email"] as? String {
                        defaults.setObject(email, forKey: emailKey)
                        
                        // Add the user's email to Firebase
                    }
                    
                    // Avatar
                    if let picture = result["picture"] as? NSDictionary,
                        let data = picture["data"] as? NSDictionary,
                        let urlString = data["url"] as? NSString {
                        let fbImageURL = NSString(string: urlString)
                        defaults.setObject(fbImageURL, forKey: avatarURLKey)
                    }
                    
                    defaults.synchronize()
                }
            })
        }
    }
   
}
