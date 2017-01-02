//
//  MainViewController.swift
//  CL
//
//  Created by iwritecode on 11/26/16.
//  Copyright © 2016 iwritecode. All rights reserved.
//

import UIKit
import CoreLocation

class MainViewController: UIViewController {
    
    let segmentTitles = ["Profile", "Game", "Live"]
    
    // MARK: Main IBOutlets
    
    @IBOutlet weak var profileButton: UIButton!
    @IBOutlet weak var gameButton: UIButton!
    @IBOutlet weak var liveButton: UIButton!
    
    @IBOutlet weak var profileUnderlineLabel: UILabel!
    @IBOutlet weak var gameUnderlineLabel: UILabel!
    @IBOutlet weak var liveUnderlineLabel: UILabel!
    
    @IBOutlet weak var profileView: UIView!
    
    var currentView: UIView!
    
    var gameRosterViewIsActive: Bool = true
    var liveTeamViewIsActive: Bool = false
    
    // Core Location
    var locationManager: CLLocationManager!
    
    
    // MARK: LIVE VIEW
    @IBOutlet weak var checkInButton: UIButton!
    @IBOutlet weak var liveView: UIView!
    @IBOutlet weak var liveTeamView: UIView!
    @IBOutlet weak var liveTeamViewCenterX: NSLayoutConstraint!
    @IBOutlet weak var leaderboardView: UIView!
    @IBOutlet weak var leaderboardViewCenterX: NSLayoutConstraint!
    
    
    // MARK: Live Team View
    
    // Live Team View IBOutlets
    @IBOutlet weak var liveTeamCollectionView: UICollectionView!
    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet weak var totalPointsLabel: UILabel!
    
    // Live Team view properties
    let idCellGameInfo = "idCellGameInfo"
    let idCellLeaderboard = "idCellLeaderboard"
    let idCellLiveTeam = "idCellLiveTeam"

    
    // MARK: GAME VIEW
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var gameView: UIView!
    @IBOutlet weak var gameMatchupView: UIView!
    @IBOutlet weak var gameMatchupCollectionView: UICollectionView!
    @IBOutlet weak var gameRosterCollectionView: UICollectionView!
    @IBOutlet weak var gameMatchupViewCenterX: NSLayoutConstraint!
    @IBOutlet weak var gameRosterViewCenterX: NSLayoutConstraint!
    var gameMatchupViewIsActive = false
    
    
    // MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViews()
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // Position GAME views
        gameRosterViewCenterX.constant += self.view.bounds.width
        
//        let locationManager = CLLocationManager()
//        locationManager.delegate = self
//        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        locationManager.requestWhenInUseAuthorization()
        
    }
    
    override func viewDidLayoutSubviews() {
        
    }


    
    // IBOutlets
