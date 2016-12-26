//
//  AddPlayerExpandableCell.swift
//  Expandr
//
//  Created by iwritecode on 12/14/16.
//  Copyright © 2016 iwc. All rights reserved.
//

import UIKit

class AddPlayerExpandableCell: UITableViewCell {
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var descriptionView: UIView!
    
    @IBOutlet weak var addOrCancelButton: RotatingButton!
    @IBOutlet weak var descriptionViewHeightConstraint: NSLayoutConstraint!
    
    var isExpanded: Bool = false {
        didSet {
            if isExpanded {
                let finalImage = UIImage(named: "add")
                self.addOrCancelButton.turnForward(finalImage)
            } else {
                let finalImage = UIImage(named: "delete")
                self.addOrCancelButton.turnBack(finalImage)
            }
        }
    }
    
    var title: String = "Title" {
        didSet {
            label.text = title
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        

    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
            

    }
    
}
