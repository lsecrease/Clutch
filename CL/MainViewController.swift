
//  MainViewController.swift
//  CL
//
//  Created by iwritecode on 1/3/17.
//  Copyright © 2017 iwritecode. All rights reserved.
//

import CoreLocation
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import UIKit
import FBSDKCoreKit
import FBSDKLoginKit


protocol ChildViewProtocol {
    func updateGameData(allGames : [Game], activeGames: [Game], sender : UIViewController)
}

// MARK: - ManinViewController
class MainViewController: UIViewController, GameViewDelegate {
    
    // MARK: IBOutlets
    
    var childViews : [ChildViewProtocol] = []

    
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
    @IBOutlet weak var logoutButton: UIButton!
    
    // MARK: Properties
        
    // Firebase properties
    var ref : FIRDatabaseReference?
    var gamesRef : UInt?
    
    var allGames = [Game]()
    var activeGames : [Game] = []
    var selectedGame : Game?
    var atGame : Game?

    
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
        
        configureViews()
        
        dateFormatter.dateStyle = .full
        dateFormatter.timeStyle = .medium
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? ChildViewProtocol {
            childViews.append(vc)
        }
        
        if let gameVC = segue.destination as? GameViewController {
            gameVC.delegate = self
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        ref = FIRDatabase.database().reference()
        self.updateGames()
        
        // Core location setup
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.requestAlwaysAuthorization()
        
        setupGeofencing()
        
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
        logoutButton.show()
        
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
        self.checkInbutton.isHidden = true
        self.selectedGame = nil
        
        for child in self.childViewControllers {
            if let gameVC = child as? GameViewController {
                gameVC.slideGameViews(direction: .right)
                gameVC.gameRosterViewIsActive = false
            }
        }
        
    }
    @IBAction func logoutButtonPressed(_ sender: Any) {
        try! FIRAuth.auth()!.signOut()
        let loginManager = FBSDKLoginManager()
        loginManager.logOut()
        
        let _ = self.navigationController?.popViewController(animated: true)

    }
    
    @IBAction func checkInButtonPressed(_ sender: UIButton) {
        print("Check-in button pressed")
        guard let safeGame = selectedGame, let safeCurrentUser = FIRAuth.auth()?.currentUser else { return }
        
        let currentParticipant = safeGame.participants.filter({$0.userId == safeCurrentUser.uid}).first
        if currentParticipant?.checkInTime == nil{
            
            let currentDate = Date()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            
            let fullDateFormatter = DateFormatter()
            fullDateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
            
            self.ref = FIRDatabase.database().reference()
            var childUpdates : [String: AnyObject] = [:]
            if let safeDate = safeGame.gameStartTime{
                let gameDate = dateFormatter.string(from: safeDate)
                childUpdates["/games/\(gameDate)/\(safeGame.gameID)/participants/\(safeCurrentUser.uid)/checkInTime"] = fullDateFormatter.string(from: currentDate) as AnyObject?
                
                self.ref?.updateChildValues(childUpdates, withCompletionBlock: { (error, ref) in
                    if error == nil {
                        // update selected game
                        let safeSelectedGame = self.allGames.filter({$0.gameID == safeGame.gameID}).first
                        self.gameSelected(game: safeSelectedGame)
                    }
                })
            }
        }
    }
    
    func updateBarButtons() {
        
        if !gameContainerView.isHidden && gameRosterViewIsActive {
            self.cancelButton.show()
        } else {
            self.cancelButton.hide()
        }
        
        if !profileContainerView.isHidden{
            self.logoutButton.show()
        }else{
            self.logoutButton.hide()
            //My change
            self.checkInbutton.isHidden = true
        }
        
    }
    
    // MARK: GameViewDelegate
    
