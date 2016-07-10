//
//  GameOverViewController.swift
//  CircumStellar
//
//  Created by Axel Ferreira on 10/07/16.
//  Copyright © 2016 Axel Ferreira. All rights reserved.
//

import Foundation
import SpriteKit

class GameOverScene: SKScene {
    
    
    var restartButton : UIButton!
    var highScore : Int!
    
    override func didMoveToView(view: SKView ) {
       
        scene?.backgroundColor = UIColor.whiteColor()
        
        restartButton = UIButton(frame: CGRect(x: 0, y: 0, width: view.frame.size.width / 2 , height: 40))
        restartButton.center = CGPoint(x: view.frame.size.width / 2 , y: (view.frame.size.height - (view.frame.size.height / 6)))
        restartButton.setTitle("Restart", forState: UIControlState.Normal)
        restartButton.setTitleColor(UIColor.darkGrayColor(), forState: UIControlState.Normal)
        restartButton.addTarget(self, action: #selector(GameOverScene.restart), forControlEvents: UIControlEvents.TouchUpInside )
        self.view?.addSubview(restartButton)
        
        let scoreDefaults = NSUserDefaults.standardUserDefaults()
        let score = scoreDefaults.valueForKey("Score") as! NSInteger
        NSLog("your Score:\(score)")
        
        let highScoreDefaults = NSUserDefaults.standardUserDefaults()
        highScore = highScoreDefaults.valueForKey("highScore") as! NSInteger
        NSLog("your High Score\(highScore)")
        
        // para mostrar o score
        let scoreLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.size.width / 2 , height: 40))
        scoreLabel.center = CGPoint(x: view.frame.size.width / 2 , y: (view.frame.size.height - (view.frame.size.height / 3)))
        scoreLabel.text = "Score : \(score)"
        self.view?.addSubview(scoreLabel)
        
        // para mostrar o record
        let highScoreLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.size.width / 2 , height: 40))
        highScoreLabel.center = CGPoint(x: view.frame.size.width / 2 , y: (view.frame.size.height - (view.frame.size.height / 2)))
        highScoreLabel.text = "Record : \(highScore)"
        self.view?.addSubview(highScoreLabel)
        
        
        let gameOverLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.size.width / 2 , height: 40))
        gameOverLabel.center = CGPoint(x: view.frame.size.width / 2 , y: (view.frame.size.height - 400))
        gameOverLabel.text = "Game Over"
        gameOverLabel.textColor = UIColor.whiteColor()
        gameOverLabel.backgroundColor = UIColor.redColor()
        self.view?.addSubview(gameOverLabel)
    }
    
    
    func restart()  {
        
        self.view?.presentScene(GameScene(), transition: SKTransition.crossFadeWithDuration(0.3))
        restartButton.removeFromSuperview()
        
        
    }
    
    
    
    
    
    
}