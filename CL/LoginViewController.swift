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

    var ref : FIRDatabaseReference?

    
    var isSignedInToFirebase = false
    var userIsAdmin = false
    var userID : String?

    
        
    let slideRightTransiton = SlideRightTransitionManager()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        facebookButton.delegate = self
        facebookButton.readPermissions = ["email", "public_profile"]
        self.isLoggedIn()
    }
    
    
    //MARK: - FBSDKLoginButtonDelegate
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error?) {
        self.showLoadingIndicator()

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
            let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
            
            FIRAuth.auth()?.signIn(with: credential) { (user, error) in
                if error != nil {
                    self.showAlertWithMessage("", message: "There was an error logging you in.")
                    return
                }
                

                let req = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"id, name, first_name, last_name, picture.type(large), email"], tokenString: token?.tokenString, version: nil, httpMethod: "GET")
                let _ = req?.start(completionHandler: { (connection, result, NSError) in

                    if(error == nil)
                    {
                        print("result \(result)")
                        let user = FIRAuth.auth()?.currentUser
                        let changeRequest = user!.profileChangeRequest()
                        
                        //Set Firebase defaults
                        if let safeResult = result as? [String: AnyObject] {
                            
                            let name = safeResult["name"] as? String ?? ""
                            changeRequest.displayName = name
                            
                            if let pictureDict = safeResult["picture"]?["data"] as? [String: AnyObject] {
                                if let imageUrl = pictureDict["url"] as? String {
                                    changeRequest.photoURL = URL(string: imageUrl)
                                }
                            }
                            
                            let email = safeResult["email"] as? String ?? ""
                            
                            FIRAuth.auth()?.currentUser?.updateEmail(email) { (error) in
                                if error != nil {
                                    self.showAlertWithMessage("", message: "There was an error signing up. Try again?")
                                    return
                                }
                            }
                            self.addToFirebase(email: email)
                        }
                        
                        //Firebase Analytics
                        FIRAnalytics.logEvent(withName: kFIREventSignUp, parameters: [
                            kFIRParameterContentType:"action" as NSObject,
                            kFIRParameterSignUpMethod: "facebook" as NSObject
                            ])
                        
                        //check admin status and proceed to next view
                        self.updateAdminStatus()

                        
                    }
                    else
                    {
                        print("error \(error)")
                    }
                })
            }
        }
    }
    
    func isLoggedIn(){
        if (FIRAuth.auth()?.currentUser?.uid) != nil {
            self.updateAdminStatus()
        }
    }
    
    func addToFirebase(email: String?){
        self.ref = FIRDatabase.database().reference()
        
        if let user = FIRAuth.auth()?.currentUser?.uid {
            
            var childUpdates : [String : AnyObject] = [:]
            childUpdates["/users/\(user)/email"] = email as AnyObject?

            self.ref?.updateChildValues(childUpdates)

        }
    }
    
    func updateAdminStatus() {
        
        self.userID = FIRAuth.auth()?.currentUser?.uid
        ref = FIRDatabase.database().reference()
        
        if let userID = self.userID {
            
            let userIdRef = ref?.child("users").child(userID)
            userIdRef?.observe(.value, with: {(snapshot) in
                
                userIdRef?.removeAllObservers()
                
                // Get user value
                let snapshotValue = snapshot.value as? NSDictionary
                if let adminaccess = snapshotValue?["admin"] as? Bool{
                    print (adminaccess)
                    self.userIsAdmin = adminaccess
                }
                self.loadScreen()
            })
        }
        //No userId
        else {
            if self.userIsAdmin != false {
                self.userIsAdmin = false
            }
        }
    }

    func loadScreen(){
        self.hideLoadingIndicator()
        if self.userIsAdmin {
            self.performSegue(withIdentifier: Constants.Segues.loginToAdmin, sender: self)
        } else {
            self.performSegue(withIdentifier: Constants.Segues.loginToMain, sender: self)
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!){
        print ("logged out")
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
