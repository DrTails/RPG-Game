//
//  GameScenePhysics.swift
//  RPG
//
//  Created by Daniel Martinsson on 2018-05-01.
//  Copyright © 2018 Daniel Martinsson. All rights reserved.
//

import Foundation
import SpriteKit

extension GameScene {
    
    func didBegin(_ contact: SKPhysicsContact) {
      
        if contact.bodyA.categoryBitMask == BodyType.player.rawValue && contact.bodyB.categoryBitMask == BodyType.npc.rawValue {
            
            if let theNPC:NPC = contact.bodyB.node as? NPC {
                
                contactWithNPC(theNPC: theNPC)
      
            }
   
        } else if contact.bodyB.categoryBitMask == BodyType.player.rawValue && contact.bodyA.categoryBitMask == BodyType.npc.rawValue {
            
            if let theNPC:NPC = contact.bodyA.node as? NPC {
                
                contactWithNPC(theNPC: theNPC)
                
            }
            
        } else if contact.bodyA.categoryBitMask == BodyType.player.rawValue && contact.bodyB.categoryBitMask == BodyType.item.rawValue {
            
            if let theItem:WorldItem = contact.bodyB.node as? WorldItem {
                
                contactWithItem(theItem: theItem)
       
            }
         
        } else if contact.bodyB.categoryBitMask == BodyType.player.rawValue && contact.bodyA.categoryBitMask == BodyType.item.rawValue {
            
            if let theItem:WorldItem = contact.bodyA.node as? WorldItem {
                
                contactWithItem(theItem: theItem)
                
            }
            
        }

    }
    
    func didEnd(_ contact: SKPhysicsContact) {
        
        if contact.bodyA.categoryBitMask == BodyType.player.rawValue && contact.bodyB.categoryBitMask == BodyType.npc.rawValue {
            
            if let theNPC:NPC = contact.bodyB.node as? NPC {
                
                endContactWithNPC(theNPC: theNPC)

            }
      
        } else if contact.bodyB.categoryBitMask == BodyType.player.rawValue && contact.bodyA.categoryBitMask == BodyType.npc.rawValue {
            
            if let theNPC:NPC = contact.bodyA.node as? NPC {
                
                endContactWithNPC(theNPC: theNPC)
    
            }
            
        }
        else if contact.bodyA.categoryBitMask == BodyType.player.rawValue && contact.bodyB.categoryBitMask == BodyType.item.rawValue {
            
            if let theItem:WorldItem = contact.bodyB.node as? WorldItem {
                
                endContactWithItem(theItem: theItem)
         
            }
        
        } else if contact.bodyB.categoryBitMask == BodyType.player.rawValue && contact.bodyA.categoryBitMask == BodyType.item.rawValue {
            
            if let theItem:WorldItem = contact.bodyA.node as? WorldItem {
                
                endContactWithItem(theItem: theItem)
                
            }
            
        }
        
    }
    
    //MARK: --- NPC begins and end contacts ---
    
    func contactWithNPC(theNPC:NPC) {
        
        splitText(theText: theNPC.speak())
        theNPC.contactPlayer()
        
        thePlayer.removeAllActions()
        
        rememberThis(withThing: theNPC.name!, toRemember: "alreadyContacted")
        
        if theNPC.speechIcon != "" {
        
            showIcon(theTexture: theNPC.speechIcon)
        
        }
        
    }
    
    func endContactWithNPC(theNPC:NPC) {
        
        theNPC.endContactPlayer()
        
        fadeOutInfoText(waitTime:theNPC.infoTime)
        
    }
    
    
    //MARK: --- World items begins and end contacts ---
    
    func contactWithItem(theItem:WorldItem) {
        
        splitText(theText: theItem.getInfo())
        thePlayer.removeAllActions()
        self.runIdleAnimation()
        
        if theItem.isOpen == false {
            
            if theItem.lockedIcon != "" {
                
                showIcon(theTexture: theItem.lockedIcon)
                
            }
            
        }
        else if theItem.isOpen == true {
            
            if theItem.openIcon != "" {
                
                showIcon(theTexture: theItem.openIcon)
                
            }
            
            if theItem.rewardDictionary.count > 0 {
                
                sortRewards(rewards: theItem.rewardDictionary)
                
                theItem.rewardDictionary.removeAll()
                
            }
            
            if theItem.isPortal == true {
                
                if theItem.portalToLevel != "" {
                    
                    //must go to level
                    
                    usePortalToLevel(theLevel: theItem.portalToLevel, toWhere: theItem.portalToPosition, delay: theItem.portalDelay)
                    
                } else if theItem.portalToPosition != "" {
                    
                    //must go to somewhere within level
                    usePortalInCurrentLevel(toWhere: theItem.portalToPosition, delay: theItem.portalDelay)

                }
                
            }
            
            theItem.afterOpenContact()
            
        }
        
    }
    
    func endContactWithItem(theItem:WorldItem) {

        fadeOutInfoText(waitTime:theItem.infoTime)
  
    }
    
    func usePortalInCurrentLevel(toWhere:String, delay:TimeInterval) {
        
        thePlayer.isHidden = true
        let wait:SKAction = SKAction.wait(forDuration: delay)
        let portalAction:SKAction = SKAction.run {
        
        if self.childNode(withName: toWhere) != nil {
            
            self.thePlayer.removeAllActions()
            
            let newLocation:CGPoint = (self.childNode(withName: toWhere)?.position)!
            self.thePlayer.run(SKAction.move(to: newLocation, duration: 0.0))
            self.thePlayer.isHidden = false

        } else {
            
            self.thePlayer.isHidden = false
            
            }
            
        }
        
        self.run(SKAction.sequence([wait, portalAction]))
            
        
    }
    
    func usePortalToLevel(theLevel:String, toWhere:String, delay:TimeInterval) {
        
        thePlayer.isHidden = true
        
        let wait:SKAction = SKAction.wait(forDuration: delay)
        let portalAction:SKAction = SKAction.run {
            
        
        if toWhere != "" {
            
            self.loadLevel(theLevel: theLevel , toWhere: toWhere)
            
            self.defaults.set(toWhere, forKey: "ContinueWhere")
            
        } else {
            
            self.loadLevel(theLevel: theLevel , toWhere: "")
            
        }
            
        }
        
        self.run(SKAction.sequence([wait, portalAction]))
        
    }
    
    
    
}
