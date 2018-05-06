//
//  WorldItem.swift
//  RPG
//
//  Created by Daniel Martinsson on 2018-05-03.
//  Copyright © 2018 Daniel Martinsson. All rights reserved.
//

import Foundation
import SpriteKit

class WorldItem: SKSpriteNode {
    
    var portalToLevel:String = ""
    var portalToPosition:String = ""
    var isPortal:Bool = false
    var requiredObject:String = ""
    var requiredAmount:Int = 0
    var deductOnEntry:Bool = false
    var timeToOpen:TimeInterval = 0
    var isOpen:Bool = true
    var portalDelay:TimeInterval = 0
    
    var lockedTextArray = [String]()
    var unlockedTextArray = [String]()
    var openTextArray = [String]()
    var currentInfo:String = ""
    var currentUnlockedText:String = ""
    var rewardDictionary = [String:Any]()
    var neverRewardAgain:Bool = false
    var neverShowAgain:Bool = false
    var deleteBody:Bool = false
    var deleteFromLevel:Bool = false
    var removeDictionary = [String:Any]()
    var lockedIcon:String = ""
    var unlockedIcon:String = ""
    var openIcon:String = ""
    var infoTime:TimeInterval = 3
    
    
    var openAnimation:String = ""
    var openImage:String = ""
    
    let defaults:UserDefaults = UserDefaults.standard
    
    func setUpWithDict(theDict:[String : Any]) {

        for (key, value) in theDict {
            
            if key == "Requires" {
                
                isOpen = false
                
                if value is [String:Any] {
                    
                    sortRequirements(theDict: value as! [String:Any])
                    
                }
            
            } else if key == "PortalTo" {
                
                if value is [String:Any] {
                    
                    sortPortalTo(theDict: value as! [String:Any])
                    
                }
                
            } else if key == "Text" {
                            
                if value is [String:Any] {
                                
                    sortText(theDict: value as! [String:Any])
                    
                }
                
            } else if key == "Appearance" {
                
                if value is [String:Any] {
                    
                    sortAppearance(theDict: value as! [String:Any])
                    
                }
                
            } else if key == "Rewards" {
                
                if value is [String:Any] {
                    
                    sortRewards(theDict: value as! [String:Any])
                    
                }
                
            } else if key == "AfterContact" {
                
                if value is [String:Any] {
                    
                    sortAfterContact(theDict: value as! [String:Any])
                    
                }
                
            } else if key == "RemoveWhen" {
                
                if value is [String:Any] {
                    
                    removeDictionary = value as! [String:Any]
                    
                }
                
            }
            
        }
        
        self.physicsBody?.categoryBitMask = BodyType.item.rawValue
        self.physicsBody?.collisionBitMask = BodyType.player.rawValue
        self.physicsBody?.contactTestBitMask = BodyType.player.rawValue
        
        checkRequirements()
        checkRemoveRequirements()
        
    }
    
    func checkRequirements() {
        
        if defaults.integer(forKey: requiredObject) >= requiredAmount {
            
            open()
            
        } else {
            
            isOpen = false
            
        }
        
    }
    
    func checkRemoveRequirements() {
        
        for (key, value) in removeDictionary {
            
            if value is Int {
                
                if defaults.integer(forKey: key) >= value as! Int {
                    
                    self.removeFromParent()
                    
                }
                
            }
            
        }
        
    }
    
    func sortPortalTo(theDict:[String:Any]) {
        
        for (key, value) in theDict {
            
            if key == "Level" {
                
                if value is String {
                    
                    portalToLevel = value as! String
                    isPortal = true
                    
                    print(portalToLevel)
                    
                }
                
            }
            else if key == "Where" {
                
                if value is String {
                    
                    portalToPosition = value as! String
                    isPortal = true
                    
                    print(portalToPosition)
                    
                }
                
            }
            else if key == "Delay" {
                
                if value is TimeInterval {
                    
                    portalDelay = value as! TimeInterval
                    
                }
                
            }
            
        }
        
    }
    
    func sortAppearance(theDict:[String:Any]) {
        
        for (key, value) in theDict {
            
            if key == "OpenImage" {
                
                if value is String {
                    
                    openImage = value as! String
 
                }
                
            }
            else if key == "OpenAnimation" {
                
                if value is String {
                    
                    openAnimation = value as! String

                }
                
            }
            
        }
        
    }
    
    func sortRewards(theDict:[String:Any]) {
        
        for (key, value) in theDict {
            
            rewardDictionary[key] = value

        }
        
    }
    
