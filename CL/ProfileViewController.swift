//
//  ProfileViewController.swift
//  CL
//
//  Created by iwritecode on 12/24/16.
//  Copyright © 2016 iwritecode. All rights reserved.
//

import UIKit
import Spring

class ProfileViewController: UIViewController {
    
    // MARK: Profile IBOutlets
    @IBOutlet weak var profileImageView: DesignableImageView!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var statementLabel: UILabel!
    
    // MARK: Constraints
    
    @IBOutlet weak var profileImageViewHeight: NSLayoutConstraint!
    @IBOutlet weak var profileImageViewWidth: NSLayoutConstraint!


    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
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
            
            profileImageView.image = profilePic
            
        }
    }

    
    func adjustConstraintsForSmallerScreenSizes(){
        
        profileImageViewWidth.constant = 100
        profileImageViewHeight.constant = 100
        
    }
    
    

}
