//
//  GameScene.swift
//  RPG
//
//  Created by Daniel Martinsson on 2018-04-30.
//  Copyright © 2018 Daniel Martinsson. All rights reserved.
//

import SpriteKit
import GameplayKit

enum BodyType:UInt32 {
    case player = 1
    case item = 2
    case attackArea = 4
    case npc = 8
}

enum Facing:Int {
    
    case front, back, left, right
    
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    
    var thePlayer:Player = Player()
    var moveSpeed:TimeInterval = 1
    let swipeRightRec = UISwipeGestureRecognizer()
    let swipeLeftRec = UISwipeGestureRecognizer()
    let swipeUpRec = UISwipeGestureRecognizer()
    let swipeDownRec = UISwipeGestureRecognizer()
    let tapRec = UITapGestureRecognizer()
    let rotateRec = UIRotationGestureRecognizer()
    var currentLevel = ""
    var playerFacing:Facing = .front
    var playerLastLocation:CGPoint = CGPoint.zero
    var walkTime:TimeInterval = 0
    
    var infoLabel1:SKLabelNode = SKLabelNode()
    var infoLabel2:SKLabelNode = SKLabelNode()
    var speechIcon:SKSpriteNode = SKSpriteNode()
    var cameraFollowsPlayer:Bool = true
    var cameraXOffset:CGFloat = 0
    var cameraYOffset:CGFloat = 0
    var disableAttack:Bool = false
    var rewardDict = [String:Any]()
    var clearArray = [String]()
    var pathArray = [CGPoint]()
    var currentOffset:CGPoint = CGPoint.zero
    
    var entryNode:String = ""
    
    var transitionInProgress:Bool = false
    
    let defaults:UserDefaults = UserDefaults.standard
    
    //MARK --- Did move to view ---
    
    override func didMove(to view: SKView) {
        
        if currentLevel == "Grassland" {
            let bgm = SKAudioNode(fileNamed: "Super Mario World.mp3")
            self.addChild(bgm)
        }
        else if currentLevel == "Ending" {
            let bgm = SKAudioNode(fileNamed: "Thank you.mp3")
            self.addChild(bgm)
        }
        
        self.physicsWorld.contactDelegate = self
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        
        self.enumerateChildNodes(withName: "//*") {
            node, stop in
        
        
            if let theCamera:SKCameraNode = node as? SKCameraNode {
            
                self.camera = theCamera
            
                if theCamera.childNode(withName: "InfoLabel1") is SKLabelNode {
                
                    self.infoLabel1 = theCamera.childNode(withName: "InfoLabel1") as! SKLabelNode
                    self.infoLabel1.text = ""
                }
            if theCamera.childNode(withName: "InfoLabel2") is SKLabelNode {
                
                self.infoLabel2 = theCamera.childNode(withName: "InfoLabel2") as! SKLabelNode
                self.infoLabel2.text = ""
            }
            
            if theCamera.childNode(withName: "SpeechIcon") is SKSpriteNode {
                
                self.speechIcon = theCamera.childNode(withName: "SpeechIcon") as! SKSpriteNode
                self.speechIcon.isHidden = true
            }
                
            }
            
        }
        
        
        
        tapRec.addTarget(self, action: #selector(GameScene.tappedView))
        tapRec.numberOfTouchesRequired = 1
        tapRec.numberOfTapsRequired = 1
        self.view!.addGestureRecognizer(tapRec)
        
        if let somePlayer:Player = self.childNode(withName: "Player") as? Player {
            thePlayer = somePlayer
            thePlayer.physicsBody?.isDynamic = true
            thePlayer.physicsBody?.affectedByGravity = false
            thePlayer.physicsBody?.categoryBitMask = BodyType.player.rawValue
            thePlayer.physicsBody?.collisionBitMask = BodyType.item.rawValue
            thePlayer.physicsBody?.contactTestBitMask = BodyType.item.rawValue
            
            if entryNode != "" {
                if self.childNode(withName: entryNode) != nil {
                    thePlayer.position = (self.childNode(withName: entryNode)?.position)!
                }
            }
            
            
        }
        
        for node in self.children {
            
            if let someItem:WorldItem = node as? WorldItem {
                
                setUpItem(theItem:someItem)
            }
            
        }
        
        parsePropertyList()
        clearStuff(theArray: clearArray)
        sortRewards(rewards: rewardDict)
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        if cameraFollowsPlayer == true {
        
            self.camera?.position = CGPoint(x: thePlayer.position.x + cameraXOffset , y: thePlayer.position.y + cameraYOffset)
        
        }
        
        playerUpdate()
        
    }
    
    
   
}
