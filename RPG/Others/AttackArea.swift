//
//  AttackArea.swift
//  RPG
//
//  Created by Daniel Martinsson on 2018-05-01.
//  Copyright © 2018 Daniel Martinsson. All rights reserved.
//

import Foundation
import SpriteKit

class AttackArea: SKSpriteNode {
    
    func setUp() {
        
        let body:SKPhysicsBody = SKPhysicsBody(circleOfRadius: self.frame.size.width/5, center: CGPoint.zero)
        
        self.physicsBody = body
        body.isDynamic = true
        body.affectedByGravity = false
        body.allowsRotation = false
        
        self.physicsBody?.categoryBitMask = BodyType.attackArea.rawValue
        self.physicsBody?.collisionBitMask = 0
        
        upAndAway()
    }
    
    func upAndAway() {
    
        let grow:SKAction = SKAction.scale(by: 3, duration: 0.5)
        let finish:SKAction = SKAction.run {
            self.removeFromParent()
        }
        
        let seq:SKAction = SKAction.sequence([grow, finish])
        self.run(seq)

    }
     
}
