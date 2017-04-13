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

enum PhysicsCategory: UInt32 {
    case justone = 1
    case damagedJustone = 2
    case ground = 4
    case obama = 8
    case trump = 16
    case beer = 32
    case oil = 64
    
}

enum GameOver {
    case outOfFuel
    case outOfHealth
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    let player = Player()
    let hud = HUD()
    let cam = SKCameraNode()
    let ground = Ground()
    let motionManager = CMMotionManager()
    var screenCenterY = CGFloat()
    let initialPlayerPosition = CGPoint(x: 150, y: 250)
    var playerProgress = CGFloat()
    var backgrounds = [Background]()
    let encounterManager = EncounterManager()
    var nextEncounterSpawnPosition: CGFloat = 150
    var increaseXCamDiff: CGFloat = 0
    let oilCan = Oil()
    var beersCollected: Int =  0
    var initialHealth = Int()
    
    // Particle Emitters
    let smokeEmitter = SKEmitterNode(fileNamed: "JustoneSmokePath")
    let fireEmitter = SKEmitterNode(fileNamed: "JustoneFirePath")
    let trumpEmitter = SKEmitterNode(fileNamed: "HeadEmitter")
    let obamaEmitter = SKEmitterNode(fileNamed: "HeadEmitter")
    
    // Fuel related parameters
    let distancePerPercent: Int = 1000
    var fuelPercent: Int = 100
    var fuelCounter = Int()
    
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        self.view?.showsFPS = true
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
        
        // inform GameScene of contact events
        self.physicsWorld.contactDelegate = self
        
        // Initialize fuelCounter
        fuelCounter = distancePerPercent
        
        // Add the camera itself to the scene's node tree
        self.addChild(self.camera!)
        
        // Position the camera node above the game elements
        self.camera!.zPosition = 50
        
        // Create the HUDs child nodes
        hud.createHudNodes(screenSize: self.size)
        
        // Add the HUD to camera node's tree
        self.camera?.addChild(hud)
        
        // Instantiate three Backgrounds to the backgrounds array
        for _ in 0..<3 {
            backgrounds.append(Background())
        }
        // Spawn the new backgrounds
        backgrounds[0].spawn(parentNode: self, imageName: "front", zPosition: -5, movementMultiplier: 0.75)
        backgrounds[1].spawn(parentNode: self, imageName: "middle", zPosition: -10, movementMultiplier: 0.5)
        backgrounds[2].spawn(parentNode: self, imageName: "back", zPosition: -15, movementMultiplier: 0.2)
        
        // Further adjust backgrounds for perfection
        backgrounds[1].position = CGPoint(x: 0, y: 20)
        backgrounds[2].position = CGPoint(x: 0, y: 40)
        
        
        // Instantiate an SKEmitterNode with JustoneSmokePath's design
        player.zPosition = 10
        if (smokeEmitter != nil) {
        // Place the particle zPosition behind the penguin
        smokeEmitter?.particleZPosition = 11
        smokeEmitter?.position = CGPoint(x: player.anchorPoint.x + 20, y: player.anchorPoint.y)
        // add smokeEmitter to the player
        player.addChild(smokeEmitter!)
        smokeEmitter?.targetNode = self
        }
        // Add the fire emitter, but make it hidden
        if (fireEmitter != nil) {
            fireEmitter?.particleZPosition = 12
            fireEmitter?.position = CGPoint(x: player.anchorPoint.x + 20, y: player.anchorPoint.y)
            player.addChild(fireEmitter!)
            fireEmitter?.targetNode = self
            fireEmitter?.particleBirthRate = 0
        }
        
