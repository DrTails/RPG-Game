//
//  GameSceneGestures.swift
//  RPG
//
//  Created by Daniel Martinsson on 2018-05-01.
//  Copyright © 2018 Daniel Martinsson. All rights reserved.
//

import Foundation
import SpriteKit

extension GameScene {
    
    @objc func tappedView() {
        
        if disableAttack == false {
        
            attack()
        
        }
    }
    
    @objc func swipedRight() {
        
        print("Went right")
        
        move(theXAmount: 100, theYAmount: 0, theAnimation: "WalkRight")

    }
    
    @objc func swipedLeft() {
        
        print("Went left")
        
        move(theXAmount: -100, theYAmount: 0, theAnimation: "WalkLeft")

    }
    
    @objc func swipedUp() {
        
        print("Went up")
        
        move(theXAmount: 0, theYAmount: 100, theAnimation: "WalkUp")

    }
    
    @objc func swipedDown() {
        
        print("Went down")
        
        move(theXAmount: 0, theYAmount: -100, theAnimation: "WalkDown")
        
    }
    
    @objc func rotatedView(_ sender:UIRotationGestureRecognizer) {
        
        if sender.state == .began {
            print("Rotation began")
        }
        if sender.state == .changed {
            print("Rotation changed")
            print(sender.rotation)
            
            let rotateAmount = Measurement(value: Double(sender.rotation), unit: UnitAngle.radians).converted(to: .degrees).value
            print(rotateAmount)
            
            thePlayer.zRotation = -sender.rotation
            
        }
        if sender.state == .ended {
            print("Rotation ended")
        }
        
    }
    
    func cleanUp() {
                
        for gesture in (self.view?.gestureRecognizers)! {
            
            self.view?.removeGestureRecognizer(gesture)
            
        }
        
    }
    
}
