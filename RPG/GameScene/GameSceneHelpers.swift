//
//  GameSceneHelpers.swift
//  RPG
//
//  Created by Daniel Martinsson on 2018-05-01.
//  Copyright © 2018 Daniel Martinsson. All rights reserved.
//

import Foundation
import SpriteKit

extension GameScene {
    
    func putWithinRange(nodeName:String) -> CGPoint {
        
        var somePoint:CGPoint = CGPoint.zero
        
        for node in self.children {
            
            if node.name == nodeName {
                
                if let rangeNode:SKSpriteNode = node as? SKSpriteNode {
                    
                    let widthVar:UInt32 = UInt32(rangeNode.frame.size.width)
                    let heightVar:UInt32 = UInt32(rangeNode.frame.size.height)
                    
                    let randomX = arc4random_uniform(widthVar)
                    let randomY = arc4random_uniform(heightVar)
                    
                    let frameStartX = rangeNode.position.x - (rangeNode.size.width/2)
                    let frameStartY = rangeNode.position.y - (rangeNode.size.height/2)
                    
                    somePoint = CGPoint(x: frameStartX + CGFloat(randomX), y: frameStartY + CGFloat(randomY)  )
                    
                }
                
                break
            }

        }

        return somePoint
        
    }
    
    func splitText(theText:String) {
        
        if theText != "" {
        
        let maxInOneLine:Int = 25
        var i:Int = 0
        
        var line1:String = ""
        var line2:String = ""
        
        var useLine2:Bool = false
        
        for letter in theText {
            
            if i > maxInOneLine && String(letter) == " " {
                
                useLine2 = true
                
            }
            
            if useLine2 == false {
                
                line1 = line1 + String(letter)
                
            } else {
                
                line2 = line2 + String(letter)
                
            }

            i += 1
            
        }
        infoLabel1.removeAllActions()
        infoLabel2.removeAllActions()
        
        infoLabel1.text = line1
        infoLabel2.text = line2
        
        infoLabel1.alpha = 1
        infoLabel2.alpha = 1
        }
        
    }
    
    func fadeOutInfoText(waitTime:TimeInterval) {
        
        infoLabel1.removeAllActions()
        infoLabel2.removeAllActions()
        speechIcon.removeAllActions()
        let wait:SKAction = SKAction.wait(forDuration: waitTime)
        let fade:SKAction = SKAction.fadeAlpha(to: 0, duration: 0.6)
        let run:SKAction = SKAction.run {
            
            self.infoLabel1.text = ""
            self.infoLabel2.text = ""
            self.infoLabel1.alpha = 1
            self.infoLabel2.alpha = 1
            self.speechIcon.isHidden = true
        }
        
        let seq:SKAction = SKAction.sequence([wait, fade, run])
        let seq2:SKAction = SKAction.sequence([wait, fade])
        
        infoLabel1.run(seq)
        infoLabel2.run(seq2)
        speechIcon.run(seq2)
        
    }
    
    func loadLevel(theLevel:String, toWhere:String) {
        
        if transitionInProgress == false {
        
            transitionInProgress = true
        
        if let scene = GameScene(fileNamed: theLevel) {
            
            scene.currentLevel = theLevel
            scene.scaleMode = .aspectFill
            scene.entryNode = toWhere
            
            let transition:SKTransition = SKTransition.fade(with: SKColor.black, duration: 2)
            
            self.view?.presentScene(scene, transition:transition)
 
        }
        
        else {
            
            print("Could not find SKS file")
            
            }
            
        }

    }
    func rememberThis(withThing:String, toRemember:String) {
        
        defaults.set(true, forKey: currentLevel + withThing + toRemember)
        
    }
    
    func showIcon(theTexture:String) {
        
        speechIcon.removeAllActions()
        speechIcon.alpha = 1
        speechIcon.isHidden = false
        speechIcon.texture = SKTexture(imageNamed: theTexture)
        
    }
    
    func clearStuff(theArray:[String]) {
        
        for thing in theArray {
            
            defaults.removeObject(forKey: thing)
            print ("Clearing out \(thing)")
            
        }
        
    }

}
