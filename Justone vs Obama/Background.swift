//
//  Background.swift
//  Justone vs Obama
//
//  Created by Richard Melpignano on 4/5/17.
//  Copyright © 2017 J2MFD. All rights reserved.
//

import SpriteKit

class Background: SKSpriteNode {
    // movement multiplier will store a float from 0-1 to indicate
    // how fast the background should move past
    // 0 is full adjustment, no movement as the world goes past
    // 1 is no adjustment, background passes at normal speed
    var movementMultiplier: CGFloat = 0
    
    // jumpAdjustment will store how many points of x position
    // this background has jumped forward, useful for calculating future seamless
    // jump points
    var jumpAdjustment: CGFloat = 0
    
    // A constant for background node size
    let backgroundSize
}