    func sortRequirements(theDict:[String:Any]) {
        
        for (key, value) in theDict {
            
            if key == "Object" {
                
                if value is String {
                    
                    requiredObject = value as! String
                    
                }
                
            }
            else if key == "Amount" {
                
                if value is Int {
                    
                    requiredAmount = value as! Int
                    
                }
                
            }
            else if key == "DeductOnEntry" {
                
                if value is Bool {
                    
                    deductOnEntry = value as! Bool
                    
                }
                
            }
            else if key == "TimeToOpen" {
                
                if value is TimeInterval {
                    
                    timeToOpen = value as! TimeInterval
                    
                }
                
            }
            
        }
        
        if defaults.integer(forKey: requiredObject) >= requiredAmount {
            
            isOpen = true

            
        } else {
            
            isOpen = false

        }
 
    }
    
    func sortAfterContact(theDict:[String:Any]) {
        
        for (key, value) in theDict {
            
            if key == "NeverRewardAgain" {
                
                if value is Bool {
                    
                    neverRewardAgain = value as! Bool
                    
                }
                
            }
            else if key == "NeverShowAgain" {
                
                if value is Bool {
                    
                    neverShowAgain = value as! Bool
                    
                }
                
            }
            else if key == "DeleteFromLevel" {
                
                if value is Bool {
                    
                    deleteFromLevel = value as! Bool
                    
                }
                
            }
            else if key == "DeleteBody" {
                
                if value is Bool {
                    
                    deleteBody = value as! Bool
                    
                }
                
            }
            
        }
        
    }
    
    func sortText(theDict: [String:Any]) {
        
        for (key, value) in theDict {
            
            if key == "Locked" {
                
                if let theValue = value as? [String] {
                    
                    lockedTextArray = theValue
                    
                }
                else if let theValue = value as? String {
                    
                    lockedTextArray.append(theValue)
                    
                }
                
            }
                
            else if key == "Unlocked" {
                
                if let theValue = value as? [String] {
                    
                    unlockedTextArray = theValue
                    
                }
                else if let theValue = value as? String {
                    
                    unlockedTextArray.append(theValue)
                    
                }
                
            }
                
            else if key == "Open" {
                
                if let theValue = value as? [String] {
                    
                    openTextArray = theValue
                    
                }
                else if let theValue = value as? String {
                    
                    openTextArray.append(theValue)
                    
                }
                
            }
            
            else if key == "UnlockedIcon" {
                
                if let theValue = value as? String {
                    
                    unlockedIcon = theValue
                    
                }
            }
            
            else if key == "LockedIcon" {
                
                if let theValue = value as? String {
                    
                    lockedIcon = theValue
                    
                }
            }
            
            else if key == "OpenIcon" {
                
                if let theValue = value as? String {
                    
                    openIcon = theValue
                    
                }
            }
            
            else if key == "Time" {
                
                if let theValue = value as? TimeInterval {
                    
                    infoTime = theValue
                    
                }
            }
        }
    }
    
    func getInfo() -> String {
        
        if currentInfo == "" {
            
            if isOpen == false {
                
                if lockedTextArray.count > 0 {
                    
                    let randomLine:UInt32 = arc4random_uniform( UInt32(lockedTextArray.count))
                    currentInfo = lockedTextArray[Int(randomLine)]
                    
                }
                
            } else {
                
                if openTextArray.count > 0 {
                    
                    let randomLine:UInt32 = arc4random_uniform( UInt32(openTextArray.count))
                    currentInfo = openTextArray[Int(randomLine)]
                    
                }
            }
            
            let wait:SKAction = SKAction.wait(forDuration: 3)
            let run:SKAction = SKAction.run {
                
                self.currentInfo = ""
                
            }
            
            self.run( SKAction.sequence([wait, run]))
 
        }
        
        return currentInfo
    }
    
    func open() {

        isOpen = true
        
        if openAnimation != "" {
            
            self.run(SKAction(named: openAnimation)!)
            
        } else if openImage != "" {
            
            self.texture = SKTexture(imageNamed: openImage)
            
        }
        
    }
    
    func getUnlockedInfo() -> String {
        
        if currentUnlockedText == "" {
            
            let randomLine:UInt32 = arc4random_uniform( UInt32(unlockedTextArray.count))
            currentUnlockedText = unlockedTextArray[Int(randomLine)]
            
            let wait:SKAction = SKAction.wait(forDuration: 3)
            let run:SKAction = SKAction.run {
                
                self.currentUnlockedText = ""
                
            }
            
            self.run( SKAction.sequence([wait, run]))
            
        }
        
        return currentUnlockedText
    }
    
    func afterOpenContact() {
        
        if isOpen == true {
            
            if deleteFromLevel == true {
                
                self.removeFromParent()
                
            }
            
            if deleteBody == true {
                
                self.physicsBody = nil
                
            }
            
            if deductOnEntry == true {
                
                
                if defaults.integer(forKey: requiredObject) != 0 {
                    
                    deductOnEntry = false
                    
                    let currentAmount:Int = defaults.integer(forKey: requiredObject)
                    let newAmount:Int = currentAmount - requiredAmount
                    
                    defaults.set(newAmount, forKey: requiredObject)
                    
                    print("Set \(newAmount) for \(requiredObject)")
                    
                }
                
            }
            
        }
        
    }
    
}
