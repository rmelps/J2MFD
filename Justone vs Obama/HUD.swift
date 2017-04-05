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
}
