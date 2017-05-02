//
//  HUD.swift
//  Justone vs Obama
//
//  Created by Richard Melpignano on 4/5/17.
//  Copyright © 2017 J2MFD. All rights reserved.
//

import SpriteKit

class HUD: SKNode {
    let labatt = SKSpriteNode(imageNamed: "labatt")
    
    // Buttons
    let restartButton = SKSpriteNode()
    let menuButton = SKSpriteNode()
    
    // Sound & Music nodes
    var soundNode = SKSpriteNode()
    var musicNode = SKSpriteNode()
    
    // Health related parameters
    let healthCropNode = SKCropNode()
    let healthBarSize = CGSize(width: 300, height: 5)
    
    // Oil related parameters
    let oilCropNode = SKCropNode()
    let oilBarSize = CGSize(width: 300, height: 5)
    
    var textureAtlas = SKTextureAtlas(named: "HUD")
    var beerAtlas = SKTextureAtlas(named: "Environment")
    
    // An SKLabelNode to print the score
    let beerCountText = SKLabelNode(text: "000000")
    let distanceCountText = SKLabelNode(text: "0")
    
    func createHudNodes(screenSize: CGSize) {
        let cameraOrigin = CGPoint(x: screenSize.width / 2, y: screenSize.height / 2)
        
        // Create the beer counter
        // First create a beer icon
        let beerIcon = SKSpriteNode(texture: beerAtlas.textureNamed("labatt"))
        
        // Size and position the beer icon
        let beerPosition = CGPoint(x: -cameraOrigin.x + 23, y: cameraOrigin.y - 23)
        beerIcon.size = CGSize(width: labatt.size.width / 4, height: labatt.size.height / 4)
        beerIcon.position = beerPosition
        
        // Configure the beer text label
        beerCountText.fontName = "AmericanTypewriter"
        let beerTextPosition = CGPoint(x: -cameraOrigin.x + 41, y: beerPosition.y)
        beerCountText.position = beerTextPosition
        
        // These properties allow alignment of the text relative to the SKLabelNode's position
        beerCountText.horizontalAlignmentMode = .left
        beerCountText.verticalAlignmentMode = .center
        
        // Add text label and beer icon to HUD
        self.addChild(beerCountText)
        self.addChild(beerIcon)
        
        // Create sound a music nodes
        let currentViewController: UIViewController = UIApplication.shared.keyWindow!.rootViewController!
        let gameViewContrller = currentViewController as! GameViewController
        
        if gameViewContrller.isSoundOn {
            soundNode = SKSpriteNode(texture: self.textureAtlas.textureNamed("sound_on"))
        } else {
            soundNode = SKSpriteNode(texture: self.textureAtlas.textureNamed("sound_off"))
        }
        if gameViewContrller.isMusicOn {
            musicNode = SKSpriteNode(texture: self.textureAtlas.textureNamed("music_on"))
        } else {
            musicNode = SKSpriteNode(texture: self.textureAtlas.textureNamed("music_off"))
        }
        musicNode.name = "musicButton"
        soundNode.name = "soundButton"
        
        soundNode.position = CGPoint(x: cameraOrigin.x - 23, y: cameraOrigin.y - 23)
        musicNode.position = CGPoint(x: soundNode.position.x - 45, y: soundNode.position.y)
        self.addChild(soundNode)
        self.addChild(musicNode)
        
        // Create one Cross node
        let crossNode = SKSpriteNode(texture: self.textureAtlas.textureNamed("red_cross_outline"))
        let crossWidth = crossNode.size.width / 10
        let crossHeight = crossNode.size.height / 10
        crossNode.size = CGSize(width: crossWidth , height: crossHeight)
        
        // Position Cross Node under beer bottle
        crossNode.position = CGPoint(x: beerPosition.x , y: beerPosition.y - (beerIcon.size.height / 2) - 20)
        self.addChild(crossNode)
        
        // Create Progress Bar for Health
        let barPosition = CGPoint(x: crossNode.position.x + (crossNode.size.width / 2) + 3, y: crossNode.position.y)
        let barNode = SKSpriteNode(texture: nil, color: .red, size: healthBarSize)
        barNode.anchorPoint = CGPoint(x: 0, y: 0.5)
        barNode.position = CGPoint.zero
        
        // Configure Health Crop Node
        healthCropNode.position = barPosition
        healthCropNode.zPosition = 1
        healthCropNode.maskNode = SKSpriteNode(texture: nil, color: .black, size: healthBarSize)
        
        // Add bar to crop node, and crop node to HUD
        healthCropNode.addChild(barNode)
        self.addChild(healthCropNode)
        
        // Create an Oil drop node
        let oilDropNode = SKSpriteNode(texture: self.textureAtlas.textureNamed("water_drop-512"))
        let oilDropWidth = oilDropNode.size.width / 10
        let oilDropHeight = oilDropNode.size.height / 10
        oilDropNode.size = CGSize(width: oilDropWidth, height: oilDropHeight)
        
        // Position oil drop underneath the Cross Node
        oilDropNode.position = CGPoint(x: crossNode.position.x, y: crossNode.position.y - (crossNode.size.height / 2) - 20)
        self.addChild(oilDropNode)
        
        // Create a Progress Bar for Oil
        let oilBarPosition = CGPoint(x: oilDropNode.position.x + (oilDropNode.size.width / 2) + 3, y: oilDropNode.position.y)
        let oilBarNode = SKSpriteNode(texture: nil, color: .black, size: oilBarSize)
        oilBarNode.anchorPoint = CGPoint(x: 0, y: 0.5)
        oilBarNode.position = CGPoint.zero
        
        // Configure Oil Crop Node
        oilCropNode.position = oilBarPosition
        oilCropNode.zPosition = 1
        oilCropNode.maskNode = SKSpriteNode(texture: nil, color: .black, size: oilBarSize)
        
        // Add bar to crop node, and crop node to HUD
        oilCropNode.addChild(oilBarNode)
        self.addChild(oilCropNode)
        
        // Create Distance Counter
        distanceCountText.fontName = "AmericanTypewriter-Bold"
        distanceCountText.fontColor = .black
        distanceCountText.fontSize = 60
        distanceCountText.setScale(0.5)
        distanceCountText.position = CGPoint(x: cameraOrigin.x - 23, y: -cameraOrigin.y + 23)
        distanceCountText.verticalAlignmentMode = .bottom
        distanceCountText.horizontalAlignmentMode = .right
        self.addChild(distanceCountText)
        
        // Add the restart and menu button textures to the nodes
        restartButton.texture = textureAtlas.textureNamed("button-restart")
        menuButton.texture = textureAtlas.textureNamed("button-menu")
        // Assign node names to the buttons
        restartButton.name = "restartGame"
        menuButton.name = "returnToMenu"
        menuButton.position = CGPoint(x: -140, y: 0)
        // Size the button nodes
        restartButton.size = CGSize(width: 140, height: 140)
        menuButton.size = CGSize(width: 70, height: 70)
        
    }
    
