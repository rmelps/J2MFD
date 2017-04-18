//
//  GameViewController.swift
//  Justone vs Obama
//
//  Created by Richard Melpignano on 3/22/17.
//  Copyright © 2017 J2MFD. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit
import AVFoundation
import MapKit

class GameViewController: UIViewController {
    
    var musicPlayer = AVAudioPlayer()
    let map = MKMapView()
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        // Build the menu scene
        let menuScene = MenuScene()
        let skView = self.view as! SKView
        // Ignore drawing order of child nodes to increase performance
        skView.ignoresSiblingOrder = true
        // Size our scene to fit the view exactly
        menuScene.size = view.bounds.size
        // Show the menu
        skView.presentScene(menuScene)
        menuScene.viewController = self
        
        // Add map
        let center = CLLocationCoordinate2D(latitude: 0, longitude: 0)
        let span = MKCoordinateSpan(latitudeDelta: 30, longitudeDelta: 300)
        let mapWidth: CGFloat = 50.0
        let mapHeight: CGFloat = 50.0
        let origin = CGPoint(x: self.view.frame.width - mapWidth , y: 0.0)
        map.region = MKCoordinateRegion(center: center, span: span)
        map.frame = CGRect(origin: origin, size: CGSize(width: mapWidth, height: mapHeight))
        map.isHidden = true
        self.view.addSubview(map)

        
        // Start the background music
        if let musicPath = Bundle.main.path(forResource: "Sound/TheSafetyDance", ofType: "mp3") {
            let url = URL(fileURLWithPath: musicPath)
            do {
                musicPlayer = try AVAudioPlayer(contentsOf: url)
                musicPlayer.numberOfLoops = -1
                musicPlayer.prepareToPlay()
                musicPlayer.setVolume(0.7, fadeDuration: 0.5)
                musicPlayer.play()
            } catch {
                print("Couldn't load music file")
            }
        }
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscape
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func update() {
        let skView = self.view as! SKView
        
        if let name = skView.scene?.name, name == "Game" {
            map.isHidden = false
        }
    }
}
