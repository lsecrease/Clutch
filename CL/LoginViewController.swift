//
//  LoginViewController.swift
//  CL
//
//  Created by iwritecode on 11/26/16.
//  Copyright © 2016 iwritecode. All rights reserved.
//

import Firebase
import FirebaseAuth
import FirebaseDatabase

import SwiftLoader
import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

enum UserType {
    case regular, admin
}

class LoginViewController: UIViewController, FBSDKLoginButtonDelegate {
    
    
    @IBOutlet weak var facebookButton: FBSDKLoginButton!

    var ref : FIRDatabaseReference? //= FIRDatabase.database().reference()

    
    var isSignedInToFirebase = false
    var userIsAdmin = true
    
        
    let slideRightTransiton = SlideRightTransitionManager()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        

        
            
            // Move to next screen
//            self.showLoadingIndicator()
//            dispatch_async(dispatch_get_main_queue(), { () -> Void in
//                if self.userIsAdmin {
//                    self.performSegueWithIdentifier(Constants.Segues.loginToAdmin, sender: self)
//                } else {
//                    self.performSegueWithIdentifier(Constants.Segues.loginToMain, sender: self)
//                }
//                self.hideLoadingIndicator()
//            })

//        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        facebookButton.delegate = self
        facebookButton.readPermissions = ["email", "public_profile"]
    }
    
    
    // IBAction functions
    
//    @IBAction func fbLoginButtonPressed(sender: UIButton) {
//        
//        // Call FB Login Manager
//        let fbLoginManager = FBSDKLoginManager()
//        
//        // Login to Facebook
//        
//        fbLoginManager.logInWithReadPermissions(["email"], fromViewController: self) { (result, error) in
//            
//            if error != nil {
//                print("COULD NOT LOGIN TO FACEBOOK WITH THOSE CREDENTIALS")
//                
//                return
//            } else {
//                let fbLoginResult: FBSDKLoginManagerLoginResult = result
//                
//                if fbLoginResult.isCancelled {
//                    return
//                } else if (fbLoginResult.grantedPermissions.contains("email")) {
//                    self.getFBUserData()
//                    
//                    self.showLoadingIndicator()
//                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
//                        if self.userIsAdmin {
//                            self.performSegueWithIdentifier(Constants.Segues.loginToAdmin, sender: self)
//                        } else {
//                            self.performSegueWithIdentifier(Constants.Segues.loginToMain, sender: self)
//                        }
//                        self.hideLoadingIndicator()
//                    })
//
//                }
//                
//                self.loginToFirebaseWithFacebookToken()
//            }
//        }
//
//        if self.userIsAdmin {
//            self.performSegueWithIdentifier(Constants.Segues.loginToAdmin, sender: self)
//        } else {
//            self.performSegueWithIdentifier(Constants.Segues.loginToMain, sender: self)
//        }
//        
//    }
    
    //MARK: - FBSDKLoginButtonDelegate
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error?) {
        if let error = error {
            print(error.localizedDescription)
            self.showAlertWithMessage("", message: "There was an error logging into Facebook. Try again?")
            return
        }
        // success!
        FIRAnalytics.logEvent(withName: kFIREventLogin, parameters: [
            kFIRParameterContentType:"action" as NSObject,
            kFIRParameterSignUpMethod: "facebook" as NSObject
            ])
        
        let token = FBSDKAccessToken.current()
        if token != nil {
            let credential = FIRFacebookAuthProvider.credential(withAccessToken: (token?.tokenString)!)
            
            // create the firebase account
            FIRAuth.auth()?.signIn(with: credential) { (user, error) in
                if error != nil {
                    self.showAlertWithMessage("", message: "There was an error logging you in.")
                    return
                }
                
                // get the updated first name and last name
                let req = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"name"], tokenString: token?.tokenString, version: nil, httpMethod: "GET")
//                req?.start(completionHandler: { (connection, result, error : NSError!) in
                req?.start(completionHandler: { (connection, result, NSError) in

                    if(error == nil)
                    {
                        print("result \(result)")
                        let user = FIRAuth.auth()?.currentUser
                        let changeRequest = user!.profileChangeRequest()
                        
                        if let safeResult = result as? [String: AnyObject] {
                            
                            let name = safeResult["name"] as? String ?? ""
                            
                            changeRequest.displayName = name
                        }
                        
                        FIRAnalytics.logEvent(withName: kFIREventSignUp, parameters: [
                            kFIRParameterContentType:"action" as NSObject,
                            kFIRParameterSignUpMethod: "facebook" as NSObject
                            ])
                        
//                        self.delegate?.loginFinished(self.navigationController)

                        
                    }
                    else
                    {
                        print("error \(error)")
                    }
                })
            }
        }
    }
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!){
//        print ("logged out")
    }
    
    
    // MARK: Firebase functions
    
    func loginToFirebaseWithFacebookToken() {
        let accessToken = FBSDKAccessToken.current()
        guard let tokenString = accessToken?.tokenString else { return }
        
        let credential = FIRFacebookAuthProvider.credential(withAccessToken: tokenString)
        
        FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
            if error != nil {
                print("COULD NOT LOGIN TO FIREBASE WITH THSE CREDENTIALS")
                print(error?.localizedDescription)
                print(error)
            } else {
                self.isSignedInToFirebase = true
                print("SIGNED IN TO FIREBASE: \(self.isSignedInToFirebase)")
            }
        })

    }
    
    
    // MARK: Facebook Login Methods
    
    func getFBUserData() {
        if FBSDKAccessToken.current() != nil {
            
            let parameters = ["fields" : "id, name, email, picture.type(large)"]
            FBSDKGraphRequest(graphPath: "/me", parameters: parameters).start(completionHandler: { (connection, result, error) in
                if error != nil {
                    
                    print("Could not get facebook parameters")
                    print(error?.localizedDescription)
                    return
                } else {
                    
                    
                    // TODO: store in Firebase, and not in NSUserDefaults
                    
                    let defaults = UserDefaults.standard
                    
                    if let safeResult = result as? [String: AnyObject] {
                        // Get facebook data
                        // Name
                        if let name = safeResult["name"] as? String {
                            defaults.set(name, forKey: nameKey)
                        }
                        
                        // Email
                        if let email = safeResult["email"] as? String {
                            defaults.set(email, forKey: emailKey)
                        }
                        
                        // Avatar
                        if let picture = safeResult["picture"] as? NSDictionary,
                            let data = picture["data"] as? NSDictionary,
                            let urlString = data["url"] as? NSString {
                            let fbImageURL = NSString(string: urlString)
                            defaults.set(fbImageURL, forKey: avatarURLKey)
                            
                            print("GOT PROFILE PICTURE")
                            
                        }
                        
                        defaults.synchronize()
                    }
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
        config.spinnerColor = UIColor.white
        config.foregroundColor = UIColor.black
        config.foregroundAlpha = 0.2
        config.backgroundColor = UIColor.black
        config.cornerRadius = 5.0
        SwiftLoader.setConfig(config)
        SwiftLoader.show(animated: true)
    }
    
    
    // MARK: - Alert
    
    func showAlertWithMessage(_ title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }

   
}
