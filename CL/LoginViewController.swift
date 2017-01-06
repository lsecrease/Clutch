//
//  LoginViewController.swift
//  CL
//
//  Created by iwritecode on 11/26/16.
//  Copyright © 2016 iwritecode. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import SwiftLoader

class LoginViewController: UIViewController {
    
    var isSignedInToFirebase = false
    
    let slideRightTransiton = SlideRightTransitionManager()

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if FBSDKAccessToken.currentAccessToken() != nil {
            // Move to next screen
            
            self.showLoadingIndicator()
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.performSegueWithIdentifier(Constants.Segues.loginToMain, sender: self)
                self.hideLoadingIndicator()

            })

        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    
    @IBAction func fbLoginButtonPressed(sender: UIButton) {
        
        // Call FB Login Manager
        let fbLoginManager = FBSDKLoginManager()
        
        // Login to Facebook
        
        fbLoginManager.logInWithReadPermissions(["email"], fromViewController: self) { (result, error) in
            
            if error != nil {
                return
            } else {
                let fbLoginResult: FBSDKLoginManagerLoginResult = result
                
                if fbLoginResult.isCancelled {
                    return
                } else if (fbLoginResult.grantedPermissions.contains("email")) {
                    self.getFBUserData()
                    
                    self.showLoadingIndicator()
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.performSegueWithIdentifier(Constants.Segues.loginToMain, sender: self)
                        self.hideLoadingIndicator()
                    })

                }
                
                self.loginTofirebaseWithFacebookToken()
            }
        }
        
    }
    
    func loginTofirebaseWithFacebookToken() {
        let credential = FIRFacebookAuthProvider.credentialWithAccessToken(FBSDKAccessToken.currentAccessToken().tokenString)
        
        FIRAuth.auth()?.signInWithCredential(credential, completion: { (user, error) in
            if error != nil {
                print("COULD NOT LOGIN TO FIREBASE WITH THSE CREDENTIALS")
                print(error?.localizedDescription)
                
            } else {
                self.isSignedInToFirebase = true
            }
        })

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
    
    
    // MARK: Activity indicator
    
    func hideLoadingIndicator() {
        SwiftLoader.hide()
    }
    
    func showLoadingIndicator() {
        var config: SwiftLoader.Config = SwiftLoader.Config()
        config.size = 100
        config.spinnerColor = UIColor.whiteColor()
        config.foregroundColor = UIColor.blackColor()
        config.foregroundAlpha = 0.2
        config.backgroundColor = UIColor.blackColor()
        config.cornerRadius = 5.0
        SwiftLoader.setConfig(config)
        SwiftLoader.show(animated: true)
    }
    
    
    // MARK: - Alert
    
    func showAlertWithMessage(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
        alert.addAction(okAction)
        self.presentViewController(alert, animated: true, completion: nil)
    }

   
}
