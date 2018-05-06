//
//  NPC.swift
//  RPG
//
//  Created by Daniel Martinsson on 2018-05-01.
//  Copyright © 2018 Daniel Martinsson. All rights reserved.
//

import Foundation
import SpriteKit

class NPC: SKSpriteNode {
    
    var frontName:String = ""
    var backName:String = ""
    var leftName:String = ""
    var rightName:String = ""
    
    var baseFrame:String = ""
    var isWalking:Bool = false
    var initialSpeechArray = [String]()
    var secondSpeechArray = [String]()
    var alreadyContacted:Bool = false
    
    var currentSpeech:String = ""
    var speechIcon:String = ""
    var isCollidableWithPlayer:Bool = false
    var isCollidableWithItems:Bool = false
    
    var infoTime:TimeInterval = 1

    func setUpWithDict(theDict:[String : Any]) {

        for (key, value) in theDict {
            
            if key == "Front" {
                
                if value is String {

                frontName = value as! String
                }
                
            }
            else if key == "Back" {
                if value is String {

                backName = value as! String
                }
            }
            
            else if key == "Left" {
                if value is String {

                leftName = value as! String
                }
            }
            
            else if key == "Right" {
                
                if value is String {

                rightName = value as! String
                }
            }
            
            else if key == "InitialSpeech" {
                
                if let theValue = value as? [String] {
                    
                    initialSpeechArray = theValue
                    
                }
                
                else if let theValue = value as? String {
                    
                    initialSpeechArray.append(theValue)
                    
                }
                
                else if key == "InfoTime" {
                    
                    if value is TimeInterval {
                    infoTime = value as! TimeInterval
                    }
                }
                
            }
                
            else if key == "SecondSpeech" {
                
                if let theValue = value as? [String] {
                    
                    secondSpeechArray = theValue
                    
                }
                
                else if let theValue = value as? String {
                    
                    secondSpeechArray.append(theValue)
                    
                }
                
            }
            
            else if key == "SpeechIcon" {
                
                if let theValue = value as? String {
                    
                    speechIcon = theValue
                    
                }
                
            }
            
            else if key == "CollidableWithPlayer" {
                
                if let theValue = value as? Bool {
                    
                    isCollidableWithPlayer = theValue
                    
                }
                
            }
            
            else if key == "CollidableWithItem" {
                
                if let theValue = value as? Bool {
                    
                    isCollidableWithItems = theValue
                    
                }
                
            }
            
            else if key == "BaseImage" {
                
                if let theValue = value as? String {
                    
                    baseFrame = theValue
                }
                
            }
            
        }
        
        let body:SKPhysicsBody = SKPhysicsBody(circleOfRadius: self.frame.size.width/3, center: CGPoint.zero)
        
        self.physicsBody = body
        body.isDynamic = true
        body.affectedByGravity = false
        body.allowsRotation = false
        
        self.physicsBody?.categoryBitMask = BodyType.npc.rawValue
        self.physicsBody?.contactTestBitMask = BodyType.player.rawValue
        
        if isCollidableWithPlayer == true && isCollidableWithItems == true {
            
            self.physicsBody?.collisionBitMask = BodyType.item.rawValue | BodyType.player.rawValue | BodyType.npc.rawValue | BodyType.attackArea.rawValue
            
        } else if isCollidableWithPlayer == false && isCollidableWithItems == true {
            
            self.physicsBody?.collisionBitMask = BodyType.item.rawValue | BodyType.player.rawValue | BodyType.npc.rawValue | BodyType.attackArea.rawValue
            
        } else if isCollidableWithPlayer == true && isCollidableWithItems == false {
            
            self.physicsBody?.collisionBitMask = BodyType.item.rawValue | BodyType.player.rawValue | BodyType.npc.rawValue | BodyType.attackArea.rawValue
            
        } else {
            
            self.physicsBody?.collisionBitMask = 0

        }
        
        walkRandom()
        
    }
    
    func walkRandom() {
        
        let waitTime = arc4random_uniform(3) + 1
        let wait:SKAction = SKAction.wait(forDuration: TimeInterval(waitTime))
        let endMove:SKAction = SKAction.run {
            self.walkRandom()
        }
        
        let randomNum = arc4random_uniform(4)
        
        if randomNum == 0 {
            
            self.run(SKAction(named: frontName)!)
            
            let move:SKAction = SKAction.moveBy(x: 0, y: -50, duration: 1)
            
            self.run(SKAction.sequence([move, wait, endMove]))
            
        } else if randomNum == 1 {
            
            self.run(SKAction(named: backName)!)
            
            let move:SKAction = SKAction.moveBy(x: 0, y: 50, duration: 1)
            
            self.run(SKAction.sequence([move, wait, endMove]))

            
        } else if randomNum == 2 {

            self.run(SKAction(named: leftName)!)
            
            let move:SKAction = SKAction.moveBy(x: -50, y: 0, duration: 1)
            
            self.run(SKAction.sequence([move, wait, endMove]))

            
        } else {

            self.run(SKAction(named: rightName)!)
            
            let move:SKAction = SKAction.moveBy(x: 50, y: 0, duration: 1)
            
            self.run(SKAction.sequence([move, wait, endMove]))

        }

    }
    
    func contactPlayer() {
        
        isWalking = false
        self.removeAllActions()
        
        self.texture = SKTexture(imageNamed: baseFrame)
        if alreadyContacted == false {
            
            alreadyContacted = true
            
        }
        
    }
    
    func endContactPlayer() {
        
        if isWalking == false {
            
            isWalking = true
            walkRandom()
            currentSpeech = ""
            
        }
        
    }
    
    func speak() -> String {
        
        if currentSpeech == "" {
            
            if alreadyContacted == false {
                
                let randomLine:UInt32 = arc4random_uniform(UInt32(initialSpeechArray.count))
                currentSpeech = initialSpeechArray[Int(randomLine)]
                
            } else {
                
                let randomLine:UInt32 = arc4random_uniform(UInt32(secondSpeechArray.count))
                currentSpeech = secondSpeechArray[Int(randomLine)]
                
                
            }
            
            let wait:SKAction = SKAction.wait(forDuration: 3)
            let run:SKAction = SKAction.run {
                
                self.currentSpeech = ""
                
            }
            
            self.run(SKAction.sequence([wait, run]))
            
        }
        
        
        return currentSpeech
    }
    
    
    
}
