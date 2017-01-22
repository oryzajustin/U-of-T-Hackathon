//
//  GameScene.swift
//  uofthacks
//
//  Created by Justin Koh, Michelle Chen
//

import SpriteKit
import GameplayKit
import SceneKit

//functions to assist with vector calculations
func + (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x + right.x, y: left.y + right.y)
}

func - (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x - right.x, y: left.y - right.y)
}

func * (point: CGPoint, scalar: CGFloat) -> CGPoint {
    return CGPoint(x: point.x * scalar, y: point.y * scalar)
}

func / (point: CGPoint, scalar: CGFloat) -> CGPoint {
    return CGPoint(x: point.x / scalar, y: point.y / scalar)
}

#if !(arch(x86_64) || arch(arm64))
    func sqrt(a: CGFloat) -> CGFloat {
        return CGFloat(sqrtf(Float(a)))
    }
#endif

//set up physics constants
struct PhysicsCategory {
    static let None      : UInt32 = 0
    static let All       : UInt32 = UInt32.max
    static let Meteor   : UInt32 = 0b1
    static let Laser    : UInt32 = 0b10
}

extension CGPoint {
    func length() -> CGFloat {
        return sqrt(x*x + y*y)
    }
    
    func normalized() -> CGPoint {
        return self / length()
    }
}

class GameScene: SKScene, SKPhysicsContactDelegate
{
    //set the player's sprite to be the spaceship png ("player" in assets)
    let player = SKSpriteNode(imageNamed: "player")
    
    
    override func didMove(to view: SKView)
    {
        //set background to black
        backgroundColor = SKColor.black
        
        //set the player's position to the middle of the screen and at the bottom
        player.position = CGPoint(x: size.width * 0.5, y: size.height * 0.1)
        
        //add the spaceship to the scene
        self.addChild(player)
        
        //sets up game to have no gravity, and notifies when collision occurs
        physicsWorld.gravity = CGVector.zero
        physicsWorld.contactDelegate = self
        
        //calling the method to actually create the meteors (spawning them forever)
        run(SKAction.repeatForever(SKAction.sequence([SKAction.run(addSmallMeteor), SKAction.wait(forDuration: 2.0)])))
        run(SKAction.repeatForever(SKAction.sequence([SKAction.run(addMediumMeteor), SKAction.wait(forDuration: 6.0)])))
    }
    
