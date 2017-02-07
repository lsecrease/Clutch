//
//  ProfileViewController.swift
//  CL
//
//  Created by iwritecode on 12/24/16.
//  Copyright © 2016 iwritecode. All rights reserved.
//

import Firebase
import Spring
import UIKit


class ProfileViewController: UIViewController {
    
    // MARK: Profile IBOutlets
    @IBOutlet weak var profileImageView: DesignableImageView!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var statementLabel: UILabel!
    
    // MARK: Constraints
    
    @IBOutlet weak var profileImageViewHeight: NSLayoutConstraint!
    @IBOutlet weak var profileImageViewWidth: NSLayoutConstraint!

    var profileImage = UIImage()

    var ref : FIRDatabaseReference?
    var userID : String?



    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setFacebookProfilePic()
        
        // profileImageView.image = profileImage

        //Seth: Meh
//        if FBSDKAccessToken.current() != nil {
//            let graphRequest = FBSDKGraphRequest(graphPath: "me", parameters: nil)
//            graphRequest?.start(completionHandler: {
//                (connection, result, error) -> Void in
//                if ((error) != nil)
//                {
//                    print("Error: \(error)")
//                }
//                else if error == nil
//                {
//                    let facebookID: NSString = (result.value(forKey: "id")as? NSString)!
//                    
//                    let pictureURL = "https://graph.facebook.com/\(facebookID)/picture?type=large&return_ssl_resources=1"
//                    
//                    self.fullNameLabel.text = (result.value(forKey: "name") as? String)!
//                    
//                    let URLRequest = URL(string: pictureURL)
//                    let URLRequestNeeded = Foundation.URLRequest(url: URLRequest!)
//                    
//                    NSURLConnection.sendAsynchronousRequest(URLRequestNeeded, queue: OperationQueue.main, completionHandler: {(response: URLResponse?,data: Data?, error: NSError?) -> Void in
//                        
//                        if error == nil {
//                            let picture = UIImage(data: data!)
//                            DispatchQueue.main.async(execute: { 
//                                self.profileImageView.image = picture
//                            })
//                            self.profileImageView.image = picture
//                        }
//                        else {
//                            print("Error: \(error!.localizedDescription)")
//                        }
//                    } as! (URLResponse?, Data?, Error?) -> Void)
//
//                }
//            })
//        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        self.userID = FIRAuth.auth()?.currentUser?.uid
//        ref = FIRDatabase.database().reference()

        self.fullNameLabel.text = FIRAuth.auth()?.currentUser?.displayName
        
        // profileImageView.image = profileImage

        
        setFacebookProfilePic()

    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // After all subview layout, use actual profile image view
        // width to make it round.
        
        if DeviceType.isIphone4s {
            adjustConstraintsForSmallerScreenSizes()
        }
        
        let imgWidth = profileImageViewWidth.constant
        profileImageView.cornerRadius = imgWidth / 2.0
        
    }
    
    
    
    func setFacebookProfilePic() {
//        if let picURL = UserDefaults.standard.string(forKey: avatarURLKey),
//        let url = URL(string: picURL),

        if let picURL = FIRAuth.auth()?.currentUser?.photoURL,
            let data = try? Data(contentsOf: picURL),
            let profilePic = UIImage(data: data) {
            
            print(picURL)
            
            profileImageView.image = profilePic
            
        } else {
            print("COULD NOT SET PROFILE PIC - Profile VC")
        }
    }

    
    func adjustConstraintsForSmallerScreenSizes(){
        
        profileImageViewWidth.constant = 100
        profileImageViewHeight.constant = 100
        
    }
    
    

}
