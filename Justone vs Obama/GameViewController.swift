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

class GameViewController: UIViewController {

    /*
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            
            if let scene = SKScene(fileNamed: "GameScene") {
                
                // Set the scale mode fit the window:
                scene.scaleMode = .aspectFill
                // Size our scene to fit the view exactly:
                scene.size = view.bounds.size
                // Show the new scene
                view.presentScene(scene)
            }
            
            view.ignoresSiblingOrder = true
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }
 */
    
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