    func setBeerCountDisplay(newBeerCount: Int) {
        // Use NSNumberFormatter to pad leading 0's
        let formatter = NumberFormatter()
        let number = NSNumber(value: newBeerCount)
        formatter.minimumIntegerDigits = 6
        if let beerStr = formatter.string(from: number) {
            beerCountText.text = beerStr
        }
    }
    
    func setHealthDisplay(newHealth: Int) {
        let newWidth = CGFloat(newHealth * 100)
        let newBarSize = CGSize(width: newWidth , height: healthBarSize.height)
        print(newHealth)
        
        guard newWidth >= 0 else {
            return
        }
        healthCropNode.maskNode = SKSpriteNode(texture: nil, color: .black, size: newBarSize)
    }
    
    func setOilDisplay(fuelLevel: Int) {
        let newWidth = CGFloat(fuelLevel * 3)
        let newBarSize = CGSize(width: newWidth, height: oilBarSize.height)
        
        guard newWidth >= 0 else {
            return
        }
        oilCropNode.maskNode = SKSpriteNode(texture: nil, color: .black, size: newBarSize)
    }
    
    func setDistanceDisplay(distance: Int) {
        distanceCountText.text = "\(distance)"
        let grow = SKAction.scale(to: 1.5, duration: 3)
        let shrink = SKAction.scale(to: 0.5, duration: 0.5)
        let pulseAction = SKAction.sequence([grow, shrink])
        distanceCountText.run(pulseAction)
    }
    
    func showButtons() {
        // Set the button alpha to 0
        restartButton.alpha = 0
        menuButton.alpha = 0
        // Add the button nodes to the HUD
        self.addChild(restartButton)
        self.addChild(menuButton)
        // Fade in the buttons
        let fadeAnimation = SKAction.fadeAlpha(to: 1, duration: 0.4)
        restartButton.run(fadeAnimation)
        menuButton.run(fadeAnimation)
    }
}
