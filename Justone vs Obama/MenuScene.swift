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
    
    // Add cloud emitter
    let cloudEmitter = SKEmitterNode(fileNamed: "Cloud")
    
    // Create character sprites
    let justone = Player()
    let obama = Obama()
    let trump = Trump()
    let labatt = Beer()
    let labatt2 = Beer()
    let molson = Beer()
    let molson2 = Beer()
    
    // Create Bezierpath
    let obamaPath = UIBezierPath()
    let trumpPath = UIBezierPath()
    var trumpStartPoint = CGPoint()
    var obamaStartPoint = CGPoint()
    
    
    // Time tracker
    var initialTime = TimeInterval()
    var initialTimeLatch = true
    var currentTimeMultiplier: Int = 1
    
    var node2AngularDistance: CGFloat = 0
    var node3AngularDistance: CGFloat = 0
    var node4AngularDistance: CGFloat = 0
    var node5AngularDistance: CGFloat = 0
    
    // Orbiter
    var orbitingBeers = [Beer]()
    var currentOrbitingBeerIndex = Int()
    var period = CGFloat()
    var periodFast1 = CGFloat()
    var periodFast2 = CGFloat()
    var periodFast3 = CGFloat()
    var periodFast4 = CGFloat()
    
    override func didMove(to view: SKView) {
        // Position the nodes from the center of the screen
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        // Add the background
        self.backgroundColor = UIColor(red: 0.4, green: 0.6, blue: 0.95, alpha: 1.0)
        let backgroundImage = SKSpriteNode(imageNamed: "backgroundMenu")
        backgroundImage.size = CGSize(width: 919, height: 300)
        backgroundImage.anchorPoint = CGPoint(x: 0, y: 0)
        backgroundImage.position = CGPoint(x: -self.size.width / 2, y: -self.size.height / 2 - 50)
        backgroundImage.zPosition = -10
        self.addChild(backgroundImage)
        
        // Set Orbiter values
        initialTime = TimeInterval()
        currentOrbitingBeerIndex = 0
        period = 4.1
        periodFast1 = 1.0
        periodFast2 = 1.0
        periodFast3 = 1.0
        periodFast4 = 1.0
        
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
        justone.zPosition = 1
        justone.physicsBody?.affectedByGravity = false
        self.addChild(justone)
        
        // Add cloud emitter
        cloudEmitter?.position = CGPoint(x: 0.0, y: screenHeight / 2 + 10)
        self.addChild(cloudEmitter!)
        
        // Add a labatt to the background
        labatt.position = CGPoint.zero
        labatt.physicsBody?.affectedByGravity = false
        labatt.zPosition = -1
        labatt.alpha = 0
        orbitingBeers.append(labatt)
        self.addChild(labatt)
        
        // Add a molson to the background
        molson.turnToMolson()
        molson.position = CGPoint.zero
        molson.physicsBody?.affectedByGravity = false
        molson.zPosition = -3
        molson.alpha = 0
        orbitingBeers.append(molson)
        self.addChild(molson)
        
        // Add a second labatt to the background
        labatt2.position = CGPoint.zero
        labatt2.physicsBody?.affectedByGravity = false
        labatt2.zPosition = -2
        labatt2.alpha = 0
        orbitingBeers.append(labatt2)
        self.addChild(labatt2)
        
        // Add a second molson to the background
        molson2.turnToMolson()
        molson2.position = CGPoint.zero
        molson2.physicsBody?.affectedByGravity = false
        molson2.zPosition = -4
        molson2.alpha = 0
        orbitingBeers.append(molson2)
        self.addChild(molson2)
        
        // Add obama to the scene
        obamaStartPoint = CGPoint(x: screenWidth / 2 + 10, y: 100.0)
        obamaPath.move(to: CGPoint.zero)
        obama.physicsBody = nil
        obamaPath.addQuadCurve(to: CGPoint(x: -100, y: 0.0) , controlPoint: CGPoint(x: -50, y: 200.0))
        let path1 = SKAction.follow(obamaPath.cgPath, speed: 100)
        obama.position = obamaStartPoint
        obama.zPosition = -6
        self.addChild(obama)
        obama.run(SKAction.repeatForever(path1))
        
        // Add trump to the scene
        trumpStartPoint = CGPoint(x: screenWidth / 2 + 100, y: -100.0)
        trumpPath.move(to: CGPoint.zero)
        trump.physicsBody = nil
        trumpPath.addQuadCurve(to: CGPoint(x: -200, y: 0.0), controlPoint: CGPoint(x: -100, y: 200.0))
        let path2 = SKAction.follow(trumpPath.cgPath, speed: 50)
        trump.position = trumpStartPoint
        trump.zPosition = -6
        self.addChild(trump)
        trump.run(SKAction.repeatForever(path2))
        
        
        floatJustone()
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Save the inital launch time
        if initialTimeLatch {
            initialTime = currentTime
            initialTimeLatch = false
        }
        
        if trump.position.x < -self.size.width / 2 - 40 {
            trump.position = trumpStartPoint
        }
        if obama.position.x < -self.size.width / 2 - 40 {
            obama.position = obamaStartPoint
        }
        
        let orbitRadius = CGPoint(x: 100, y: 100)
        let orbitRadius2 = CGPoint(x: 100, y: 100)
        let orbitRadius3 = CGPoint(x: 100, y: 100)
        
        let timeSinceLaunch = CGFloat(currentTime - initialTime)
        
        if timeSinceLaunch >= period / CGFloat(orbitingBeers.count) * CGFloat(currentTimeMultiplier) {
            if currentOrbitingBeerIndex <= orbitingBeers.count - 1 {
                orbitingBeers[currentOrbitingBeerIndex].run(SKAction.fadeAlpha(to: 1, duration: 1))
            
                switch currentOrbitingBeerIndex {
                case 0:
                    periodFast4 = period
                case 1:
                    periodFast1 = period
                case 2:
                    periodFast2 = period
                case 3:
                    periodFast3 = period
                default:
                    print("no item here")
                }
                currentOrbitingBeerIndex += 1
                currentTimeMultiplier += 1
            }
        }
 
        
        createOrbit(object: labatt, period: periodFast4, orbitPosition: justone.position, orbitRadius: orbitRadius, angularDistance: &node2AngularDistance)
        createOrbit(object: labatt2, period: periodFast2, orbitPosition: justone.position, orbitRadius:orbitRadius2, angularDistance: &node3AngularDistance)
        createOrbit(object: molson, period: periodFast1, orbitPosition: justone.position, orbitRadius: orbitRadius3, angularDistance: &node4AngularDistance)
        createOrbit(object: molson2, period: periodFast3, orbitPosition: justone.position, orbitRadius: orbitRadius3, angularDistance: &node5AngularDistance)
        
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
                let gameScene = GameScene(size: self.size)
                self.view?.presentScene(gameScene)
                
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
    
    func createOrbit(object: SKSpriteNode, period: CGFloat, orbitPosition: CGPoint, orbitRadius: CGPoint, angularDistance: inout CGFloat) {
        let dt: CGFloat = 1.0 / 60.0
        
        let normal = CGVector(dx:orbitPosition.x + CGFloat(cos(angularDistance))*orbitRadius.x ,dy:orbitPosition.y + CGFloat(sin(angularDistance))*orbitRadius.y)
        angularDistance += (CGFloat(Double.pi)*2.0)/period*dt
        
        if (fabs(angularDistance)>CGFloat(Double.pi)*2)
        {
            angularDistance = 0
        }
        object.physicsBody!.velocity = CGVector(dx:(normal.dx - object.position.x)/dt ,dy:(normal.dy - object.position.y)/dt)
    }
}
