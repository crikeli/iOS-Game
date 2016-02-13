//
//  GameScene.swift
//  LighthouseSequoia
//
//  Created by Kelin Christi on 2/13/16.
//  Copyright (c) 2016 Kel Mar. All rights reserved.
//

import SpriteKit
import CoreMotion

class GameScene: SKScene {
    //Core Motion
    let manager = CMMotionManager()
    
    // Layered Nodes
    var backgroundNode: SKNode!
    var midgroundNode: SKNode!
    var foregroundNode: SKNode!
    var hudNode: SKNode!
    var player: SKNode!
    
    //destX
    var destX: CGFloat = 0.0
    
    // To Accommodate iPhone 6
    var scaleFactor: CGFloat!
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        physicsWorld.gravity = CGVector(dx: 0.0, dy: 0.1)
        
        scaleFactor = self.size.width/640.0
        
        backgroundNode = createBackgroundNode()
        //added z position so that the background is under the sprite node
        backgroundNode.zPosition = 0
        
        addChild(backgroundNode)
        foregroundNode = SKNode()
        
        addChild(foregroundNode)
        player = createPlayerNode()
        
        foregroundNode.addChild(player)
        
        //Core Motion Related Code
        if manager.accelerometerAvailable == true {
            // the startAccelerometerUpdatesToQueue method reads input from the accelerometer 
            //and constantly gets new updates.
            manager.startAccelerometerUpdatesToQueue(NSOperationQueue.currentQueue()!, withHandler:{
                data, error in
                
                var currentX = self.player.position.x
                print("PLAYER POSITION \(self.player.position.x)")
                print("ACCELERATION \(data!.acceleration.x)")
                
                // Depending on whether the device is tilted left or right, we determine
                //the acceleration of the player.
                if data!.acceleration.x < 0 {
                    self.destX = currentX + CGFloat(data!.acceleration.x * 100)
                }
                    
                else if data!.acceleration.x > 0 {
                    self.destX = currentX + CGFloat(data!.acceleration.x * 100)
                }
                
            })
            
        }

    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        //This updates the x-position of our player node.
        var action = SKAction.moveToX(destX, duration: 1)
        self.player.runAction(action)
        
        print("PLAYERRRRR \(player.position.x)")
        if player.position.y > 200.0 {
            backgroundNode.position = CGPoint(x: 0.0, y: -((player.position.y - 200.0)/10))
            foregroundNode.position = CGPoint(x: 0.0, y: -(player.position.y - 200.0))
        }
        if player.position.x < 300.0 {
            backgroundNode.position = CGPoint(x: -((player.position.x + 300.0)/10), y: 0.0)
            foregroundNode.position = CGPoint(x: -(player.position.x + 300.0),  y:0.0)
        }
        
        if player.position.x > 700.0 {
            backgroundNode.position = CGPoint(x: ((player.position.x - 700.0)/10), y: 0.0)
            foregroundNode.position = CGPoint(x: (player.position.x - 700.0),  y:0.0)
        }

    }
    
    func createBackgroundNode() -> SKNode {
        // 1
        // Create the node
        let backgroundNode = SKNode()
        let ySpacing = 64 * scaleFactor
        
        // 2
        // Go through images until the entire background is built
        for index in 0...19 {
            // 3
            let node = SKSpriteNode(imageNamed:String(format: "Background%02d", index + 1))
            // 4
            node.setScale(scaleFactor)
            node.anchorPoint = CGPoint(x: 0.5, y: 0.0)
            node.position = CGPoint(x: self.size.width / 2, y: ySpacing * CGFloat(index))
            //5
            backgroundNode.addChild(node)
        }
        
        // 6
        // Return the completed background node
        return backgroundNode
    }
    
    func createPlayerNode() -> SKNode {
        let playernode = SKNode()
        let sprite = SKSpriteNode(imageNamed:"Balloon")
        
        sprite.xScale = 0.5
        sprite.yScale = 0.5
        //Added z position to sprite so that it is above the background node.
        playernode.zPosition = 1
        playernode.position = CGPoint(x: self.size.width/2 ,y: 80.0)
        
        // 1
        playernode.physicsBody = SKPhysicsBody(circleOfRadius: sprite.size.width / 2)
        // 2
        playernode.physicsBody?.dynamic = true
        // 3
        playernode.physicsBody?.restitution = 1.0
        playernode.physicsBody?.friction = 0.0
        playernode.physicsBody?.angularDamping = 0.0
        playernode.physicsBody?.linearDamping = 0.0
        playernode.addChild(sprite)
        return playernode
    }
}
