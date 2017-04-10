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
    
    override func didMove(to view: SKView) {
        // Position the nodes from the center of the screen
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        // Add the background
        let backgroundImage = SKSpriteNode(imageNamed: "backgroundMenu")
        backgroundImage.size = CGSize(width: 1024, height: 768)
        backgroundImage.zPosition = -1
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
}
