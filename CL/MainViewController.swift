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
    var geotifications = [Geotification]()
    
    
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
    
    
    // MARK: Geofencing functions
    
    func loadAllGeotifications() {
        
    }
    
    func region(withGeotification geotification: Geotification) -> CLCircularRegion {
        let region = CLCircularRegion(center: geotification.coordinate, radius: geotification.radius, identifier: geotification.identifier)
        region.notifyOnEntry = (geotification.eventType == .OnEntry)
        region.notifyOnExit = !region.notifyOnEntry
        return region
    }
    
    // ****** TEST BELOW USING 'IF...ELSE'
    
    func startMonitoring(geotification: Geotification) {
        
        // Show error message if device is incapable of monitoring region entry/exit
        if !CLLocationManager .isMonitoringAvailableForClass(CLCircularRegion) {
            showAlertWithMessage("Error", message: "Geofencing is not supported on this device.")
            return
        }
        
        // Show warning if location services are disabled
        if CLLocationManager.authorizationStatus() != .AuthorizedAlways {
            let message = "You are currently unable to receive check-in notifications. Please enable location services for this app."
            showAlertWithMessage("Warning", message: message)
        }
        
        // Start monitoring for region
        let region = self.region(withGeotification: geotification)
        locationManager.startMonitoringForRegion(region)
    }
    
    func stopMonitoring(geotification: Geotification) {
        for region in locationManager.monitoredRegions {
            guard let circularRegion = region as? CLCircularRegion where
                circularRegion.identifier == geotification.identifier else { return }
            
            locationManager.stopMonitoringForRegion(circularRegion)
            
        }
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
    
    func locationManager(manager: CLLocationManager, monitoringDidFailForRegion region: CLRegion?, withError error: NSError) {
        print("Monitoring failed for region with identifier: \(region!.identifier)")
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Location Manager failed with error: \(error)")
    }
    
    func addGeotificationViewController(controller: AddGeotificationViewController, didAddCoordinate coordinate: CLLocationCoordinate2D, radius:Double, identifier: String, note: String, eventType: EventType) {
        
        controller.dismissViewControllerAnimated(true, completion: nil)
        
        let clampedRadius = min(radius, locationManager.maximumRegionMonitoringDistance)
        let geotification = Geotification(coordinate: coordinate, radius: radius, identifier: identifier, note: note, eventType: eventType)
        
        
    }
    
}




