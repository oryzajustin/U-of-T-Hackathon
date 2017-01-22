//
//  GameOver.swift
//  uofthacks
//
//  Justin Koh, Michelle Chen
//

import Foundation
import SpriteKit

class GameOverScene: SKScene
{
    init(size: CGSize, won: Bool)
    {
        super.init(size: size)
        
        backgroundColor = SKColor.black
        
        let message = "Game Over"
        
        let label = SKLabelNode(fontNamed: "Helvetica Neue")
        label.text = message
        label.fontSize = 20
        label.fontColor = SKColor.white
        label.position = CGPoint(x: size.width/2, y: size.height/2)
        addChild(label)
        run(SKAction.sequence([SKAction.wait(forDuration: 3.0), SKAction.run()
        {
            let scene = GameScene(size: size)
            self.view?.presentScene(scene)
        }]))
        
        let score = Globals.score
        let scoreLabel = SKLabelNode(fontNamed: "Helvetica Neue")
        scoreLabel.fontSize = 10
        scoreLabel.fontColor = SKColor.white
        scoreLabel.text = "score: \(score)"
        scoreLabel.position = CGPoint(x: frame.size.width / 2, y: frame.size.height / 3)
        addChild(scoreLabel)
    }
    
    required init(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
}