        player.stopFlying(fuelLevel: fuelPercent)
    }
    
    override func didSimulatePhysics() {
        super.didSimulatePhysics()
        
        // Keep the camera locked at midscreen by default
        var cameraYPos = screenCenterY
        var cameraXPos = player.position.x + increaseXCamDiff
        cam.yScale = 1
        cam.xScale = 1
        
        // Slowly pan the camera in front of Justone after the GameScene initializes
        if increaseXCamDiff < UIScreen.main.bounds.width / 3 {
            increaseXCamDiff += 0.5
            cameraXPos = player.position.x + increaseXCamDiff
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
        
        // Keep track of the fuel usage
        if Int(playerProgress) > fuelCounter {
            fuelPercent -= 1
            fuelCounter += distancePerPercent
            hud.setOilDisplay(fuelLevel: fuelPercent)
            print(fuelPercent)
        }
        
        if fuelPercent == 0 {
            player.die(reason: .outOfFuel)
            fuelPercent = -1
            smokeEmitter?.emissionAngle = fireEmitter!.emissionAngle
            
            if fireEmitter?.particleBirthRate == 0 {
                smokeEmitter?.particleBirthRate = 0
            }
        }
        
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
                if abs(player.position.x - oilCan.position.x) > 1000 {
                    // Y Position 50 - 450
                    let randomYPos = 50 + CGFloat(arc4random_uniform(400))
                    let randomXOffset = 50 + CGFloat(arc4random_uniform(150))
                    oilCan.position = CGPoint(x: nextEncounterSpawnPosition - randomXOffset, y: randomYPos)
                    // Remove any previous velocity and spin
                    oilCan.physicsBody?.angularVelocity = 0
                    oilCan.physicsBody?.velocity = CGVector.zero
                }
            }
        }
        // Position the backgrounds
        for background in self.backgrounds {
            background.updatePosition(playerProgress: playerProgress)
        }
        // Turn justone into the landing position upon landing
        // If justone is dead, slowly decrease his velocity to 0
        if player.position.y < 100, !player.engineRotating {
            let rotateUp = SKAction.rotate(toAngle: 0, duration: 0.475)
            //player.removeAction(forKey: "flyAnimation")
            player.run(rotateUp)
            
            if (player.health <= 0 || fuelPercent <= 0) , player.forwardVelocity > 0 {
                player.forwardVelocity -= 5
            } else if player.forwardVelocity <= 0 {
                player.forwardVelocity = 0
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
            // Check for HUD buttons
            if nodeTouched.name == "restartGame" {
                // Transition to a new version of the GameScene
                // to restart the game
                player.flySound.stop()
                self.view?.presentScene(GameScene(size: self.size), transition: .crossFade(withDuration: 0.6))
            } else if nodeTouched.name == "returnToMenu" {
                // Transition to the main menu scene
                player.flySound.stop()
                self.view?.presentScene(MenuScene(size: self.size), transition: .crossFade(withDuration: 0.6))
            }
            
        }
        
        player.startFlying(fuelLevel: fuelPercent)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        player.stopFlying(fuelLevel: fuelPercent)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        player.stopFlying(fuelLevel: fuelPercent)
    }
    
    override func update(_ currentTime: TimeInterval) {
        player.update()
        trackPosition()
        
        // If health is low, make flying harder by adding random value dY impulses
        if player.health == 1 {
            let bound: UInt32 = 1000
            addRandomImpulse(bound: bound)
            if Int(fireEmitter!.particleBirthRate) < 450 {
                fireEmitter?.particleBirthRate += 0.3
            }
        }
        if player.health == 0, fireEmitter!.particleBirthRate < 1000 {
            fireEmitter?.particleBirthRate += 0.5
        }
    
        // Unwrap the accelerometer data optional
        if let accelData = self.motionManager.accelerometerData, player.health > 0, fuelPercent > 0 {
            var forceAmount: CGFloat
            
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
            case _ where accelY > 0.0 && accelY < 0.05:
                player.physicsBody?.velocity.dx += forceAmount / 2
            case _ where accelY > 0.05 && accelY < 0.10:
                player.physicsBody?.velocity.dx += forceAmount
            case _ where accelY > 0.10 && accelY < 0.15:
                player.physicsBody?.velocity.dx += forceAmount * 1.5
            case _ where accelY > 0.15 :
                player.physicsBody?.velocity.dx += forceAmount * 2
            default:
                break
            }
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        // Each contact has two bodies
        // Which is which is unknown
        // Find justone's body first, then use the other body
        // to determine the type of contact
        let otherBody: SKPhysicsBody
        
        // Combine the two physics categories into one bitmask
        // using the bitwise OR operator |
        let justoneMask = PhysicsCategory.justone.rawValue | PhysicsCategory.damagedJustone.rawValue
        
        // Use the bitwise AND operator & to find justone
        // This returns a positive number if body A's category
        // is the same as either justone or damagedJustone
        if contact.bodyA.categoryBitMask & justoneMask > 0 {
            // bodyA is justone, test bodyB's type
            otherBody = contact.bodyB
        } else {
            // bodyB is justone, test bodyA's type
            otherBody = contact.bodyA
        }
        
        // Find the type of contact
        switch otherBody.categoryBitMask {
        case PhysicsCategory.ground.rawValue:
            print("hit the ground")
        case PhysicsCategory.trump.rawValue:
            if !player.damaged {
                let trumpEmitter = SKEmitterNode(fileNamed: "HeadEmitter")
                trumpEmitter?.particleTexture = SKTexture(imageNamed: "TrumpClosed")
                enemyEmitter(emitter: trumpEmitter!, location: otherBody)
                
            }
            player.takeDamage(smokeEmitter: self.smokeEmitter, fireEmitter: self.fireEmitter)
            hud.setHealthDisplay(newHealth: player.health)
        case PhysicsCategory.obama.rawValue:
            if !player.damaged {
                let obamaEmitter = SKEmitterNode(fileNamed: "HeadEmitter")
                obamaEmitter?.particleTexture = SKTexture(imageNamed: "Obama")
                enemyEmitter(emitter: obamaEmitter!, location: otherBody)
                
                // Move the node out of sight
                let currentXPos = otherBody.node?.position.x
                let currentYPos = otherBody.node?.position.y
                otherBody.node?.position = CGPoint(x: currentXPos!, y: currentYPos! + 3000)
            }
            player.takeDamage(smokeEmitter: self.smokeEmitter, fireEmitter: self.fireEmitter)
            hud.setHealthDisplay(newHealth: player.health)
        case PhysicsCategory.beer.rawValue:
            // Try to cast the otherBody's node as a Beer
            if let beer = otherBody.node as? Beer {
                // Invoke the collect animation
                beer.collect()
                // Add the value of the coin to our counter:
                self.beersCollected += beer.value
                hud.setBeerCountDisplay(newBeerCount: self.beersCollected)
                print(self.beersCollected)
            }
        case PhysicsCategory.oil.rawValue:
            oilCan.collectOil()
            
            // Fill up the tank
            self.fuelPercent += 25
            
            if self.fuelPercent > 100 {
                self.fuelPercent = 100
            }
            hud.setOilDisplay(fuelLevel: fuelPercent)
        default:
            print("Contact with no game logic")
        }
    }
    
    func addRandomImpulse(bound: UInt32) {
        let direction: Bool
        let randomImpulseValue = CGFloat(arc4random_uniform(bound)) + 2000
        
        if Int(randomImpulseValue) % 2 == 0 {
            direction = true
        } else {
            direction = false
        }
        
        if Int(player.position.x) % 10 == 0 {
            if direction {
                player.physicsBody?.applyImpulse(CGVector(dx: 0, dy: randomImpulseValue))
            } else {
                player.physicsBody?.applyImpulse(CGVector(dx: 0, dy: -randomImpulseValue))
            }
        }
    }
    
    func enemyEmitter(emitter: SKEmitterNode, location: SKPhysicsBody) {
        
        let xCenter = emitter.particleTexture!.textureRect().midX
        let yCenter = emitter.particleTexture!.textureRect().midY
        
        //let xCenter1 = location.node!.position.x
        //let yCenter1 = location.node!.position.y
        
        emitter.particleZPosition = 12
        emitter.position = CGPoint(x: xCenter, y: yCenter)
        location.node!.addChild(emitter)
        emitter.targetNode = self
    }
    
    func gameOver() {
        // Show the menu and restart buttons
        hud.showButtons()
    }
    
    func trackPosition() {
        for encounter in encounterManager.encounters {
            for child in encounter.children {
                
                // For each child with the proper name, we will check the x Position
                // If it is in range of the player, the child will move towards the players current
                // position over a set duration.
                
                let xPos = abs(encounter.position.x + child.position.x - player.position.x)
                if  xPos < 100 && xPos >= 0, child.name == "Obama" {
                    
                    let childAdjustX = child.position.x + encounter.position.x
                    let childAdjustY = child.position.y + encounter.position.y
                    let adjustedX = player.position.x - childAdjustX
                    let adjustedY = player.position.y - childAdjustY
                    let finalX = child.position.x + adjustedX
                    let finalY = child.position.y + adjustedY
                    let moveTo = CGPoint(x: finalX, y: finalY)
                    let launchAction = SKAction.move(to: moveTo, duration: 0.3)
                    
                    child.run(launchAction)
                }
            }
        }
    }
}
