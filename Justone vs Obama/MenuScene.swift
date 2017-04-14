//
//  MenuScene.swift
//  Justone vs Obama
//
//  Created by Richard Melpignano on 4/10/17.
//  Copyright © 2017 J2MFD. All rights reserved.
//

import SpriteKit

class MenuScene: SKScene {
    // Grab the HUD Sprite Atlas
    let textureAtlas: SKTextureAtlas = SKTextureAtlas(named: "HUD")
    // Instantiate a sprite node for the start button
    let startButton = SKSpriteNode()
    
    // Create character sprites
    let justone = Player()
    let obama = Obama()
    let trump = Trump()
    let labatt = Beer()
    let labatt2 = Beer()
    let molson = Beer()
    
    // Time tracker
    var initialTime = TimeInterval()
    var initialTimeLatch = true
    var labatt2AddLatch = true
    
    var node2AngularDistance: CGFloat = 0
    var node3AngularDistance: CGFloat = 0
    var node4AngularDistance: CGFloat = 0
    
    override func didMove(to view: SKView) {
        // Position the nodes from the center of the screen
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        // Add the background
        let backgroundImage = SKSpriteNode(imageNamed: "backgroundMenu")
        backgroundImage.size = CGSize(width: 1024, height: 768)
        backgroundImage.zPosition = -4
        self.addChild(backgroundImage)
        
        // Draw the name of the game
        let logoText = SKLabelNode(fontNamed: "AmericanTypewriter-Bold")
        logoText.text = "455 to Toronto"
        logoText.position = CGPoint(x: 0, y: 100)
        logoText.fontSize = 60
        self.addChild(logoText)
        
        // Add another line below
        let logoTextBottom = SKLabelNode(fontNamed: "AmericanTypewriter")
        logoTextBottom.text = "ft. Justone"
        logoTextBottom.position = CGPoint(x: 0, y: 50)
        logoTextBottom.fontSize = 40
        self.addChild(logoTextBottom)
        
        // Build the start button
        startButton.texture = textureAtlas.textureNamed("button")
        startButton.size = CGSize(width: 295, height: 76)
        // Name the start node for touch detection
        startButton.name = "StartButton"
        startButton.position = CGPoint(x: 0, y: -20)
        self.addChild(startButton)
        
        // Add the text to the start button
        let startText = SKLabelNode(fontNamed: "AvenirNext-HeavyItalic")
        startText.text = "DO IT"
        startText.verticalAlignmentMode = .center
        startText.position = CGPoint(x: 0, y: 2)
        startText.fontSize = 40
        // Name the text node for touch detection
        startText.name = "StartButton"
        startText.zPosition = 5
        startButton.addChild(startText)
        
        // Pulse the start text in and out gently
        let pulseAction = SKAction.sequence([
            SKAction.fadeAlpha(to: 0.5, duration: 0.9),
            SKAction.fadeAlpha(to: 1, duration: 0.9)
            ])
        startText.run(SKAction.repeatForever(pulseAction))
        
        // Add Justone to the background
        let screenWidth = self.size.width
        let screenHeight = self.size.height
        
        justone.position = CGPoint(x: -screenWidth / 2 + 70, y: screenHeight / 2 - 125)
        justone.zPosition = 0
        justone.physicsBody?.affectedByGravity = false
        self.addChild(justone)
        
        // Add a labatt to the background
        labatt.position = CGPoint.zero
        labatt.physicsBody?.affectedByGravity = false
        labatt.zPosition = -1
        labatt.alpha = 0
        self.addChild(labatt)
        
        // Add a second labatt to the background
        labatt2.position = CGPoint.zero
        labatt2.physicsBody?.affectedByGravity = false
        labatt2.zPosition = -2
        labatt2.alpha = 0
        self.addChild(labatt2)
        
        // Add a molson to the background
        molson.turnToMolson()
        molson.position = CGPoint.zero
        molson.physicsBody?.affectedByGravity = false
        molson.zPosition = -3
        molson.alpha = 0
        self.addChild(molson)
        
        floatJustone()
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Save the inital launch time
        if initialTimeLatch {
            initialTime = currentTime
            initialTimeLatch = false
        }
    
        // Delta time
        let dt: CGFloat = 1.0 / 6.0
        // Number of seconds for labatt to complete an orbit
        let period: CGFloat = 30.0
        var period2: CGFloat = 60.0
        var period3: CGFloat = 15.0
        // Point to orbit
        let orbitPosition = justone.position
        // Radius of orbit
        let orbitRadius = CGPoint(x: 100, y: 100)
        
        // Track time since launch
        if currentTime - initialTime > 1.3 {
            let fadeIn = SKAction.fadeAlpha(to: 1.0, duration: 0.5)
            period2 = period
            period3 = period
            molson.run(fadeIn)
            labatt.run(fadeIn)
            labatt2.run(fadeIn)
        }
        
        let normal = CGVector(dx:orbitPosition.x + CGFloat(cos(self.node2AngularDistance))*orbitRadius.x ,dy:orbitPosition.y + CGFloat(sin(self.node2AngularDistance))*orbitRadius.y)
        let normal2 = CGVector(dx:orbitPosition.x + CGFloat(cos(self.node3AngularDistance))*orbitRadius.x ,dy:orbitPosition.y + CGFloat(sin(self.node3AngularDistance))*orbitRadius.y)
        let normal3 = CGVector(dx:orbitPosition.x + CGFloat(cos(self.node4AngularDistance))*orbitRadius.x ,dy:orbitPosition.y + CGFloat(sin(self.node4AngularDistance))*orbitRadius.y)
        
        self.node2AngularDistance += (CGFloat(Double.pi)*2.0)/period*dt
        self.node3AngularDistance += (CGFloat(Double.pi)*2.0)/period2*dt
        self.node4AngularDistance += (CGFloat(Double.pi)*2.0)/period3*dt
        
        
        if (fabs(self.node2AngularDistance)>CGFloat(Double.pi)*2)
        {
            self.node2AngularDistance = 0
        }
        if (fabs(self.node3AngularDistance)>CGFloat(Double.pi)*2)
        {
            self.node3AngularDistance = 0
        }
        if (fabs(self.node4AngularDistance)>CGFloat(Double.pi)*2)
        {
            self.node4AngularDistance = 0
        }
        
        labatt.physicsBody!.velocity = CGVector(dx:(normal.dx - labatt.position.x)/dt ,dy:(normal.dy - labatt.position.y)/dt)
        labatt2.physicsBody!.velocity = CGVector(dx:(normal2.dx - labatt2.position.x)/dt ,dy:(normal2.dy - labatt2.position.y)/dt)
        molson.physicsBody!.velocity = CGVector(dx:(normal3.dx - molson.position.x)/dt ,dy:(normal3.dy - molson.position.y)/dt)
        
        print("labatt2 position: \(labatt2.position) \n labatt position \(labatt.position)")
        print(currentTime)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches{
            // Find the location of the touch
            let location = touch.location(in: self)
            // Locate the node at this location
            let nodeTouched = atPoint(location)
            if nodeTouched.name == "StartButton" {
                // Player touched either text or button node
                // Switch to an instance of GameScene
                self.view?.presentScene(GameScene(size: self.size))
            }
            
        }
    }
    
    func floatJustone() {
        // These points are in reference to when justone is created in the didMove function
        let lowerPosition = CGPoint(x: justone.position.x, y: justone.position.y - 50)
        let topPosition = CGPoint(x: justone.position.x, y: justone.position.y)
        
        let floatDown = SKAction.move(to: lowerPosition, duration: 3)
        let floatUp = SKAction.move(to: topPosition, duration: 3)
        
        floatDown.timingMode = .easeInEaseOut
        floatUp.timingMode = .easeInEaseOut
        
        let floatAction = SKAction.sequence([floatDown, floatUp])
        
        justone.run(SKAction.repeatForever(floatAction))
    }
}
