//
//  MainViewController.swift
//  CL
//
//  Created by iwritecode on 1/3/17.
//  Copyright © 2017 iwritecode. All rights reserved.
//

import UIKit
import CoreLocation

// MARK: - ManinViewController

class MainViewController: UIViewController {
    
    // MARK: IBOutlets
    
    // Container Views
    
    @IBOutlet weak var profileContainerView: UIView!
    @IBOutlet weak var gameContainerView: UIView!
    @IBOutlet weak var liveContainerView: UIView!
    
    
    // Segment Buttons
    
    @IBOutlet weak var profileButton: UIButton!
    @IBOutlet weak var gameButton: UIButton!
    @IBOutlet weak var liveButton: UIButton!
    
    // Labels (to show selection)
    
    @IBOutlet weak var profileUnderlineLabel: UILabel!
    @IBOutlet weak var gameUnderlineLabel: UILabel!
    @IBOutlet weak var liveUnderlineLabel: UILabel!
    
    
    // Navbar buttons
    
    @IBOutlet weak var checkInbutton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    
    // Boolean view properties
    
    var gameRosterViewIsActive: Bool!
    var liveTeamViewIsActive: Bool!
    
    
    // Location
    
    var locationManager: CLLocationManager!
    
    
    // MARK: View life-cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViews()
        
        // Core location setup
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        
    }
    
    
    // MARK: Custom UI functions
    
    func configureViews() {
        
        // Indicate current view
        profileUnderlineLabel.show()
        
        // Set active views
        // liveTeamViewIsActive = true
        gameRosterViewIsActive = false
        
        gameContainerView.hide()
        liveContainerView.hide()
    }
    
    
    // MARK: IBAction methods
    
    @IBAction func profileButtonPressed(sender: UIButton) {
        profileUnderlineLabel.show()
        gameUnderlineLabel.hide()
        liveUnderlineLabel.hide()
        
        liveContainerView.hide()
        gameContainerView.hide()
        profileContainerView.show()
        
        updateBarButtons()
    }
    
    @IBAction func gameViewButtonPressed(sender: UIButton) {
        profileUnderlineLabel.hide()
        gameUnderlineLabel.show()
        liveUnderlineLabel.hide()
        
        profileContainerView.hide()
        liveContainerView.hide()
        gameContainerView.show()
        
        updateBarButtons()
        
    }
    
    @IBAction func liveviewButtonPressed(sender: UIButton) {
        profileUnderlineLabel.hide()
        gameUnderlineLabel.hide()
        liveUnderlineLabel.show()
        
        gameContainerView.hide()
        profileContainerView.hide()
        liveContainerView.show()
        
        updateBarButtons()
        
    }
    
    @IBAction func cancelButtonPressed(sender: UIButton) {
        
        for child in self.childViewControllers {
            if let gameVC = child as? GameViewController {
                gameVC.slideGameViews(direction: .Right)
                gameVC.gameRosterViewIsActive = false
            }
        }
        
    }
    
    @IBAction func checkInButtonPressed(sender: UIButton) {
        print("Check-in button pressed")
    }
    
    func updateBarButtons() {
        if !liveContainerView.hidden && liveTeamViewIsActive {
            self.checkInbutton.show()
        } else {
            self.checkInbutton.hide()
        }
        
        if !gameContainerView.hidden && gameRosterViewIsActive {
            self.cancelButton.show()
        } else {
            self.cancelButton.hide()
        }
        
    }
    
}

// MARK: CLLocationManagerDelegate

extension MainViewController: CLLocationManagerDelegate {
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        switch status {
        case .AuthorizedWhenInUse, .AuthorizedAlways:
            manager.startUpdatingLocation()
        case .Denied:
            manager.stopUpdatingLocation()
        default:
            break
        }
    }
    
}




