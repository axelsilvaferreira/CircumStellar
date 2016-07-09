//
//  GameScene.swift
//  CircumStellar
//
//  Created by Axel Ferreira on 09/07/16.
//  Copyright (c) 2016 Axel Ferreira. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    
    // Player
    //var player = SKSpriteNode(imageNamed: "space_rocket_v4-512.png")
    var player = SKSpriteNode(imageNamed: "fighterspr1.png")
    
    
    
    override func didMoveToView(view: SKView) {
        // Tamanho do player
        player.size.height = player.size.height / 4
        player.size.width = player.size.width / 4
        // Posição do player
        player.position = CGPointMake(self.size.width/2, self.size.height/8)
        
        
        
        // adicionar o player a view
        self.addChild(player)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
        
        for touch in touches {
            let location = touch.locationInNode(self)
            
           
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
    
    
    
    
    
}
