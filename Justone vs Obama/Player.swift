//
//  Player.swift
//  Justone vs Obama
//
//  Created by Richard Melpignano on 3/27/17.
//  Copyright © 2017 J2MFD. All rights reserved.
//

import SpriteKit

class Player: SKSpriteNode, GameSprite {
    
    let justone = SKSpriteNode(imageNamed: "justonesPlanePropUp")
    
    var initialSize: CGSize = CGSize.zero
    var textureAtlas: SKTextureAtlas = SKTextureAtlas(named: "Justone")
    
    // Store whether plane engine is going or not
    var engineRotating = false
    
    // Set maximum upward force
    let maxUpwardForce: CGFloat = 60000
    
    // Set a maximum height
    let maxHeight: CGFloat = 1000
    
    var flyAnimation = SKAction()
    var soarAnimation = SKAction()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init() {
        initialSize = CGSize(width: justone.size.width / 2, height: justone.size.height / 2)
        super.init(texture: nil, color: .clear, size: initialSize)
        
        createAnimations()
        
        // If we run an action with key, "soarAnimation",
        // we can later reference that key to remove the action
        self.run(flyAnimation, withKey: "flyAnimation")
        
        // Create a physics body based on one Frame of Justone's animation.
        // We will use the frame where the propeller is up
        let bodyTexture = textureAtlas.textureNamed("justonesPlanePropUp")
        self.physicsBody = SKPhysicsBody(texture: bodyTexture, size: self.size)
        
        // Justone will lose momentum quickly with a high linearDamping
        self.physicsBody?.linearDamping = 0.9
        
        // Give him a mass of 30 kg
        self.physicsBody?.mass = 30
        
        //Prevent Justone from rotating
        self.physicsBody?.allowsRotation = false
    }
    
    func update() {
        
        // If rising, apply a new force to push Justone higher.
        if self.engineRotating {
            var forceToApply = maxUpwardForce
            
            // Apply less force if Justone is above position 300
            if position.y > (maxHeight / 2) {
                
                let percentageOfMaxHeight = position.y / maxHeight
                let flappingForceSubtraction = percentageOfMaxHeight * maxUpwardForce
                
                forceToApply -= flappingForceSubtraction
            }
            
            // Apply the final force
            self.physicsBody?.applyForce(CGVector(dx: 0, dy: forceToApply))
        }
        
        // Limit speed while climbing y axis to prevent over shooting maximim height
        if self.physicsBody!.velocity.dy > 300 {
            self.physicsBody!.velocity.dy = 300
        }
        
        // Set a constant velocity to the right
        self.physicsBody?.velocity.dx = 200
        
    }
    
    func createAnimations() {
        let rotateUpAction = SKAction.rotate(toAngle: 0, duration: 0.475)
        rotateUpAction.timingMode = .easeOut
        
        let rotateDownAction = SKAction.rotate(toAngle: -1, duration: 0.8)
        rotateDownAction.timingMode = .easeIn
        
        // Create the flying animation:
        let flyFrames: [SKTexture] = [
            textureAtlas.textureNamed("justonesPlanePropUp"),
            textureAtlas.textureNamed("justonesPlanePropSide")
        ]
        let flyAction = SKAction.animate(with: flyFrames, timePerFrame: 0.03)
        
        // Group together the flying animation with rotation
        flyAnimation = SKAction.group([
            SKAction.repeatForever(flyAction),
            rotateUpAction
        ])
        
        // Create the soaring animation
        // just one frame for now
        let soarFrames: [SKTexture] = [textureAtlas.textureNamed("justonesPlanePropSide")]
        let soarAction = SKAction.animate(with: soarFrames, timePerFrame: 1)
        
        //Group the soaring animation with the rotation down
        soarAnimation = SKAction.group([
            SKAction.repeatForever(soarAction),
            rotateDownAction
        ])
    }
    
    func onTap() {
        
    }
    
    func startFlying() {
        self.removeAllActions()
        self.run(flyAnimation, withKey: "flyAnimation")
        self.engineRotating = true
    }
    
    func stopFlying() {
        self.removeAction(forKey: "flyAnimation")
        self.run(soarAnimation, withKey: "soarAnimation")
        self.engineRotating = false
    }
}
