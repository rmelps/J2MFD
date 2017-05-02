//
//  Beer.swift
//  Justone vs Obama
//
//  Created by Richard Melpignano on 3/31/17.
//  Copyright © 2017 J2MFD. All rights reserved.
//

import SpriteKit

class Beer: SKSpriteNode, GameSprite {
    
    let molson = SKSpriteNode(imageNamed: "molson")
    let labatt = SKSpriteNode(imageNamed: "labatt")
    
    var initialSize = CGSize()
    var textureAtlas: SKTextureAtlas = SKTextureAtlas(named: "Environment")
    var value = 1
    
    let beerSound = SKAction.playSoundFileNamed("Sound/SFX_Pickup_20.wav", waitForCompletion: false)
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init() {
        initialSize = CGSize(width: labatt.size.width / 4, height: labatt.size.height / 4)
        
        let labattTexture = textureAtlas.textureNamed("labatt")
        super.init(texture: labattTexture, color: .clear, size: initialSize)
        
        let rectSize = CGSize(width: labatt.size.width / 10, height: labatt.size.height / 6)
        self.physicsBody = SKPhysicsBody(rectangleOf: rectSize)
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.categoryBitMask = PhysicsCategory.beer.rawValue
        self.physicsBody?.collisionBitMask = 0
    }
    
    // A function to turn a labatt blue into a molson
    func turnToMolson() {
        self.texture = textureAtlas.textureNamed("molson")
        self.value = 5
    }
    
    func collect(withSound: Bool) {
        // Prevent further contact:
        self.physicsBody?.categoryBitMask = 0
        
        // Fade out, move up, and scale up the coin
        let collectAnimation = SKAction.group([
            SKAction.fadeAlpha(to: 0, duration: 0.2),
            SKAction.scale(to: 1.5, duration: 0.2),
            SKAction.move(by: CGVector(dx: 0, dy: 25), duration: 0.2)
            ])
        // Move beer out of the way and reset to initial values for eventual reuse
        let resetAfterCollected = SKAction.run{
            self.position.y = 5000
            self.alpha = 1
            self.xScale = 1
            self.yScale = 1
            self.physicsBody?.categoryBitMask = PhysicsCategory.beer.rawValue
        }
        
        // Combine the actions into a sequence
        let collectSequence = SKAction.sequence([
            collectAnimation,
            resetAfterCollected
            ])
        
        // Run the collect sequence
        self.run(collectSequence)
        
        if withSound {
            // Play the beer sound
            self.run(beerSound)
        }
    }
    
    func onTap() {
    }
}
