//
//  GameScene.swift
//  CircumStellar
//
//  Created by Axel Ferreira on 09/07/16.
//  Copyright (c) 2016 Axel Ferreira. All rights reserved.
//



/* TO DO ...
 √ criar variaveis de classe para os varios valores (macros faceis de alterar )
  criar ecra inicial
 √ criar sistema de pontos
  evitar spawn enimigos no limite  <=
 √ eliminar enimigos
  criar multiplos mapas
  criar dificuldade crescente dentro do mapa
  meter Boss
  Criar efeito de fundo estrelas particles
  Criar musica melodica loop 16 BITS (ver tiny wings)
  Acrescentar poderes (ex 2x shooting speed)
  Adicionar multiplas vidas
  adicionar efeito de nave a virar ligeiramente esq e dir
  reset score && icloud sync score
  heatbox transparency
 */



import SpriteKit
//import UIKit
//import Foundation



struct physicsCategory {
    static let enemy : UInt32 = 1
    static let bullet : UInt32 = 2
    static let player : UInt32 = 3
}




class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var scoreLabel = UILabel()
    
    
    // num_enimigos / seg
    var nEnimigosTempo : NSTimeInterval = 1.0
    // vel_enimigos / seg
    var vEnimigosTempo : NSTimeInterval = 3.0
    // num_tiros / seg
    var nTirosTempo : NSTimeInterval = 0.2
    // vel_tiros / seg
    var vTirosTempo : NSTimeInterval = 0.6
    // Player
    var player = SKSpriteNode()
    // Players Array
    var playerArray : [(String, CGFloat)] = [("st6.png", 6),
                                             ("fighterspr1.png", 10),
                                             ("spaceShipIcon.png", 6),
                                             ("fighter-01.png", 10),
                                             ("pizza_slice.png", 3),
                                             ("space_rocket_v4-512.png", 5),
                                             ("F5S4.png", 4)
                                            ]
    //Ammo
    var ammo = SKSpriteNode()
    // Ammo Array
    var ammoArray : [(String, CGFloat)] =   [("grad3.png", 1),
                                             ("Pepperoni.png", 6),
                                             ("", 1)
                                            ]
    //var ammonition = SKSpriteNode(imageNamed: "grad3.png")
    //var ammonition = SKSpriteNode(imageNamed: "Pepperoni.png")
    
    
    
    
    // Vidas
    var lives = Int()
    // Score do player
    var score = Int()
    // Record anterior
    var highScore = Int()
    // Enemy killed
    var enemyKilled = Int()
    // Times Died
    var playerKilled = Int()
    // the Score an enemy type 1 gives
    var sEnemyOne = 5
    
    override func didMoveToView(view: SKView) {
        // obrigatorio para usar SKPhysicsContactDelegate
        physicsWorld.contactDelegate = self
        // vidas iniciais do player
        lives = 0;
        
        
        let highScoreDefault = NSUserDefaults.standardUserDefaults()
        if (highScoreDefault.valueForKey("highScore") != nil ) {
            highScore = highScoreDefault.valueForKey("highScore") as! NSInteger
        }
        else {
            highScore = 0
        }
        
        // Adiciona o efeito de fundo das particulas
        self.addChild(SKEmitterNode(fileNamed: "SnowParticle" )!)
        
        
        // Escolhe a skin do player
        let (pl, sz) = playerArray[0]
        player = SKSpriteNode(imageNamed: pl)
        // Altera o tamanho do player
        player.size.height = player.size.height / sz
        player.size.width = player.size.width / sz
        
        
        // Posição do player
        player.position = CGPointMake(self.size.width/2, self.size.height/8)
        player.physicsBody = SKPhysicsBody(rectangleOfSize: player.size)
        player.physicsBody?.affectedByGravity = false
        player.physicsBody?.categoryBitMask = physicsCategory.player
        player.physicsBody?.contactTestBitMask = physicsCategory.enemy // check contact enemy with player
        player.physicsBody?.dynamic = false
        
        
        _ = NSTimer.scheduledTimerWithTimeInterval(nTirosTempo, target: self, selector: #selector(GameScene.spawnBullets), userInfo: nil, repeats: true)
        
        _ = NSTimer.scheduledTimerWithTimeInterval(nEnimigosTempo, target: self, selector: #selector(GameScene.spawnEnemies), userInfo: nil, repeats: true)
        
        // adicionar o player a view
        self.addChild(player)
        
        scoreLabel.text = "\(score)"
        scoreLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 20 ))
        scoreLabel.backgroundColor = UIColor(colorLiteralRed: 0.1, green: 0.1, blue: 0.1, alpha: 0.7)
        scoreLabel.textColor = UIColor.whiteColor()
        
        self.view?.addSubview(scoreLabel)
        
    }
    
    
    // Funcao que resolve os contactos
    func didBeginContact(contact: SKPhysicsContact) {
        
        let fstBody : SKPhysicsBody = contact.bodyA
        let sndBody : SKPhysicsBody = contact.bodyB
        
        // Enemy collision with Bullet
        if (( fstBody.categoryBitMask == physicsCategory.enemy) && (sndBody.categoryBitMask == physicsCategory.bullet ) ||
            ( fstBody.categoryBitMask == physicsCategory.bullet) && (sndBody.categoryBitMask == physicsCategory.enemy )) {
            
            colisionWithBullet(fstBody.node as! SKSpriteNode, bullet: sndBody.node as! SKSpriteNode)
        
        }
        // Enemy colision with Player
        if (( fstBody.categoryBitMask == physicsCategory.enemy) && (sndBody.categoryBitMask == physicsCategory.player ) ||
            ( fstBody.categoryBitMask == physicsCategory.player) && (sndBody.categoryBitMask == physicsCategory.enemy )) {
            
            colisionWithPlayer(fstBody.node as! SKSpriteNode, player: sndBody.node as! SKSpriteNode)
            
        }
        
        
    }
    
    
    func colisionWithBullet(enemy : SKSpriteNode, bullet : SKSpriteNode){
        enemy.removeFromParent()
        bullet.removeFromParent()
        enemyKilled = enemyKilled + 1
        score = score + sEnemyOne
        
        //NSLog("score:\(score)\n enemies killed:\(enemyKilled)")
        
        scoreLabel.text = "\(score)"
    }
    
    func colisionWithPlayer(enemy : SKSpriteNode, player : SKSpriteNode){
        enemy.removeFromParent()
        player.removeFromParent()
        enemyKilled = enemyKilled + 1
        
        // testar se tem vidas e remover uma, caso contrario Game Over Scene
        if (lives == 0){
            
            let scoreDefaults = NSUserDefaults.standardUserDefaults()
            scoreDefaults.setValue(score, forKey: "Score")
            
            if (self.score > highScore) {
                let highScoreDefaults = NSUserDefaults.standardUserDefaults()
                highScoreDefaults.setValue(self.score, forKey: "highScore")
            }
            
            self.view?.presentScene(GameOverScene())
            self.scoreLabel.removeFromSuperview()
            
        }
        else {
            lives = lives - 1
        }
        
        
    }
    
    
    func spawnBullets() {
        
        // Criar as balas e posicionar por tras do player
        //var bullet = ammonition
        let (am, sz) = ammoArray[1]
        ammo = SKSpriteNode(imageNamed: am)
        // Tamanho da munição
        ammo.size.height = ammo.size.height / sz
        ammo.size.width = ammo.size.width / sz
        
        
        
        ammo.zPosition = -5
        ammo.position = CGPointMake(player.position.x, player.position.y)
        
        // Mover a bala para frente
        let action = SKAction.moveToY(self.size.height + 40, duration: vTirosTempo)
        let actionDone = SKAction.removeFromParent()
        ammo.runAction(SKAction.sequence([action, actionDone]))
        
        // fisicos do jogo
        ammo.physicsBody = SKPhysicsBody(rectangleOfSize: ammo.size)
        ammo.physicsBody?.affectedByGravity = false
        ammo.physicsBody?.categoryBitMask = physicsCategory.bullet
        ammo.physicsBody?.contactTestBitMask = physicsCategory.enemy
        ammo.physicsBody?.dynamic = false
        
        self.addChild(ammo)
        
        
    }
    
    
    
    
    
    // Spawn dos eimigos normais
    func spawnEnemies(){
        // criação do enimigo tipo 1 & rotação & dimensão
        let enemy = SKSpriteNode(imageNamed: "ship3.png")
        enemy.zRotation = CGFloat(M_PI)
        enemy.size.height = enemy.size.height / 8
        enemy.size.width = enemy.size.width / 8
        
        // randomize da posição x para spwan
        let xPos = randomBetweenNumbers(0, secondNum: frame.width )
        
        enemy.position = CGPoint(x: xPos, y: self.size.height + 20)
        
        let action = SKAction.moveToY(-40, duration: vEnimigosTempo)
        let actionDone = SKAction.removeFromParent()
        enemy.runAction(SKAction.sequence([action, actionDone]))
        
        // Fisicos do jogo
        enemy.physicsBody = SKPhysicsBody(rectangleOfSize: enemy.size)
        enemy.physicsBody?.affectedByGravity = false
        enemy.physicsBody?.categoryBitMask = physicsCategory.enemy
        enemy.physicsBody?.contactTestBitMask = physicsCategory.bullet
        enemy.physicsBody?.dynamic = true
        
        
        self.addChild(enemy)
        
    }
    
    
    // funcao que gera um random para spawn
    func randomBetweenNumbers(firstNum: CGFloat, secondNum: CGFloat) -> CGFloat{
        return CGFloat(arc4random()) / CGFloat(UINT32_MAX) * abs(firstNum - secondNum) + min(firstNum, secondNum)
    }
    
    
    // permite mover o jogador progressivamente
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            let location = touch.locationInNode(self)
            
            player.position.x = location.x
            
        }
    }
    
    // permite mover o jogador para o local tocado
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
        
        for touch in touches {
            let location = touch.locationInNode(self)
            
            
            player.position.x = location.x
           
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
    
    
    
    
    
}
