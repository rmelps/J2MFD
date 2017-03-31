//
//  GameScene.swift
//  Justone vs Obama
//
//  Created by Richard Melpignano on 3/22/17.
//  Copyright © 2017 J2MFD. All rights reserved.
//

import SpriteKit
import GameplayKit
import CoreMotion

class GameScene: SKScene {
    
    let player = Player()
    let cam = SKCameraNode()
    let ground = Ground()
    let motionManager = CMMotionManager()
    var screenCenterY = CGFloat()
    let initialPlayerPosition = CGPoint(x: 150, y: 250)
    var playerProgress = CGFloat()
    let encounterManager = EncounterManager()
    var nextEncounterSpawnPosition: CGFloat = 150
    var increaseXCamDiff: CGFloat = 0
    let oilCan = Oil()
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        // Position from the lower left corner
        self.anchorPoint = .zero
        // Set the scene's background to a nice sky blue
        // Note: UIColor uses a scale from 0 to 1 for its colors
        self.backgroundColor = UIColor(red: 0.4, green: 0.6, blue: 0.95, alpha: 1.0)
        
        // Assign the camera to the scene
        self.camera = cam
        
        // Position the ground based on the screen size
        // Position X: negative one screen width
        // Position Y: 150 above the bottom (remember the top left anchor point)
        ground.position = CGPoint(x: -self.size.width * 2, y: self.size.height / 6)
        
        // Set the ground width to 3x the width of the scene
        // The height can be 0, our child nodes will create the height
        ground.size = CGSize(width: self.size.width * 6, height: 0)
        
        // Run the ground's createChildren function to build the child texture tiles
        ground.createChildren()
        // Add the ground to the scene
        self.addChild(ground)
        
        // Position the player
        player.position = initialPlayerPosition
        
        // Add the player node to the screen
        self.addChild(player)
        
        // Place the oil can out of the way for now
        self.addChild(oilCan)
        oilCan.position = CGPoint(x: -1000, y: -1000)
        
        // Start reporting orientation data
        self.motionManager.startAccelerometerUpdates()
        
        // Set gravity
        self.physicsWorld.gravity = CGVector(dx: 0, dy: -5)
        
        // Store the vertical center of the screen
        screenCenterY = self.size.height / 2
        
        // Set initial camera position
        self.camera!.position = player.position
        
        // Add each encounter node as a child of the GameScene node
        encounterManager.addEncountersToScene(gameScene: self)
        
        // Set position of first encounter
        encounterManager.encounters[0].position = CGPoint(x: 2000, y: 200)
    }
    
    override func didSimulatePhysics() {
        super.didSimulatePhysics()
        // Keep the camera locked at midscreen by default
        var cameraYPos = screenCenterY
        var cameraXPos = player.position.x + increaseXCamDiff
        cam.yScale = 1
        cam.xScale = 1
        
        if increaseXCamDiff < UIScreen.main.bounds.width / 3 {
            increaseXCamDiff += 0.5
            cameraXPos = player.position.x + increaseXCamDiff
            print("player: \(player.position.x), camera: \(cameraXPos)")
        }
        
        // Follow the player up if higher than half the screen
        if player.position.y > screenCenterY {
            cameraYPos = player.position.y
            
            // Scale out the camera as they go higher
            let percentOfMaxHeight = (player.position.y - screenCenterY) / (player.maxHeight - screenCenterY)
            let newScale = 1 + percentOfMaxHeight
            cam.yScale = newScale
            cam.xScale = newScale
            
            // Move the camera for our adjustment
            self.camera!.position = CGPoint(x: cameraXPos, y: cameraYPos)
        } else {
            self.camera?.position = CGPoint(x: cameraXPos, y: cameraYPos)
        }
        
        // Keep track of how far the player has flown
        playerProgress = player.position.x - initialPlayerPosition.x
        
        // Check to see if the ground should jump forward
        ground.checkForReposition(playerprogress: playerProgress)
        
        // Check to see if a new encounter shoud be set
        if player.position.x > nextEncounterSpawnPosition {
            encounterManager.placeNextEncounter(currentXPos: nextEncounterSpawnPosition)
            nextEncounterSpawnPosition += 1200
            
            // Each encounter has a 10% chance to spawn an oil can
            let oilChance = Int(arc4random_uniform(10))
            if oilChance == 0 {
                // Only move the can if it is off the screen
                if abs(player.position.x - oilCan.position.x) > 1200 {
                    // Y Position 50 - 450
                    let randomYPos = 50 + CGFloat(arc4random_uniform(400))
                    oilCan.position = CGPoint(x: nextEncounterSpawnPosition, y: randomYPos)
                    // Remove any previous velocity and spin
                    oilCan.physicsBody?.angularVelocity = 0
                    oilCan.physicsBody?.velocity = CGVector.zero
                }
            }
        }

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in (touches) {
            
            // Find the location of the touch
            let location = touch.location(in: self)
            
            // Locate the node at this location
            let nodeTouched = atPoint(location)
            
            // Attempt to downcast the node to the GameSprite protocol
            if let gameSprite = nodeTouched as? GameSprite {
                
                // If this node adheres to GameSprite, call onTap
                gameSprite.onTap()
            }
        }
        
        player.startFlying()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        player.stopFlying()
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        player.stopFlying()
    }
    
    override func update(_ currentTime: TimeInterval) {
        player.update()
        
        
        // Unwrap the accelerometer data optional
        if let accelData = self.motionManager.accelerometerData {
            var forceAmount: CGFloat
            //var movement = CGVector()
            
            // Based on the device orientation, the tilt number can indicate
            // opposite user desires. The UIApplication class exposes an enum
            // that allows us to pull the current orientation
            switch UIApplication.shared.statusBarOrientation {
            case .landscapeLeft:
                forceAmount = 200
                
            case .landscapeRight:
                forceAmount = -200
            default:
                forceAmount = 0
            }
            
            // If the device is tilted more than 15% towards vertical
            // then we want to move Justone
            let accelY = accelData.acceleration.y
            
            switch accelY {
            case 0.05 ... 0.15:
                player.physicsBody?.velocity.dx += forceAmount / 2
            case -0.15 ... -0.05:
                player.physicsBody?.velocity.dx -= forceAmount / 2
            case _ where accelY > 0.15 :
                player.physicsBody?.velocity.dx += forceAmount
            case _ where accelY < -0.15:
                player.physicsBody?.velocity.dx -= forceAmount
            default:
                break
            }
        }
        
        // Turn justone into the landing position upon landing
        if player.physicsBody!.velocity.dy == CGFloat(0) {
            let rotateUp = SKAction.rotate(toAngle: 0, duration: 0.475)
            player.run(rotateUp)
        }
    }
}
