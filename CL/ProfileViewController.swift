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
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // profileImageView.image = profileImage

        
        // setFacebookProfilePic()

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
            print("COULD NOT SET PROFILE PIC")
        }
    }

    
    func adjustConstraintsForSmallerScreenSizes(){
        
        profileImageViewWidth.constant = 100
        profileImageViewHeight.constant = 100
        
    }
    
    

}
