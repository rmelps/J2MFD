//
//  Ground.swift
//  Justone vs Obama
//
//  Created by Richard Melpignano on 3/27/17.
//  Copyright © 2017 J2MFD. All rights reserved.
//

import SpriteKit

class Ground: SKSpriteNode, GameSprite {
    
    var textureAtlas: SKTextureAtlas = SKTextureAtlas(named: "Environment")
    var initialSize: CGSize = CGSize.zero
    var jumpWidth = CGFloat()
    var jumpCount: CGFloat = 1
    
    // This function tiles the ground texture across the width of the Ground Node
    // We will call it from the GameScene
    func createChildren() {
        self.anchorPoint = CGPoint(x: 0, y: 1)
        
        // First load the ground texture from the atlas
        let texture = textureAtlas.textureNamed("ground")
        
        var tileCount: CGFloat = 0
        let tileSize = CGSize(width: 35, height: 300)
        
        // Build nodes until we cover the entire Ground width
        while tileCount * tileSize.width < self.size.width {
            let tileNode = SKSpriteNode(texture: texture)
            tileNode.size = tileSize
            tileNode.position.x = tileCount * tileSize.width
            
            //Position child nodes by their upper left corner
            tileNode.anchorPoint = CGPoint(x: 0, y: 1)
            // Add the child texture to the ground node:
            self.addChild(tileNode)
            
            tileCount += 1
        }
        
        let pointTopLeft = CGPoint(x: 0, y: 0)
        let pointTopRight = CGPoint(x: size.width, y: 0)
        self.physicsBody = SKPhysicsBody(edgeFrom: pointTopLeft, to: pointTopRight)
        
        // Save the width of the one-third of the children nodes
        jumpWidth = tileSize.width * floor(tileCount / 3)
    }
    
    func checkForReposition(playerprogress: CGFloat) {
        // The ground needs to jump forward
        // every time the player has moved this distance
        let groundJumpPosition = jumpWidth * jumpCount
        
        if playerprogress >= groundJumpPosition {
            // The player has moved past the jump position
            // Move the ground forward
            self.position.x += jumpWidth
            
            // Add one to the jump count
            jumpCount += 1
        }
    }
    
    func onTap() {
        
    }
}
