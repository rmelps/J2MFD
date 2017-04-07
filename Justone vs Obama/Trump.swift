//
//  MadFly.swift
//  Justone vs Obama
//
//  Created by Richard Melpignano on 3/31/17.
//  Copyright © 2017 J2MFD. All rights reserved.
//

import SpriteKit

class Trump: SKSpriteNode, GameSprite {
    
    let trump = SKSpriteNode(imageNamed: "trumpOpen")
    
    var initialSize = CGSize()
    var textureAtlas: SKTextureAtlas = SKTextureAtlas(named: "Enemies")
    var trumpAnimation = SKAction()
    let trumpEmitter = SKEmitterNode(fileNamed: "HeadEmitter")
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init() {
        initialSize = CGSize(width: trump.size.width / 2, height: trump.size.height / 2)
        
        super.init(texture: nil, color: .clear, size: initialSize)
        self.physicsBody = SKPhysicsBody(circleOfRadius: size.width / 3)
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.categoryBitMask = PhysicsCategory.trump.rawValue
        self.physicsBody?.collisionBitMask = ~PhysicsCategory.damagedJustone.rawValue & ~PhysicsCategory.beer.rawValue
        createAnimations()
        self.run(trumpAnimation)
    }
    
    func createAnimations() {
        
        let flyFrames: [SKTexture] = [
            textureAtlas.textureNamed("trumpOpen"),
            textureAtlas.textureNamed("trumpClosed")
        ]
        
        let trumpAction = SKAction.animate(with: flyFrames, timePerFrame: 0.14)
        
        trumpAnimation = SKAction.repeatForever(trumpAction)
    }
    
    func onTap() {
    }
}
