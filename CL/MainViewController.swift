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
    
    let dateFormatter = NSDateFormatter()
    
    
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
        
        dateFormatter.dateStyle = .FullStyle
        dateFormatter.timeStyle = .MediumStyle
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0)) { 
            self.getGameDataFor(self.gameCategory!)
        }

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
    
    func passGameDataToOtherVCs(games: [Game]) {
        
        if let gameVC = self.storyboard?.instantiateViewControllerWithIdentifier("GameViewController") as? GameViewController {
            gameVC.games = games
        }
    }
    
    
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
                
                if let allKeys = snapshot.value?.allKeys as? [String] {
                    self.gameKeys = allKeys
                    
                    for key in self.gameKeys {
                        
                        if let currentGame = snapshot.value!.valueForKey(key) {
                            var gameData = Game()
                            gameData.category = categoryName
                            gameData.gameID = key
                            gameData.venue = currentGame.valueForKey("venue")! as! String
                            gameData.latitude = currentGame.valueForKey("latitude") as! Float
                            gameData.longitude = currentGame.valueForKey("longitude") as! Float
                            
                            let dateString = currentGame.valueForKey("end-registration") as! String
                            gameData.endRegistration = self.dateFormatter.dateFromString(dateString)!
                            
                            
                            // GET TEAM 1 INFO
                            
                            if let team1 = currentGame.valueForKey("team1") as? NSMutableDictionary {
                                
                                print(team1.allKeys)
                                
                                if let teamname = team1.valueForKey("teamname") as? String {
                                    gameData.team1.name = teamname
                                }
                                
                                if let players = team1.valueForKey("players") as? NSMutableDictionary {
                                    var playerKeys = [String]()

                                    for player in players {
                                        playerKeys.append(player.key as! String)
                                        
                                        if let playerInfo = player.value as? NSDictionary {
                                            var playerObject = Player()
                                            playerObject.name = playerInfo.valueForKey("name") as! String
                                            playerObject.pointValue = playerInfo.valueForKey("point-value") as! Float
                                            playerObject.number = playerInfo.valueForKey("number") as! Int
                                            gameData.team1.players += [playerObject]
                                        }
                                    }
                                    
                                }
                            }
                            
                            
                            // GET TEAM 2 INFO
                            if let team2 = currentGame.valueForKey("team2") as? NSMutableDictionary {
                                
                                
                                // Get team 2 name
                                if let teamname = team2.valueForKey("teamname") as? String {
                                    gameData.team2.name = teamname
                                }
                                
                                // Get team 2 players
                                if let players2 = team2.valueForKey("players") as? NSMutableDictionary {
                                    var playerKeys = [String]()
                                    
                                    for player in players2 {
                                        playerKeys.append(player.key as! String)
                                        
                                        if let playerInfo = player.value as? NSDictionary {
                                            var playerObject = Player()
                                            playerObject.name = playerInfo.valueForKey("name") as! String
                                            playerObject.pointValue = playerInfo.valueForKey("point-value") as! Float
                                            playerObject.number = playerInfo.valueForKey("number") as! Int
                                            gameData.team2.players += [playerObject]
                                        }
                                    }
                                    
                                } else if let players2 = team2.valueForKey("players") as? NSDictionary {
                                    print("GOT DATA AS DICTIONARY")
                                }
                                
                            }
                            self.games.append(gameData)
                        }
                    }
                    
                    // DEBUGGING....
                    
                    for game in self.games {
                        print(game.category)
                        print(game.venue)
                        print(game.gameID)
                        print(game.latitude)
                        print(game.longitude)
                        print(game.team1.name)
                        print(game.team1.players)
                        print(game.team2.name)
                        print(game.team2.players)
                        print(game.endRegistration)
                        print("\n")
                    }
                    
                    self.passGameDataToOtherVCs(self.games)

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




