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

class GameViewController: UIViewController, SKSceneDelegate {
    
    var musicPlayer = AVAudioPlayer()
    
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
}
