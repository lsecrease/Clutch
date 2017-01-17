//
//  GameFormFooter.swift
//  CL
//
//  Created by iwritecode on 1/16/17.
//  Copyright © 2017 iwritecode. All rights reserved.
//

import UIKit

protocol GameFormFooterDelegate {
    func createGameButtonPressed()
}

class GameFormFooter: UIView, GameFormFooterDelegate {

    @IBOutlet weak var createGameButton: UIButton!
    
    var delegate: GameFormFooterDelegate!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        delegate = self
        
        createGameButton.layer.borderColor = createGameButton.titleLabel?.tintColor.CGColor
        createGameButton.layer.cornerRadius = 5.0
        createGameButton.layer.borderWidth = 1.0
        createGameButton.addTarget(self, action: #selector(createGameButtonPressed), forControlEvents: .TouchUpInside)
        
    }
    
    func loadNib() {
        NSBundle.mainBundle().loadNibNamed("GameFormFooter", owner: self, options: nil)
    }
    
    func createGameButtonPressed() {
        print("Create game button pressed!")
    }
    
    class func instanceFromNib() -> UIView {
        
        let emptyView = UIView()
        
        if let footerView = UINib(nibName: "GameFormFooter", bundle: nil).instantiateWithOwner(nil, options: nil)[0] as? UIView {
            
            return footerView
        }
        return emptyView
    }

}

