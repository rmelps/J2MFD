//
//  GameSprite.swift
//  Justone vs Obama
//
//  Created by Richard Melpignano on 3/27/17.
//  Copyright © 2017 J2MFD. All rights reserved.
//

import SpriteKit

protocol GameSprite {
    var textureAtlas: SKTextureAtlas { get set }
    var initialSize: CGSize { get set }
    func onTap()
}
