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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setFacebookProfilePic()
        
        // profileImageView.image = profileImage
        
        if FBSDKAccessToken.currentAccessToken() != nil {
            let graphRequest = FBSDKGraphRequest(graphPath: "me", parameters: nil)
            graphRequest.startWithCompletionHandler({
                (connection, result, error) -> Void in
                if ((error) != nil)
                {
                    print("Error: \(error)")
                }
                else if error == nil
                {
                    let facebookID: NSString = (result.valueForKey("id")
                        as? NSString)!
                    
                    let pictureURL = "https://graph.facebook.com/\(facebookID)/picture?type=large&return_ssl_resources=1"
                    
                    self.fullNameLabel.text = (result.valueForKey("name")             as? String)!
                    
                    let URLRequest = NSURL(string: pictureURL)
                    let URLRequestNeeded = NSURLRequest(URL: URLRequest!)
                    
                    NSURLConnection.sendAsynchronousRequest(URLRequestNeeded, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse?,data: NSData?, error: NSError?) -> Void in
                        
                        if error == nil {
                            let picture = UIImage(data: data!)
                            dispatch_async(dispatch_get_main_queue(), { 
                                self.profileImageView.image = picture
                            })
                            self.profileImageView.image = picture
                        }
                        else {
                            print("Error: \(error!.localizedDescription)")
                        }
                    })

                }
            })
        }
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
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
        if let picURL = NSUserDefaults.standardUserDefaults().stringForKey(avatarURLKey),
            let url = NSURL(string: picURL),
            let data = NSData(contentsOfURL: url),
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