    //generating random numbers
    func random() -> CGFloat
    {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    func random(min: CGFloat, max: CGFloat) -> CGFloat
    {
        return random() * (max - min) + min
    }
    
    //function to create small sized meteors
    func addSmallMeteor()
    {
        //set the sprite to be the mediumMeteor png (image name is different than the variable name)
        let smallMeteor = SKSpriteNode(imageNamed: "mediumMeteor")
        
        //creates physics body for sprite
        smallMeteor.physicsBody = SKPhysicsBody(rectangleOf: smallMeteor.size)
        
        //sets sprite to be dynamic
        smallMeteor.physicsBody?.isDynamic = true
        
        //sets category bit mask to be meteorCategory
        smallMeteor.physicsBody?.categoryBitMask = PhysicsCategory.Meteor
        
        //contactTestBitMask indicated what categories of objecxts this object should notify when they intersect
        smallMeteor.physicsBody?.contactTestBitMask = PhysicsCategory.Laser
        
        //collisionBitMask indicates what categories of objects this object that the physics engine responds to
        smallMeteor.physicsBody?.collisionBitMask = PhysicsCategory.None
        
        //calculate where on the screen the meteor will spawn
        let actualX = random(min: smallMeteor.size.width/2, max: size.width - smallMeteor.size.width/2)
        
        //spawn the meteor off screen and at the top
        smallMeteor.position = CGPoint(x: actualX, y: size.height + smallMeteor.size.height/2)
        
        //add the meteor to the scene
        addChild(smallMeteor)
        
        //set varying speeds of the meteors
        let actualDuration = random (min: CGFloat(3.0), max: CGFloat(5.0))
        
        //actions
        let actionMove = SKAction.move(to: CGPoint(x: actualX, y: -smallMeteor.size.width/2), duration: TimeInterval(actualDuration))
        let actionMoveDone = SKAction.removeFromParent()
        smallMeteor.run(SKAction.sequence([actionMove, actionMoveDone]))
    }
    
    //function to create medium sized meteors
    func addMediumMeteor()
    {
        //set the sprite to be the largeMeteor png
        let mediumMeteor = SKSpriteNode(imageNamed: "largeMeteor")
        
        //creates physics body for sprite
        mediumMeteor.physicsBody = SKPhysicsBody(rectangleOf: mediumMeteor.size)
        
        //sets sprite to be dynamic
        mediumMeteor.physicsBody?.isDynamic = true
        
        //sets category bit mask to be meteorCategory
        mediumMeteor.physicsBody?.categoryBitMask = PhysicsCategory.Meteor
        
        //contactTestBitMask indicated what categories of objecxts this object should notify when they intersect
        mediumMeteor.physicsBody?.contactTestBitMask = PhysicsCategory.Laser
        
        //collisionBitMask indicates what categories of objects this object that the physics engine responds to
        mediumMeteor.physicsBody?.collisionBitMask = PhysicsCategory.None
        
        //calculate where on the screen the meteor will spawn
        let actualX2 = random(min: mediumMeteor.size.width/2, max: size.width - mediumMeteor.size.width/2)
        
        //spawn the meteor off screen and at the top
        mediumMeteor.position = CGPoint(x: actualX2, y: size.height + mediumMeteor.size.height/2)
        
        //add meteor to the scene
        addChild(mediumMeteor)
        
        //set the varying speeds of the meteors
        let actualDuration2 = random (min: CGFloat(3.0), max: CGFloat(5.0))

        //actions
        let actionMove2 = SKAction.move(to: CGPoint(x: actualX2, y: -mediumMeteor.size.width/2), duration: TimeInterval(actualDuration2))
        let actionMoveDone2 = SKAction.removeFromParent()
        mediumMeteor.run(SKAction.sequence([actionMove2, actionMoveDone2]))
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        //rotating spaceship
        for touch in touches{
            let location = touch.location(in: self)
            let dx = CGFloat(location.x - player.position.x)
            let dy = CGFloat(location.y - player.position.y)
            
            let angle = atan2(dy,dx) - CGFloat(M_PI_2)
            let direction = SKAction.rotate(toAngle: angle, duration: 0.1, shortestUnitArc: true)
            
            player.run(direction)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        //activated by touch
        guard let touch = touches.first else
        {
            return
        }
        let touchLocation = touch.location(in: self)
        
        //make a laser sprite shoot out from where the player is positioned
        let laser = SKSpriteNode(imageNamed: "laser")
        laser.position = player.position
        
        laser.physicsBody = SKPhysicsBody(circleOfRadius: laser.size.width/2)
        laser.physicsBody?.isDynamic = true
        laser.physicsBody?.categoryBitMask = PhysicsCategory.Laser
        laser.physicsBody?.contactTestBitMask = PhysicsCategory.Meteor
        laser.physicsBody?.collisionBitMask = PhysicsCategory.None
        laser.physicsBody?.usesPreciseCollisionDetection = true
        
        //calculates the vector from the player to the position that was touched
        let offset = touchLocation - laser.position
        
        //do not do anything if the player tries to shoot backwards
        if(offset.y < 0)
        {
            return
        }
        
        //add the laser to the scene
        self.addChild(laser)
        
        //direction of where to shoot
        let direction = offset.normalized()
        
        //guarantees that the laser will fly off the screen
        let shotDistance = direction * 1000
        
        //add the distance to the player's position (destination of the laser)
        let realDest = shotDistance + laser.position
        
        //actions
        let actionMove = SKAction.move(to: realDest, duration: 0.8)
        let actionMoveDone = SKAction.removeFromParent()
        laser.run(SKAction.sequence([actionMove, actionMoveDone]))
        
        //rotating laser
        let location = touch.location(in: self)
        let dx = CGFloat(location.x - player.position.x)
        let dy = CGFloat(location.y - player.position.y)
        
        let angle = atan2(dy,dx) - CGFloat(M_PI_2)
        let laserdirection = SKAction.rotate(toAngle: angle, duration: 0.1, shortestUnitArc: true)
        
        laser.run(laserdirection) //action
    }
    
    func laserDidHitMeteor(laser: SKSpriteNode, meteor: SKSpriteNode)
    {
        print("hit")
        laser.removeFromParent()
        meteor.removeFromParent()
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        // passes two bodies that collide, does not guarantee that they are passed in any particular order
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        // Checks if the two objects that collide are the laser and a meteor
        if ((firstBody.categoryBitMask & PhysicsCategory.Meteor != 0) &&
            (secondBody.categoryBitMask & PhysicsCategory.Laser != 0)) {
            if let meteor = firstBody.node as? SKSpriteNode, let
                laser = secondBody.node as? SKSpriteNode {
                laserDidHitMeteor(laser: laser, meteor: meteor)
            }
        }
        
    }
}
