//
//  MainViewController.swift
//  CL
//
//  Created by iwritecode on 1/3/17.
//  Copyright © 2017 iwritecode. All rights reserved.
//

import CoreLocation
import FirebaseDatabase
import UIKit


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
    
    // MARK: Properties
        
    // Firebase properties
    var ref: FIRDatabaseReference!
    var refHandle: UInt!
    var isSignedIn = true
    var gamesRef = FIRDatabaseReference()
    var teamRef1 = FIRDatabaseReference()
    var teamRef2 = FIRDatabaseReference()
    var gameCategory: CategoryType?
    
    var games = [Game]()
    var gameKeys = [String]()
    var team1 = Team()
    var team2 = Team()
    
    // Boolean view properties
    var gameRosterViewIsActive: Bool!
    var liveTeamViewIsActive: Bool!
    
    
    // Location and Geotification
    var locationManager: CLLocationManager!
    let radius = 300.0
    
    
    // MARK: View life-cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set category
        gameCategory = .NBA
        
        configureViews()
        
        // Core location setup
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.requestAlwaysAuthorization()
        
        setupGeofencing()
        
        ref = FIRDatabase.database().reference()
        
//        refHandle = ref.observeEventType(FIRDataEventType.Value, withBlock: { (snapshot) in
//            
//            if !snapshot.exists() {
//                print("NO SNAPSHOT RECEIVED")
//            }
//            
//            let postDict = snapshot.value as? [String : AnyObject] ?? [:]
//            print(postDict)
//        })
        
         getGameDataFor(gameCategory!)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
//        refHandle = ref.observeEventType(FIRDataEventType.Value, withBlock: { (snapshot) in
//            let dataDict = snapshot.value
//            print(dataDict)
//        })
        
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
    
    
    // MARK: Status Bar
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    
    // MARK: Custom UI functions
    
    func configureViews() {
        
        // Navbar title
        if let barFont = UIFont(name: "Symbol", size: 26.0) {
            UINavigationBar.appearance().titleTextAttributes = [
                NSForegroundColorAttributeName: UIColor.whiteColor(),
                NSFontAttributeName: barFont
            ]
        }
        
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
    
    
    // MARK: Firebase Database functions
    
    func getGameDataFor(category: CategoryType) {
        var categoryName = String()
        switch category {
        case .MLB:
            categoryName = "mlb"
        case .MLS:
            categoryName = "mls"
        case .NCAABasketball:
            categoryName = "ncaa-basketball"
        case .NCAAFootball:
            categoryName = "ncaa-football"
        case .NBA:
            categoryName = "nba"
        case .NFL:
            categoryName = "nfl"
        case .NHL:
            categoryName = "nhl"
        }
        
        gamesRef = FIRDatabase.database().reference().child("games").child("category").child(categoryName)
        
        refHandle = gamesRef.observeEventType(FIRDataEventType.Value, withBlock: { (snapshot) in
            if !snapshot.exists() {
                print("NO SNAPSHOT AVAILABLE")
            } else {
                
                let data = snapshot.value
                
                if let allKeys = snapshot.value?.allKeys as? [String] {
                    self.gameKeys = allKeys
                    var count = 0
                    
                    for key in self.gameKeys {
                        
                        if let currentGame = snapshot.value!.valueForKey(key) {
                            var gameData = Game()
                            gameData.category = categoryName
                            gameData.gameID = key
                            gameData.venue = currentGame.valueForKey("venue")! as! String
                            gameData.latitude = currentGame.valueForKey("latitude") as! Float
                            gameData.longitude = currentGame.valueForKey("longitude") as! Float
                            self.games.append(gameData)
                        }
                    }
                                        
                    for game in self.games {
                        print(game.category)
                        print(game.venue)
                        print(game.gameID)
                        print(game.latitude)
                        print(game.longitude)
                        print("\n")
                    }

                } else {
                    print("Could not map data")
                }
            }

        })
        
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
        
//        if CLLocationManager.authorizationStatus() != .AuthorizedAlways {
//            let message = "Can't determine location. Please enable location services in settings"
//            showAlertWithMessage("", message: message)
//        }
        
        // Create a circular region for monitoring
        
        let coordinate = CLLocationCoordinate2D(latitude: 37.701029, longitude: -121.773526)
        let name = "Some place"
        let region = CLCircularRegion(center: coordinate, radius: radius, identifier: name)
        
        locationManager.startMonitoringForRegion(region)
        
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
            
        }
    }
    
    func locationManager(manager: CLLocationManager, didExitRegion region: CLRegion) {
        if region is CLCircularRegion {
            
        }        
    }
    
    func locationManager(manager: CLLocationManager, monitoringDidFailForRegion region: CLRegion?, withError error: NSError) {
        print("Monitoring failed for region with identifier: \(region!.identifier)")
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Location Manager failed with error: \(error)")
    }
    
    
}




