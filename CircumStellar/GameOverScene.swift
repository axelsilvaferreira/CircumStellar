//
//  GameOverViewController.swift
//  CircumStellar
//
//  Created by Axel Ferreira on 10/07/16.
//  Copyright © 2016 Axel Ferreira. All rights reserved.
//

import Foundation
import SpriteKit

class GameOverScene: SKScene, SKPhysicsContactDelegate {
    
    
    var restartButton : UIButton!
    var highScore : Int!
    var scoreLabel : UILabel!
    var highScoreLabel : UILabel!
    var gameOverLabel : UILabel!
    
    override func didMove(to view: SKView ) {
       
        physicsWorld.contactDelegate = self
        
        //self.addChild(SKEmitterNode(fileNamed: "SnowParticle" )!)
        
        scene?.backgroundColor = UIColor(red: 0.01, green: 0.01, blue: 0.02, alpha: 0.7)
        
        restartButton = UIButton(frame: CGRect(x: 0, y: 0, width: view.frame.size.width / 2 , height: 40))
        restartButton.center = CGPoint(x: view.frame.size.width / 2 , y: (view.frame.size.height - (view.frame.size.height / 6)))
        restartButton.setTitle("Restart", for: UIControlState())
        restartButton.setTitleColor(UIColor.white, for: UIControlState())
        restartButton.addTarget(self, action: #selector(GameOverScene.restart), for: UIControlEvents.touchUpInside )
        self.view?.addSubview(restartButton)
        
        let scoreDefaults = UserDefaults.standard
        let score = scoreDefaults.value(forKey: "Score") as! NSInteger
        NSLog("your Score:\(score)")
        
        let highScoreDefaults = UserDefaults.standard
        highScore = highScoreDefaults.value(forKey: "highScore") as! NSInteger
        NSLog("your High Score\(highScore)")
        
        // para mostrar o score
        scoreLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.size.width / 2 , height: 40))
        scoreLabel.center = CGPoint(x: view.frame.size.width / 2 , y: (view.frame.size.height - (view.frame.size.height / 3)))
        scoreLabel.text = "Score : \(score)"
        scoreLabel.backgroundColor = UIColor.black
        scoreLabel.textColor = UIColor.white
        scoreLabel.textAlignment = NSTextAlignment(rawValue: 1)!
        self.view?.addSubview(scoreLabel)
        
        // para mostrar o record
        highScoreLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.size.width / 2 , height: 40))
        highScoreLabel.center = CGPoint(x: view.frame.size.width / 2 , y: (view.frame.size.height - (view.frame.size.height / 2)))
        highScoreLabel.text = "Record : \(highScore)"
        highScoreLabel.backgroundColor = UIColor.black
        highScoreLabel.textColor = UIColor.white
        highScoreLabel.textAlignment = NSTextAlignment(rawValue: 1)!
        self.view?.addSubview(highScoreLabel)
        
        // para mostrar GAME OVER
        gameOverLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.size.width / 3 , height: 40))
        gameOverLabel.center = CGPoint(x: view.frame.size.width / 2 , y: (view.frame.size.height - 450))
        gameOverLabel.text = "Game Over"
        gameOverLabel.textAlignment = NSTextAlignment(rawValue: 1)!
        gameOverLabel.textColor = UIColor.white
        gameOverLabel.backgroundColor = UIColor.black
        self.view?.addSubview(gameOverLabel)
        
        
    }
    
    
    func restart()  {
        
        self.view?.presentScene(GameScene() ) //Scene(GameScene(), transition: SKTransition.crossFadeWithDuration(0.3))
        restartButton.removeFromSuperview()
        highScoreLabel.removeFromSuperview()
        scoreLabel.removeFromSuperview()
        gameOverLabel.removeFromSuperview()
        
    }
    
    
    
    
    
    
}
