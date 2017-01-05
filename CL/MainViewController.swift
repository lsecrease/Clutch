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
    
    
    // Location and Geotification
    var locationManager: CLLocationManager!
    let radius = 300.0
    
    // MARK: View life-cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViews()
        
        // Core location setup
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.requestAlwaysAuthorization()
        
        setupGeofencing()
        
    }
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if CLLocationManager.authorizationStatus() != .AuthorizedAlways {
            switch CLLocationManager.authorizationStatus() {
            case .NotDetermined:
                locationManager.requestAlwaysAuthorization()
            case .Denied:
                showAlertWithMessage("Error", message: "Location Services not enabled")
            case .AuthorizedAlways:
                locationManager.startUpdatingLocation()
            default:
                break
            }
        }
        
    }
    
    
    // MARK: Geofencing functions
    
    func setupGeofencing() {
        
        // Per Apple Guidelines, check if device is capable of monitoring regions

        if !CLLocationManager.isMonitoringAvailableForClass(CLRegion) {
            let message = "Your device is not capable of monitoring regions for geofencing"
            showAlertWithMessage("Error", message: message)
            return
        }
        
        
        // Check if location services are enabled
        
        if CLLocationManager.authorizationStatus() != .AuthorizedAlways {
            let message = "Can't deetermine location. Please enable location services in settings"
            showAlertWithMessage("", message: message)
        }
        
        // Create a circular region for monitoring
        
        let coordinate = CLLocationCoordinate2D(latitude: 37.701029, longitude: -121.773526)
        let name = "Some place"
        let region = CLCircularRegion(center: coordinate, radius: radius, identifier: name)
        
        locationManager.startMonitoringForRegion(region)
        
    }
    
    // MARK: Status Bar
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
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
    
    func showAlertWithMessage(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
        alert.addAction(okAction)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    
    // MARK: IBAction methods
    
    @IBAction func segmentButtonPressed(sender: UIButton) {
        
        // TO DO: Create Custom button/ button view class to handle appearance changes
        
        switch sender {
        case profileButton:
            profileUnderlineLabel.show()
            gameUnderlineLabel.hide()
            liveUnderlineLabel.hide()
            
            liveContainerView.hide()
            gameContainerView.hide()
            profileContainerView.show()
            
            updateBarButtons()

        case gameButton:
            
            profileUnderlineLabel.hide()
            gameUnderlineLabel.show()
            liveUnderlineLabel.hide()
            
            profileContainerView.hide()
            liveContainerView.hide()
            gameContainerView.show()
            
            updateBarButtons()

        case liveButton:
            profileUnderlineLabel.hide()
            gameUnderlineLabel.hide()
            liveUnderlineLabel.show()
            
            gameContainerView.hide()
            profileContainerView.hide()
            liveContainerView.show()
            
            updateBarButtons()

        default:
            break
        }
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
    
    func locationManager(manager: CLLocationManager, didEnterRegion region: CLRegion) {
        if region is CLCircularRegion {
            print("YOU'VE ENTERED: \(region.identifier)")
            
            
        }
    }
    
    func locationManager(manager: CLLocationManager, didExitRegion region: CLRegion) {
        // print("YOU'VE EXITED THE REGION")
        
    }
    
    func locationManager(manager: CLLocationManager, monitoringDidFailForRegion region: CLRegion?, withError error: NSError) {
        print("Monitoring failed for region with identifier: \(region!.identifier)")
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Location Manager failed with error: \(error)")
    }
    
    
}




