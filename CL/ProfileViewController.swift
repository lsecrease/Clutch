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
    
    func adjustConstraintsForSmallerScreenSizes(){
        
        profileImageViewWidth.constant = 100
        profileImageViewHeight.constant = 100
        
    }
    
    

}
