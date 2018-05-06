//
//  GameScenePropertyList.swift
//  RPG
//
//  Created by Daniel Martinsson on 2018-05-01.
//  Copyright © 2018 Daniel Martinsson. All rights reserved.
//

import Foundation
import SpriteKit

extension GameScene {
    
    func parsePropertyList() {
        
        let path = Bundle.main.path(forResource: "GameData", ofType: "plist")
        
        let dict:NSDictionary = NSDictionary(contentsOfFile: path!)!
        
        if dict.object(forKey: "Levels") != nil {
            
            if let levelDict:[String : Any] = dict.object(forKey: "Levels") as? [String : Any] {
                
                for (key, value) in levelDict {
                    
                    if key == currentLevel {
                        
                        if let levelData:[String : Any] = value as? [String : Any] {
                            
                            for (key, value) in levelData {
                                
                                if key == "NPC" {
                                    
                                    createNPCwithDict( theDict:value as! [String : Any])
                                    
                                }
                                else if key == "Properties" {
                                    
                                    parseLevelSpecificProperties( theDict:value as! [String : Any])
                                }
                                else if key == "Rewards" {
                                    
                                    if value is [String:Any] {
                                        
                                        rewardDict = value as! [String:Any]
                                        
                                    }
                                    
                                }
                                else if key == "Clear" {
                                    
                                    if value is [String] {
                                        
                                        clearArray = value as! [String]
                                        
                                    }
                                    
                                }
                                
                            }
                            
                        }
                        
                    }
                    
                }
                
            }
  
        }
        
    }
    
    func createNPCwithDict( theDict:[String : Any]) {
        
        for (key, value) in theDict {
            
            var theBaseImage:String = ""
            var theRange:String = ""
            let nickName:String = key
            
            var alreadyFoundNPCinScene:Bool = false
            
            for node in self.children {
                
                if node.name == key {
                    
                    if node is NPC {
                        
                        useDictWithNPC(theDict: value as! [String:Any], theNPC: node as! NPC)
                        alreadyFoundNPCinScene = true
                        
                    }
                    
                }
                
            }
            
            if alreadyFoundNPCinScene == false {

                if let NPCData:[String : Any] = value as? [String : Any] {
                
                    for (key, value) in NPCData {
                    
                        if key == "BaseImage" {
                        
                            theBaseImage = value as! String
                        
                        } else if key == "Range" {
                        
                            theRange = value as! String
                        
                        }

                    }
                
                }
            
            let newNPC:NPC = NPC(imageNamed: theBaseImage)
            newNPC.name = nickName
            newNPC.baseFrame = theBaseImage
            newNPC.setUpWithDict(theDict: value as! [String : Any])
            self.addChild(newNPC)
            newNPC.zPosition = thePlayer.zPosition - 1
            newNPC.position = putWithinRange(nodeName: theRange)
            
            newNPC.alreadyContacted = defaults.bool(forKey: currentLevel + nickName + "alreadyContacted")
            }
            
        }
        
    }
    
    func useDictWithNPC(theDict:[String:Any], theNPC:NPC) {
        
        theNPC.setUpWithDict(theDict: theDict)
        
        for (key, value) in theDict {
            
            if key == "Range" {
                
                theNPC.position = putWithinRange(nodeName: value as! String)
                
            }
            
        }
        
        theNPC.alreadyContacted = defaults.bool(forKey: currentLevel + theNPC.name! + "alreadyContacted")
        
    }
    
    func parseLevelSpecificProperties (theDict:[String:Any]) {
        
        for (key, value) in theDict {
            
            if key == "CameraFollowsPlayer" {
                
                if value is Bool {
                    cameraFollowsPlayer = value as! Bool
                }
                
            } else if key == "CameraOffset" {
                
                if value is String {
                    let somePoint:CGPoint = CGPointFromString(value as! String)
                    cameraXOffset = somePoint.x
                    cameraYOffset = somePoint.y
                }
                
            } else if key == "ContinuePoint" {
                
                if value is Bool {
                    if value as! Bool == true {
                        defaults.set(currentLevel, forKey: "ContinuePoint")
                    }
                }
                
            } else if key == "DisableAttack" {
                
                if value is Bool {
                    disableAttack = value as! Bool
                }
                
            }
            
        }

    }
    
    //MARK: --- Set up items ---
    
    func setUpItem(theItem:WorldItem) {
        
        var foundItemInLevel:Bool = false
        
        let path = Bundle.main.path(forResource: "GameData", ofType: "plist")
        
        let dict:NSDictionary = NSDictionary(contentsOfFile: path!)!
        
        if dict.object(forKey: "Levels") != nil {
            
            if let levelDict:[String : Any] = dict.object(forKey: "Levels") as? [String : Any] {
                
                for (key, value) in levelDict {
                    
                    if key == currentLevel {
                        
                        if let levelData:[String : Any] = value as? [String : Any] {
                            
                            for (key, value) in levelData {
                                
                                if key == "Items" {
                                    
                                    if let itemsData:[String : Any] = value as? [String : Any] {
                                        
                                        for (key, value) in itemsData {
                                            
                                            if key == theItem.name {
                                                
                                                foundItemInLevel = true
                                                
                                                useDictWithWorldItem(theDict: value as! [String:Any], theItem: theItem)
                                                
                                                break
                                            }
                                            
                                        }
                                        
                                    }
                                    
                                }
                                break
                            }
                            
                        }
                        break
                    }
                    
                }
                
            }
            
        }
        
        if foundItemInLevel == false {
            
            if dict.object(forKey: "Items") != nil {
                
                if let itemsData:[String : Any] = dict.object(forKey: "Items") as? [String : Any] {
                    
                    for (key, value) in itemsData {
                        
                        if key == theItem.name {
                            
                            useDictWithWorldItem(theDict: value as! [String:Any], theItem: theItem)
                            
                            break
                            
                        }
                        
                    }
                    
                }
                
            }
            
        }
  
    }
    
    func useDictWithWorldItem(theDict:[String:Any], theItem:WorldItem) {
        
        theItem.setUpWithDict(theDict: theDict)

    }
 
}
