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
    }
    
    // A function to turn a labatt blue into a molson
    func turnToMolson() {
        self.texture = textureAtlas.textureNamed("molson")
        self.value = 5
    }
    
    func onTap() {
    }
}