//    @IBOutlet weak var leaderboardCollectionView: UICollectionView!

    
    // MARK: IBActions
    @IBAction func sectionButtonPressed(sender: UIButton) {
        
        currentView.hide()
        
        switch sender {
            
        case profileButton:
            profileUnderlineLabel.show()
            gameUnderlineLabel.hide()
            liveUnderlineLabel.hide()
            profileView.show()
            gameView.hide()
            currentView = profileView
            
        case gameButton:
            profileUnderlineLabel.hide()
            gameUnderlineLabel.show()
            liveUnderlineLabel.hide()
            gameView.show()
            profileView.hide()
            liveView.hide()
            currentView = gameView
            
        case liveButton:
            profileUnderlineLabel.hide()
            gameUnderlineLabel.hide()
            liveUnderlineLabel.show()
            liveView.show()
            gameView.hide()
            profileView.hide()
            currentView = liveView
            
            checkInButton.show()
        default:
            break
            
        }
    }
    
    @IBAction func leaderboardButtonPressed(sender: UIButton) {
        
        UIView.animateWithDuration(0.2, delay: 0.0, options: .CurveLinear, animations: { 
            self.liveTeamViewCenterX.constant -= self.view.bounds.width
            self.leaderboardViewCenterX.constant -= self.view.bounds.width
            self.view.layoutIfNeeded()
        }) { (finished) in
            self.liveTeamViewIsActive = false
            self.updateViews()
        }
    }
    
    @IBAction func myTeamButtonPressed(sender: UIButton) {
        
        slideViewCenterXConstraints(liveTeamViewCenterX, centerXConstraint2: leaderboardViewCenterX, direction: .Right)
        self.liveTeamViewIsActive = true
        self.updateViews()

    }
    
    @IBAction func cancelRosterButtonPressed(sender: UIButton) {
        self.slideViewCenterXConstraints(gameMatchupViewCenterX, centerXConstraint2: gameRosterViewCenterX, direction: .Right)
        gameRosterViewIsActive = false
        updateViews()
    }
    
    
    // MARK: Custom UI functions

    func configureViews() {
        
        // Indicate and set current view is profileView
        profileUnderlineLabel.show()
        currentView = profileView
        
        // Register Collection view cells
        registerCells()
        
        // Set active views
        liveTeamViewIsActive = true
        gameRosterViewIsActive = false

    }
    
    func updateViews() {
        
        if liveTeamViewIsActive {
            checkInButton.show()
        } else {
            // checkInButton.hidden = true
            checkInButton.hide()
        }
        
        if gameRosterViewIsActive {
            cancelButton.show()
        } else {
            cancelButton.hide()
        }
    
    }
    
    // MARK: Utility functions
    
    func registerCells() {
        
    }
    
    func registerHeadersForCollectionCells() {

    }
    
    func swapViews(fromView fromView: UIView, toView: UIView) {
        fromView.alpha = 1
        fromView.hidden = false
        toView.alpha = 0
        toView.hidden = true

        UIView.animateWithDuration(0.2) {
            toView.hidden = false
            toView.alpha = 1
            fromView.alpha = 0
            
            toView.alpha = 1
            fromView.hidden = false
        }
    }
    
    func showView(view: UIView) {
        if !view.hidden {
            return
        } else {
            view.alpha = 0
            view.hidden = true
            
            UIView.animateWithDuration(0.3, animations: {
                view.hidden = false
                self.currentView.alpha = 0
                view.alpha = 1
                self.currentView.hidden = true
                }, completion: { (true) in
                    self.currentView = view
            })
        }
    }
    
    func slideViewCenterXConstraints(centerXConstraint1: NSLayoutConstraint, centerXConstraint2: NSLayoutConstraint, direction: Direction) {
        
        if direction == .Right {
            UIView.animateWithDuration(0.2, delay: 0.0, options: .CurveLinear, animations: {
                centerXConstraint1.constant += self.view.bounds.width
                centerXConstraint2.constant += self.view.bounds.width
                self.view.layoutIfNeeded()
                }, completion: nil)
        } else if direction == .Left {
            UIView.animateWithDuration(0.2, delay: 0.0, options: .CurveLinear, animations: {
                centerXConstraint1.constant -= self.view.bounds.width
                centerXConstraint2.constant -= self.view.bounds.width
                self.view.layoutIfNeeded()
                }, completion: nil)
        }

    }

}


// MARK: - UICollection View Delegate Flow Layout function(s)

extension MainViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let cellWidth: CGFloat = self.view.bounds.width - 15.0
        let cellHeight: CGFloat = 70.0
        return CGSize(width: cellWidth, height: cellHeight)
    }
}



//  MARK: CLLocationManagerDelegate

extension MainViewController: CLLocationManagerDelegate {
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        switch status {
        case .AuthorizedWhenInUse:
            manager.startUpdatingLocation()
        case .Denied, .NotDetermined:
            manager.stopUpdatingLocation()
        default:
            break
        }
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Error: \(error.localizedDescription)")
    }
    
//    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        <#code#>
//    }
//    
//    func locationManager(manager: CLLocationManager, didEnterRegion region: CLRegion) {
//        <#code#>
//    }
//    
//    func locationManager(manager: CLLocationManager, didExitRegion region: CLRegion) {
//        <#code#>
//    }
//    
//    func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation) {
//        <#code#>
//    }
    
}
