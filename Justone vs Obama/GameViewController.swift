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
import GoogleMobileAds

class GameViewController: UIViewController, SKSceneDelegate, GADInterstitialDelegate {
    
    // Google Interstitial Ads
    var interstitial: GADInterstitial!
    
    var musicPlayer = AVAudioPlayer()
    var bootLoad = true
    var isSoundOn = true
    var isMusicOn = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("loading viewController......")
        interstitial = createAndLoadInterstitial()
        
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
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        // Only display the menu scene if the viewController is bootloading
        if bootLoad {
            // Build the menu scene
            let menuScene = MenuScene()
            let skView = self.view as! SKView
            // Ignore drawing order of child nodes to increase performance
            skView.ignoresSiblingOrder = true
            // Size our scene to fit the view exactly
            menuScene.size = view.bounds.size
            // Show the menu
            skView.presentScene(menuScene)
            bootLoad = false
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
    
    func createAndLoadInterstitial() -> GADInterstitial {
        let interstitialAd = GADInterstitial(adUnitID: "ca-app-pub-4908431977013240/5183765813")
        interstitialAd.delegate = self
        // Implement and load Google Interstitial Ad
        let request = GADRequest()
        // Request test ads on devices you specify. Your test device ID is printed to the console when
        // an ad request is made.
        request.testDevices = [ kGADSimulatorID, "6ae7f73e0e8781edf6b04e6967e3cba1" ]
        interstitialAd.load(request)
        
        return interstitialAd
    }
    
    func interstitialWillDismissScreen(_ ad: GADInterstitial) {
        presentGameScene()
        interstitial = createAndLoadInterstitial()
    }
    
    func loadAd() {
        // Display interstitial ad
        if interstitial.isReady {
            interstitial.present(fromRootViewController: self)
        } else {
            print("Ad wasn't ready")
            presentGameScene()
        }
    }
    
    func presentGameScene() {
        let gameScene = GameScene()
        let skView = self.view as! SKView
        // Ignore drawing order of child nodes to increase performance
        skView.ignoresSiblingOrder = true
        // Size our scene to fit the view exactly
        gameScene.size = view.bounds.size
        // Show the gamescene
        skView.presentScene(gameScene)
    }
}