    func gameSelected(game: Game?) {
        // location stuff to enable the check in button
        selectedGame = game
        
        if game == nil {
            self.checkInbutton.isHidden = true
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
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        guard let currentCoord = manager.location?.coordinate else {
            return
        }
        
        if let safeSelectedGame = selectedGame {
            if self.isNearGame(game: safeSelectedGame, currentLocation: currentCoord) {
                self.checkInbutton.isHidden = false
                self.atGame = self.selectedGame
            } else {
                self.checkInbutton.isHidden = true
  
            }
        }
        
        
        if self.isNearGame(game: self.atGame, currentLocation: currentCoord) == false {
            guard let safeGame = selectedGame, let safeCurrentUser = FIRAuth.auth()?.currentUser else { return }
            let currentDate = Date()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            
            let fullDateFormatter = DateFormatter()
            fullDateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"

            
            var childUpdates : [String: AnyObject] = [:]
            if let safeDate = safeGame.gameStartTime{
                let gameDate = dateFormatter.string(from: safeDate)
                childUpdates["/games/\(gameDate)/\(safeGame.gameID)/participants/\(safeCurrentUser.uid)/leaveTime"] = fullDateFormatter.string(from: currentDate) as AnyObject?
                
                self.ref?.updateChildValues(childUpdates, withCompletionBlock: { (error, ref) in
                    if error == nil {
                        self.setDisqualified()
                    }
                })
            }
            


            
            self.atGame = nil
        }
    }
    
    func isNearGame(game: Game?, currentLocation: CLLocationCoordinate2D) -> Bool {
        let currentLocation = CLLocation(latitude: currentLocation.latitude, longitude: currentLocation.longitude)
        
        if let safeSelectedGame = selectedGame, let safeLat = safeSelectedGame.latitude, let safeLon = safeSelectedGame.longitude {
            let gameLocation = CLLocation(latitude: CLLocationDegrees(safeLat), longitude: CLLocationDegrees(safeLon))
            let distance = gameLocation.distance(from: currentLocation)
            
            return distance < 500
        }
        
        return false
    }
    
    func setDisqualified(){
        guard let safeGame = selectedGame, let safeCurrentUser = FIRAuth.auth()?.currentUser, let safeGameStartTime = safeGame.gameStartTime else { return }


        let gameDate = dateFormatter.string(from: safeGameStartTime)

        
        let gameQuery = ref?.child("games/\(gameDate)/\(safeGame.gameID)")
        gamesRef = gameQuery?.observe(.value, with: { (snapshot) in
            
            if let game = snapshot.value as? [String: AnyObject]{
                let endGameTime = game["endGameTime"] as? Date
                
                if let participants = game["participant"] as? [String : AnyObject] {
                    if let participant = participants["\(safeCurrentUser.uid)"] as? [String : AnyObject] {
                        
                        let leaveTime = participant["leavelTime"] as? Date
                        var childUpdates : [String: AnyObject] = [:]

                        if let safeLeaveTime = leaveTime {
                            
                            if endGameTime == nil {
                                childUpdates["/participants/\(safeCurrentUser.uid)/disqualified"] = true as AnyObject?
                            } else if safeLeaveTime.compare(endGameTime!) == ComparisonResult.orderedDescending {
                                //set disqualified to true
                                childUpdates["/participants/\(safeCurrentUser.uid)/disqualified"] = false as AnyObject?
                            } else {
                                //set disqualified to false
                                childUpdates["/participants/\(safeCurrentUser.uid)/disqualified"] = true as AnyObject?
                                
                            }
                            self.ref?.updateChildValues(childUpdates)
                        }
                    }
                    
                }
                
            }
            
        })
        
        
    }
    
    // MARK: - Custom methods
    func updateGames(){
        let gamesQuery = ref?.child("games")
        gamesRef = gamesQuery?.observe(.value, with: { (snapshot) in
            if let games = snapshot.value as? [String : AnyObject] {
                
                self.allGames = [] // clear allGames array
                
                //save games to classes
                for gameByDate in games{
                    if let gameByID = gameByDate.1 as? [String:AnyObject]{
                        for game in gameByID{
                            let currentGame = Game(gameDict: game)
                            self.allGames.append(currentGame)
                        }
                    }
                }
                
                //clear out game array
                self.activeGames = []
                
                for game in self.allGames{
                    if game.endGameTime == nil{
                        self.activeGames.append(game)
                    }
                }
                
                //sort by date
                self.allGames.sort(by: {
                    guard let safeFirstStartDate = $0.gameStartTime, let safeSecondStartDate = $1.gameStartTime else { return true }
                    
                    return safeFirstStartDate.compare(safeSecondStartDate) == .orderedAscending
                })
                
                self.activeGames.sort(by: {
                    guard let safeFirstStartDate = $0.gameStartTime, let safeSecondStartDate = $1.gameStartTime else { return true }
                    
                    return safeFirstStartDate.compare(safeSecondStartDate) == .orderedAscending
                })
            }
            for childView in self.childViews {
                childView.updateGameData(allGames: self.allGames, activeGames: self.activeGames, sender: self)
            }
        })
    }
}




