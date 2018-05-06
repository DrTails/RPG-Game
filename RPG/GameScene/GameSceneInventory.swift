//
//  GameSceneInventory.swift
//  RPG
//
//  Created by Daniel Martinsson on 2018-05-03.
//  Copyright © 2018 Daniel Martinsson. All rights reserved.
//

import Foundation
import SpriteKit

extension GameScene {
    
    func sortRewards(rewards:[String:Any]) {
        
        for (key, value) in rewards {
            
            if key == "Health" {
                
            }
                
            else if key == "Weapon" {
                
            }
                
            else if key == "Currency" {
                
            }
                
            else if key == "Class" {
                
            } else {
                
                if value is Int {
                    
                    addToInventory(newInventory: key, amount: value as! Int)
                    
                }
                
            }
            
        }
        
    }
    
    func addToInventory(newInventory:String, amount:Int) {
        
        if defaults.integer(forKey: newInventory) != 0 {
            
            let currentAmount:Int = defaults.integer(forKey: newInventory)
            let newAmount:Int = currentAmount + amount
            
            print("Set \(newAmount) for \(newInventory)")
            defaults.set(newAmount, forKey: newInventory)
            
            checkForItemThatMightOpen(newInventory: newInventory, amount: newAmount)

        } else {
            
            print("Set \(amount) for \(newInventory)")
            
            defaults.set(amount, forKey: newInventory)
            checkForItemThatMightOpen(newInventory: newInventory, amount: amount)
            
        }
        
    }
    
    func checkForItemThatMightOpen(newInventory:String, amount:Int) {
        
        for node in self.children {
            
            if let theItem:WorldItem = node as? WorldItem {
                
                if theItem.isOpen == false {
                    
                    if newInventory == theItem.requiredObject {
                        
                        if amount >= theItem.requiredAmount {
                            
                            if theItem.unlockedTextArray.count > 0 {
                                
                                splitText(theText: theItem.getUnlockedInfo())
                                theItem.open()
                                
                                if theItem.unlockedIcon != "" {
                                    
                                    showIcon(theTexture: theItem.unlockedIcon)
                                    
                                }
                                
                            }
                            
                        }
                        
                    }
                    
                }
                
            }
            
        }
        
    }

}
