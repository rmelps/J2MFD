
//
//  Obama.swift
//  Justone vs Obama
//
//  Created by Richard Melpignano on 3/27/17.
//  Copyright © 2017 J2MFD. All rights reserved.
//

import SpriteKit

class Obama: SKSpriteNode, GameSprite {
    
    let obama = SKSpriteNode(imageNamed: "Obama")
    
    
    var initialSize: CGSize = CGSize(width: 10, height: 10)
    var textureAtlas: SKTextureAtlas = SKTextureAtlas(named: "Enemies")
    var flyAnimation = SKAction()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init() {
        initialSize = CGSize(width: obama.size.width / 4, height: obama.size.height / 4)
        
        super.init(texture: nil, color: .clear, size: initialSize)
        
        // Create and run flying animation
        createAnimations()
        self.run(flyAnimation)
        
        // Attach a physics body, shaped like a circle
        self.physicsBody = SKPhysicsBody(circleOfRadius: size.width / 2)
        self.physicsBody?.affectedByGravity = false
    }
    
    func createAnimations() {
        let flyFrames: [SKTexture] = [textureAtlas.textureNamed("Obama"),
                                      textureAtlas.textureNamed("ObamaCompact")]
        let flyAction = SKAction.animate(with: flyFrames, timePerFrame: 0.14)
        flyAnimation = SKAction.repeatForever(flyAction)
    }
    
    func onTap() {
        
    }
}
