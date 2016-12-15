//
//  AddPlayerCell.swift
//  CL
//
//  Created by iwritecode on 12/12/16.
//  Copyright © 2016 iwritecode. All rights reserved.
//

import UIKit

class AddPlayerCell: UITableViewCell {
    
    // MARK: IBOutlets
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var addPlayerButton: UIButton!
    
    // Inputs
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var numberField: UITextField!
    @IBOutlet weak var valueField: UITextField!
    
    // MARK: Variables
    
    // Cell title
    var title: String = "Title" {
        didSet {
            label.text = title
        }
    }
    
    var playerNumber: String = "" {
        didSet {
            numberField.text = playerNumber
        }
    }
    
    var playerValue: String = "" {
        didSet {
            valueField.text = playerValue
        }
    }
    
    // View lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

