//
//  GameScenePlayer.swift
//  RPG
//
//  Created by Daniel Martinsson on 2018-05-01.
//  Copyright © 2018 Daniel Martinsson. All rights reserved.
//

import Foundation
import SpriteKit

extension GameScene {
    
    func move(theXAmount:CGFloat, theYAmount:CGFloat, theAnimation:String) {
        
        
        let wait:SKAction = SKAction.wait(forDuration: 0.05)
        
        let walkAnimation:SKAction = SKAction(named: theAnimation, duration: moveSpeed)!
        
        let moveAction:SKAction = SKAction.moveBy(x: theXAmount, y: theYAmount, duration: moveSpeed)
        
        let group:SKAction = SKAction.group([walkAnimation, moveAction])
        
        let finish:SKAction = SKAction.run {
            
            print("Finish")
            
            
        }
        
        let seq:SKAction = SKAction.sequence([wait, group, finish])
        
        thePlayer.run(seq)
        
    }
    
    func attack() {
        
    /*   let newAttack:AttackArea = AttackArea(imageNamed: "AttackCircle")
        newAttack.alpha = 0
        newAttack.position = thePlayer.position
        newAttack.setUp()
        self.addChild(newAttack)
        newAttack.zPosition = thePlayer.zPosition - 1
        
        thePlayer.run(SKAction(named: "AttackDown")! )
    */
    }
    
    func getDifference(point:CGPoint) -> CGPoint {
        
        let newPoint:CGPoint = CGPoint(x: point.x + currentOffset.x, y: point.y + currentOffset.y)
        
        return newPoint
        
    }
    
    func touchDown(atPoint pos : CGPoint) {
        
        if thePlayer.action(forKey: "PlayerMoving") != nil {
            
            thePlayer.removeAction(forKey: "PlayerMoving")
            
        }
        
        pathArray.removeAll()
        currentOffset = CGPoint(x: thePlayer.position.x - pos.x, y: thePlayer.position.y - pos.y)
        pathArray.append(getDifference(point: pos))
        walkTime = 0
        
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        
        walkTime = walkTime + 0.1
        pathArray.append(getDifference(point: pos))
        
    }
    
    func touchUp(atPoint pos : CGPoint) {

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for t in touches {
            self.touchDown(atPoint: t.location(in: self))
            
            break
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            self.touchMoved(toPoint: t.location(in: self))
            
            break
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if thePlayer.action(forKey: "PlayerMoving") != nil {
            
            thePlayer.removeAction(forKey: "PlayerMoving")
            
        }
        
        createLineWith(array:pathArray)
        
        pathArray.removeAll()
        currentOffset = CGPoint.zero
        
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    func createLineWith(array:[CGPoint]) {
        
        let path = CGMutablePath()
        path.move(to:pathArray[0])
        
        for point in pathArray {
            
            path.addLine(to:point)
            
        }
        
        let line = SKShapeNode()
        line.path = path
        line.lineWidth = 10
        line.strokeColor = UIColor.white
        line.alpha = 0.4
        
        self.addChild(line)
        
        let fade:SKAction = SKAction.fadeOut(withDuration: 0.4)
        let runAfter:SKAction = SKAction.run {
            line.removeFromParent()
        }
        
        line.run(SKAction.sequence([fade, runAfter]))
        
        makePlayerFollowPath(path: path)
    }
    
    func makePlayerFollowPath(path:CGMutablePath) {
        
        let follow:SKAction = SKAction.follow(path, asOffset: false, orientToPath: false, duration: walkTime)
        let finish:SKAction = SKAction.run {
            self.runIdleAnimation()
        }
        let seq:SKAction = SKAction.sequence([follow, finish])
        
        thePlayer.run(seq, withKey:"PlayerMoving")
        
    }
    
    func runIdleAnimation() {
        
        if playerFacing == .front {
            
            let idleAnimation:SKAction = SKAction(named: "IdleDown", duration: 2)!
            thePlayer.run(idleAnimation)
            
        }
        else if playerFacing == .back {
            
            let idleAnimation:SKAction = SKAction(named: "IdleUp", duration: 2)!
            thePlayer.run(idleAnimation)
            
        }
        else if playerFacing == .left {
            
            let idleAnimation:SKAction = SKAction(named: "IdleLeft", duration: 2)!
            thePlayer.run(idleAnimation)
            
        }
        else if playerFacing == .right {
            
            let idleAnimation:SKAction = SKAction(named: "IdleRight", duration: 2)!
            thePlayer.run(idleAnimation)
            
        }
        
    }
    
    func playerUpdate() {
        
        if playerLastLocation != CGPoint.zero {
        
            if thePlayer.action(forKey: "PlayerMoving") != nil {
            
                if abs(thePlayer.position.x - playerLastLocation.x) > abs(thePlayer.position.y - playerLastLocation.y) {
                    
                    if thePlayer.position.x > playerLastLocation.x {
                        
                        playerFacing = .right
                        
                        if thePlayer.action(forKey: "WalkRight") == nil {
                            
                            animateWalk(theAnimation: "WalkRight")
                            
                        }
                        
                    } else {
                        
                        playerFacing = .left
                        
                        if thePlayer.action(forKey: "WalkLeft") == nil {
                            
                            animateWalk(theAnimation: "WalkLeft")
                            
                        }
                        
                    }
                    
                } else {
                    
                    if thePlayer.position.y > playerLastLocation.y {
                        
                        playerFacing = .back
                        
                        if thePlayer.action(forKey: "WalkUp") == nil {
                            
                            animateWalk(theAnimation: "WalkUp")
                            
                        }
                        
                    } else {
                        
                        playerFacing = .front
                        
                        if thePlayer.action(forKey: "WalkDown") == nil {
                            
                            animateWalk(theAnimation: "WalkDown")
                            
                        }
                        
                    }
                    
                }
                
            }
            
        }
        
        playerLastLocation = thePlayer.position
        
    }
    
    func animateWalk(theAnimation:String) {
        
        let walkAnimation:SKAction = SKAction(named: theAnimation, duration: 0.3)!
        thePlayer.run(walkAnimation, withKey: theAnimation)
        
    }

}
