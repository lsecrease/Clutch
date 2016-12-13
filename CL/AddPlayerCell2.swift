//
//  AddPlayerCell2.swift
//  CL
//
//  Created by iwritecode on 12/12/16.
//  Copyright © 2016 iwritecode. All rights reserved.
//

import UIKit

class AddPlayerCell2: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!

    @IBOutlet weak var tableContainerView: UIView!
    @IBOutlet weak var addPlayerButton: UIButton!
    
    
    // MARK: Constraint
    
    @IBOutlet weak var tableContainerViewHeight: NSLayoutConstraint!
    @IBOutlet weak var inputViewHeightConstraint: NSLayoutConstraint!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        addPlayerButton.layer.cornerRadius = 5.0
        addPlayerButton.layer.borderWidth = 2.0
        addPlayerButton.layer.borderColor = UIColor.blueColor().CGColor
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
