//
//  Star.swift
//  Justone vs Obama
//
//  Created by Richard Melpignano on 3/31/17.
//  Copyright © 2017 J2MFD. All rights reserved.
//

import SpriteKit

class Oil: SKSpriteNode, GameSprite {
    
    let oilDrum = SKSpriteNode(imageNamed: "oilDrum")
    
    var initialSize = CGSize()
    var textureAtlas: SKTextureAtlas = SKTextureAtlas(named: "Environment")
    var pulseAnimation = SKAction()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init() {
        
        let oilTexture = textureAtlas.textureNamed("oilDrum")
        
        initialSize = CGSize(width: oilDrum.size.width / 2 , height: oilDrum.size.width / 2)
        
        super.init(texture: oilTexture, color: .clear, size: initialSize)
        
        // Assign a physics body
        self.physicsBody = SKPhysicsBody(circleOfRadius: size.width / 3)
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.categoryBitMask = PhysicsCategory.oil.rawValue
        
        // Create our oil animation and start it
        createAnimations()
        self.run(pulseAnimation)
        
    }
    
    func createAnimations() {
        
        // Scale the oil smaller and fade it slightly
        let pulseOutGroup = SKAction.group([
            SKAction.fadeAlpha(to: 0.85, duration: 0.8),
            SKAction.scale(to: 0.6, duration: 0.8),
            SKAction.rotate(byAngle: -0.3, duration: 0.8),
            ])
        // Push the oil big again and fade it back in
        let pulseInGroup = SKAction.group([
            SKAction.fadeAlpha(to: 1, duration: 1.5),
            SKAction.scale(to: 1, duration: 1.5),
            SKAction.rotate(byAngle: 3.5, duration: 1.5),
            ])
        // Combine the two in a sequence
        let pulseSequence = SKAction.sequence([
            pulseOutGroup,
            pulseInGroup
            ])
        // Set pulseAnimation to run forever
        pulseAnimation = SKAction.repeatForever(pulseSequence)
    }
    
    func onTap() {
    }
}
