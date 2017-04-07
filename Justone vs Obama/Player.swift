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
    
    // The player will be able to take 3 hits before the game is over
    var health: Int = 3
    
    // Keep track of when the player is newly damaged
    var damaged = false
    // Properties to store animations when the player takes damage or dies
    var damageAnimation = SKAction()
    var dieAnimation = SKAction()
    var outOfFuelAnimation = SKAction()
    
    // Stop forward velocity if the player dies, so store it as a property
    var forwardVelocity: CGFloat = 350
    
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
        
        self.physicsBody?.categoryBitMask = PhysicsCategory.justone.rawValue
        self.physicsBody?.contactTestBitMask = PhysicsCategory.enemy.rawValue | PhysicsCategory.ground.rawValue | PhysicsCategory.oil.rawValue | PhysicsCategory.beer.rawValue
        self.physicsBody?.collisionBitMask = PhysicsCategory.ground.rawValue
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
       self.physicsBody?.velocity.dx = self.forwardVelocity
        
    }
    
    func createAnimations() {
        let rotateUpAction = SKAction.rotate(toAngle: 0, duration: 0.475)
        rotateUpAction.timingMode = .easeOut
        
        let rotateDownAction = SKAction.rotate(toAngle: -1, duration: 3)
        rotateDownAction.timingMode = .easeIn
        
        // *******Create the flying animation*******
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
        
        // ******Create the soaring animation*******
        // just one frame for now
        var soarActions = [SKAction]()
        var timeFrame = 0.03
        
        let soarFrames: [SKTexture] = [
                textureAtlas.textureNamed("justonesPlanePropUp"),
                textureAtlas.textureNamed("justonesPlanePropSide")
            ]
        
        // Create an engine slowing-down effect by slowly decreasing timePerFrame
        for _ in 0...500 {
        let soarAction = SKAction.animate(with: soarFrames, timePerFrame: timeFrame)
            
            soarActions.append(soarAction)
            timeFrame += 0.01
            
        }
        //Group the soaring animation with the rotation down
        let soarSequence = SKAction.sequence(soarActions)
        
        soarAnimation = SKAction.group([
            soarSequence,
            rotateDownAction
        ])
        
        // ******Create the taking damage animation******
        let damageStart = SKAction.run {
            // Allow justone to pass thru enemies
            self.physicsBody?.categoryBitMask = PhysicsCategory.damagedJustone.rawValue
        }
        
        // Create an opacity pulse, slow at first fast at the end
        let slowFade = SKAction.sequence([
            SKAction.fadeAlpha(to: 0.3, duration: 0.35),
            SKAction.fadeAlpha(to: 0.7, duration: 0.35)
            ])
        let fastFade = SKAction.sequence([
            SKAction.fadeAlpha(to: 0.3, duration: 0.2),
            SKAction.fadeAlpha(to: 0.7, duration: 0.2)
            ])
        let fadeOutAndIn = SKAction.sequence([
            SKAction.repeat(slowFade, count: 2),
            SKAction.repeat(fastFade, count: 5),
            SKAction.fadeAlpha(to: 1, duration: 0.15)
            ])
        
        // Return justone to normal
        let damageEnd = SKAction.run {
            self.physicsBody?.categoryBitMask = PhysicsCategory.justone.rawValue
            
            // Turn off the damaged indicator
            self.damaged = false
        }
        
        // Store the whole sequence in the damageAnimation property:
        self.damageAnimation = SKAction.sequence([
            damageStart,
            fadeOutAndIn,
            damageEnd
            ])
        
        // *******Create the die animation*******
        self.dieAnimation = SKAction.colorize(with: .red, colorBlendFactor: 0.7, duration: 1.0)
        
        // ******* Create the out of fuel animation *******
        self.outOfFuelAnimation = SKAction.colorize(with: .black, colorBlendFactor: 0.5, duration: 1.0)
    }
    
    func onTap() {
        
    }
    
    func startFlying(fuelLevel: Int) {
        if self.health <= 0 || fuelLevel <= 0 {
            return
        }
        self.removeAction(forKey: "soarAnimation")
        self.run(flyAnimation, withKey: "flyAnimation")
        self.engineRotating = true
    }
    
    func stopFlying(fuelLevel: Int) {
        if self.health <= 0 || fuelLevel <= 0 {
            return
        }
        self.removeAction(forKey: "flyAnimation")
        self.run(soarAnimation, withKey: "soarAnimation")
        self.engineRotating = false
    }
    
    func takeDamage(smokeEmitter: SKEmitterNode?, fireEmitter: SKEmitterNode?) {
        // If invulnerable or damaged, return:
        if self.damaged {
            return
        }
        // Set the damaged indicator to true after being hit
        self.damaged = true
        
        // Remove one from the health pool
        self.health -= 1
        
        var smokeColor = UIColor()
        switch self.health {
        case 0:
            smokeColor = UIColor(white: 0, alpha: 1.0)
            smokeEmitter?.xAcceleration = -50
            smokeEmitter?.yAcceleration = 0
        case 1:
            smokeColor = UIColor(white: 0, alpha: 0.9)
            smokeEmitter?.particlePositionRange.dx = 25
            //fireEmitter?.particleBirthRate = 500
            smokeEmitter?.particleBirthRate += 100
        case 2:
            smokeColor = UIColor(white: 0, alpha: 0.7)
            smokeEmitter?.alpha += 0.5
            smokeEmitter?.particleBirthRate += 50
        default:
            return
        }
        smokeEmitter?.particleColorSequence = nil
        smokeEmitter?.particleColorBlendFactor = 1
        smokeEmitter?.particleColor = smokeColor
        
        smokeEmitter?.particleSize = CGSize(width: smokeEmitter!.particleSize.width + 10, height: smokeEmitter!.particleSize.height + 10)
        
        if self.health == 0 {
            // If out of health, run the die function
            die(reason: .outOfHealth)
        } else {
            // Run the take damage animation
            self.run(self.damageAnimation)
        }
    }
    
    func die(reason: GameOver) {
        // Make sure the player is fully visible
        self.alpha = 1
        // Remove all animations
        self.removeAllActions()
        // Run the die animation
        
        switch reason {
        case .outOfFuel:
            self.run(outOfFuelAnimation)
        case .outOfHealth:
            self.run(dieAnimation)
        }
        // prevent any further upward movement
        self.engineRotating = false
    }
}
