//
//  GameScene.swift
//  uofthacks
//
//  Created by Justin Koh, Michelle Chen
//

import SpriteKit
import GameplayKit

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

extension CGPoint {
    func length() -> CGFloat {
        return sqrt(x*x + y*y)
    }
    
    func normalized() -> CGPoint {
        return self / length()
    }
}

class GameScene: SKScene
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
        addChild(player)
        
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
        
        //calculates the vector from the player to the position that was touched
        let offset = touchLocation - laser.position
        
        //do not do anything if the player tries to shoot backwards
        if(offset.y < 0)
        {
            return
        }
        
        //add the laser to the scene
        addChild(laser)
        
        //direction of where to shoot
        let direction = offset.normalized()
        
        //guarantees that the laser will fly off the screen
        let shotDistance = direction * 1000
        
        //add the distance to the player's position (destination of the laser)
        let realDest = shotDistance + laser.position
        
        //actions
        let actionMove = SKAction.move(to: realDest, duration: 2.0)
        let actionMoveDone = SKAction.removeFromParent()
        laser.run(SKAction.sequence([actionMove, actionMoveDone]))
    }
}
