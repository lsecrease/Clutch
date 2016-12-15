//
//  CreateGameTableViewCell.swift
//  CL
//
//  Created by iwritecode on 12/15/16.
//  Copyright © 2016 iwritecode. All rights reserved.
//

import UIKit

class CreateGameTableViewCell: UITableViewCell {
    
    @IBOutlet weak var categoryField: UITextField!
    @IBOutlet weak var teamNameField1: UITextField!
    @IBOutlet weak var teamNameField2: UITextField!
    @IBOutlet weak var addPlayerTitleLabel: UILabel!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var numberField: UITextField!
    @IBOutlet weak var valueField: UITextField!
    @IBOutlet weak var addPlayerButton: UIButton!
    @IBOutlet weak var startingValueField: UITextField!
    @IBOutlet weak var latitudeField: UITextField!
    @IBOutlet weak var longitudeField: UITextField!
    @IBOutlet weak var venueField: UITextField!
    @IBOutlet weak var endRegistrationLabel: UILabel!
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
