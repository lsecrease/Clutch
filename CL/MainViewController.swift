//
//  MainViewController.swift
//  CL
//
//  Created by iwritecode on 1/3/17.
//  Copyright © 2017 iwritecode. All rights reserved.
//

import CoreLocation
import Firebase
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
    
    let dateFormatter = DateFormatter()
    
    
    // MARK: View life-cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set category
        gameCategory = .nba
        
        configureViews()
        
        // Core location setup
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.requestAlwaysAuthorization()
        
        setupGeofencing()
        
        ref = FIRDatabase.database().reference()
        
        dateFormatter.dateStyle = .full
        dateFormatter.timeStyle = .medium
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async { 
            // self.getGameDataFor(self.gameCategory!)
        }

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if CLLocationManager.authorizationStatus() != .authorizedAlways {
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined:
                locationManager.requestAlwaysAuthorization()
            case .denied:
                showAlertWithMessage("Error", message: "Location Services not enabled")
            case .authorizedAlways:
                locationManager.startUpdatingLocation()
            default:
                break
            }
        }
        
    }
    
    
    // MARK: Status Bar
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    
    // MARK: Custom UI functions
    
    func configureViews() {
        
        // Navbar title
        if let barFont = UIFont(name: "Symbol", size: 26.0) {
            UINavigationBar.appearance().titleTextAttributes = [
                NSForegroundColorAttributeName: UIColor.white,
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
    
    func showAlertWithMessage(_ title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    // MARK: Firebase Database functions
    
    func passGameDataToOtherVCs(_ games: [Game]) {
        
        if let gameVC = self.storyboard?.instantiateViewController(withIdentifier: "GameViewController") as? GameViewController {
            gameVC.games = games
        }
    }
    
    func categoryString(_ category: CategoryType) -> String {
        switch category {
        case .mlb:
            return "mlb"
        case .mls:
            return "mls"
        case .ncaaBasketball:
            return "ncaa-basketball"
        case .ncaaFootball:
            return "ncaa-football"
        case .nba:
            return "nba"
        case .nfl:
            return "nfl"
        case .nhl:
            return "nhl"
        }

    }
    
//    func getGameDataFor(category: CategoryType) {
//        
//        let categoryName = categoryString(category)
//        
//        gamesRef = FIRDatabase.database().reference().child("games").child("category").child(categoryName)
//        
//        refHandle = gamesRef.observeEventType(FIRDataEventType.Value, withBlock: { (snapshot) in
//            if !snapshot.exists() {
//                print("NO SNAPSHOT AVAILABLE")
//            } else {
//                
//                if let allKeys = snapshot.value?.allKeys as? [String] {
//                    self.gameKeys = allKeys
//                    
//                    for key in self.gameKeys {
//                        
//                        if let currentGame = snapshot.value!.valueForKey(key) {
//                            var gameData = Game()
//                            gameData.category = categoryName
//                            gameData.gameID = key
//                            gameData.venue = currentGame.valueForKey("venue")! as! String
//                            gameData.latitude = currentGame.valueForKey("latitude") as! Float
//                            gameData.longitude = currentGame.valueForKey("longitude") as! Float
//                            
//                            let dateString = currentGame.valueForKey("end-registration") as! String
//                            
//                            print("DATE STRING: " + dateString)
////                            gameData.endRegistration = self.dateFormatter.dateFromString(dateString)!
//                            
//                            
//                            // GET TEAM 1 INFO
//                            
//                            if let team1 = currentGame.valueForKey("team1") as? NSMutableDictionary {
//                                
//                                print(team1.allKeys)
//                                
//                                if let teamname = team1.valueForKey("teamname") as? String {
//                                    gameData.team1.name = teamname
//                                }
//                                
//                                if let players = team1.valueForKey("players") as? NSMutableDictionary {
//                                    var playerKeys = [String]()
//
//                                    for player in players {
//                                        playerKeys.append(player.key as! String)
//                                        
//                                        if let playerInfo = player.value as? NSDictionary {
//                                            var playerObject = Player()
//                                            playerObject.name = playerInfo.valueForKey("name") as! String
//                                            playerObject.pointValue = playerInfo.valueForKey("point-value") as! Float
//                                            playerObject.number = playerInfo.valueForKey("number") as! Int
//                                            gameData.team1.players += [playerObject]
//                                        }
//                                    }
//                                    
//                                }
//                            }
//                            
//                            
//                            // GET TEAM 2 INFO
//                            if let team2 = currentGame.valueForKey("team2") as? NSMutableDictionary {
//                                
//                                
//                                // Get team 2 name
//                                if let teamname = team2.valueForKey("teamname") as? String {
//                                    gameData.team2.name = teamname
//                                }
//                                
//                                // Get team 2 players
//                                if let players2 = team2.valueForKey("players") as? NSMutableDictionary {
//                                    var playerKeys = [String]()
//                                    
//                                    for player in players2 {
//                                        playerKeys.append(player.key as! String)
//                                        
//                                        if let playerInfo = player.value as? NSDictionary {
//                                            var playerObject = Player()
//                                            playerObject.name = playerInfo.valueForKey("name") as! String
//                                            playerObject.pointValue = playerInfo.valueForKey("point-value") as! Float
//                                            playerObject.number = playerInfo.valueForKey("number") as! Int
//                                            gameData.team2.players += [playerObject]
//                                        }
//                                    }
//                                    
//                                } else if let players2 = team2.valueForKey("players") as? NSDictionary {
//                                    print("GOT DATA AS DICTIONARY")
//                                }
//                                
//                            }
//                            self.games.append(gameData)
//                        }
//                    }
//                    
//                    // DEBUGGING....
//                    
////                    for game in self.games {
////                        print(game.category)
////                        print(game.venue)
////                        print(game.gameID)
////                        print(game.latitude)
////                        print(game.longitude)
////                        print(game.team1.name)
////                        print(game.team1.players)
////                        print(game.team2.name)
////                        print(game.team2.players)
////                        print(game.endRegistration)
////                        print("\n")
////                    }
//                    
//                    self.passGameDataToOtherVCs(self.games)
//
//                } else {
//                    print("Could not map data")
//                }
//            }
//
//        })
//        
//    }

    
    // MARK: Geofencing functions
    
    func setupGeofencing() {
        
        // Per Apple Guidelines, check if device is capable of monitoring regions
        
        if !CLLocationManager.isMonitoringAvailable(for: CLRegion.self) {
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
        
        locationManager.startMonitoring(for: region)
        
    }
    
    
    // MARK: IBAction methods
    
    @IBAction func segmentButtonPressed(_ sender: UIButton) {
        
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
    
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        
        for child in self.childViewControllers {
            if let gameVC = child as? GameViewController {
                gameVC.slideGameViews(direction: .right)
                gameVC.gameRosterViewIsActive = false
            }
        }
        
    }
    
    @IBAction func checkInButtonPressed(_ sender: UIButton) {
        print("Check-in button pressed")
    }
    
    func updateBarButtons() {
        if !liveContainerView.isHidden && liveTeamViewIsActive {
            self.checkInbutton.show()
        } else {
            self.checkInbutton.hide()
        }
        
        if !gameContainerView.isHidden && gameRosterViewIsActive {
            self.cancelButton.show()
        } else {
            self.cancelButton.hide()
        }
        
    }
    
}

// MARK: CLLocationManagerDelegate

extension MainViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            manager.startUpdatingLocation()
        case .denied:
            manager.stopUpdatingLocation()
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        if region is CLCircularRegion {
            
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        if region is CLCircularRegion {
            
        }        
    }
    
    func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
        print("Monitoring failed for region with identifier: \(region!.identifier)")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location Manager failed with error: \(error)")
    }
    
    
}




