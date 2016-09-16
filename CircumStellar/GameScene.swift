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
 √ evitar spawn enimigos no limite  <= tamanho da janela especificado no GameViewController
 √ eliminar enimigos
  criar multiplos mapas
  criar dificuldade crescente dentro do mapa
  meter Boss
 √ Criar efeito de fundo estrelas particles
  Criar musica melodica loop 16 BITS (ver tiny wings)
  Acrescentar poderes (ex 2x shooting speed)
 √ Adicionar multiplas vidas
  adicionar efeito de nave a virar ligeiramente esq e dir
  reset score && icloud sync score
  heatbox transparency
  criar trajetorias diferentes para enimigos
  criar enimigos de outros tipos.
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
    var nEnimigosTempo : TimeInterval = 1.0
    // vel_enimigos / seg
    var vEnimigosTempo : TimeInterval = 3.0
    // num_tiros / seg
    var nTirosTempo : TimeInterval = 0.2
    // vel_tiros / seg
    var vTirosTempo : TimeInterval = 0.6
    // Player
    var player = SKSpriteNode()
    // Player Skinn Atual
    var playerSkinIndex : Int = 4
    // Player Skin Array
    var playerArray : [(String, CGFloat)] = [("st6.png", 6),
                                             ("fighterspr1.png", 10),
                                             ("spaceShipIcon.png", 6),
                                             ("fighter-01.png", 10),
                                             ("pizza_slice.png", 4),
                                             ("space_rocket_v4-512.png", 5),
                                             ("F5S4.png", 4)
                                            ]
    // Ammo
    var ammo = SKSpriteNode()
    // Player Shooting Mode
    var ammoMode : Int = 1
    // Player Ammo Atual
    var playerAmmoIndex : Int = 1
    // Ammo Skin Array
    var ammoArray : [(String, CGFloat)] =   [("grad3.png", 1),
                                             ("Pepperoni.png", 10),
                                             ("", 1)
                                            ]

    // Enemy
    var enemy = SKSpriteNode()
    // Enemy Skin
    var enemySkinIndex : Int = 0
    // Enemy Skin Array
    var enemyArray : [(String, CGFloat)] = [("ship3.png", 1.5),
                                            ("cartoonship blue.png", 2),
                                            ("",1),
                                            ("",1),
                                            ("",1),
                                           ]
    
    
    
    
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
    
    override func didMove(to view: SKView) {
        // obrigatorio para usar SKPhysicsContactDelegate
        physicsWorld.contactDelegate = self
        // vidas iniciais do player
        lives = 3;

        
        let highScoreDefault = UserDefaults.standard
        if (highScoreDefault.value(forKey: "highScore") != nil ) {
            highScore = highScoreDefault.value(forKey: "highScore") as! NSInteger
        }
        else {
            highScore = 0
        }
        
        // Adiciona o efeito de fundo das particulas
        self.addChild(SKEmitterNode(fileNamed: "SnowParticle" )!)
        
        
        // Escolhe a skin do player
        let (pl, sz) = playerArray[playerSkinIndex]
        player = SKSpriteNode(imageNamed: pl)
        // Altera o tamanho do player
        player.size.height = player.size.height / sz
        player.size.width = player.size.width / sz
        
        
        // Posição do player
        player.position = CGPoint(x: self.size.width/2, y: self.size.height/8)
        player.physicsBody = SKPhysicsBody(rectangleOf: player.size)
        player.physicsBody?.affectedByGravity = false
        player.physicsBody?.categoryBitMask = physicsCategory.player
        player.physicsBody?.contactTestBitMask = physicsCategory.enemy // check contact enemy with player
        player.physicsBody?.isDynamic = false
        
        
        _ = Timer.scheduledTimer(timeInterval: nTirosTempo, target: self, selector: #selector(GameScene.spawnBullets), userInfo: nil, repeats: true)
        
        _ = Timer.scheduledTimer(timeInterval: nEnimigosTempo, target: self, selector: #selector(GameScene.spawnEnemies), userInfo: nil, repeats: true)
        
        // adicionar o player a view
        self.addChild(player)
        
        scoreLabel.text = "\(score)"
        scoreLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 20 ))
        scoreLabel.backgroundColor = UIColor(colorLiteralRed: 0.1, green: 0.1, blue: 0.1, alpha: 0.7)
        scoreLabel.textColor = UIColor.white
        
        self.view?.addSubview(scoreLabel)
        

        print("janela", self.size.width, self.size.height, "\n")
        
    }
    
    
    // Funcao que resolve os contactos
    func didBegin(_ contact: SKPhysicsContact) {
        
        let fstBody : SKPhysicsBody = contact.bodyA
        let sndBody : SKPhysicsBody = contact.bodyB
        
        // Enemy collision with Bullet
        if ( fstBody.categoryBitMask == physicsCategory.enemy) && (sndBody.categoryBitMask == physicsCategory.bullet ) {
            colisionWithBullet(fstBody.node as! SKSpriteNode, bullet: sndBody.node as! SKSpriteNode)
        } else if ( fstBody.categoryBitMask == physicsCategory.bullet) && (sndBody.categoryBitMask == physicsCategory.enemy ) {
            colisionWithBullet(sndBody.node as! SKSpriteNode, bullet: fstBody.node as! SKSpriteNode)
        }
        // Enemy colision with Player
        if ( fstBody.categoryBitMask == physicsCategory.enemy) && (sndBody.categoryBitMask == physicsCategory.player ) {
            colisionWithPlayer(fstBody.node as! SKSpriteNode, player: sndBody.node as! SKSpriteNode)
        } else if ( fstBody.categoryBitMask == physicsCategory.player) && (sndBody.categoryBitMask == physicsCategory.enemy ) {
            colisionWithPlayer(sndBody.node as! SKSpriteNode, player: fstBody.node as! SKSpriteNode)
        }
        
        
    }
    
    
    func colisionWithBullet(_ enemy : SKSpriteNode, bullet : SKSpriteNode){
        //bullet.hidden = true
        //enemy.hidden = true
        bullet.removeFromParent()
        enemy.removeFromParent()
        enemyKilled = enemyKilled + 1
        score = score + sEnemyOne
        
        //NSLog("score:\(score)\n enemies killed:\(enemyKilled)")
        
        scoreLabel.text = "\(score)"
    }
    
    func colisionWithPlayer(_ enemy : SKSpriteNode, player : SKSpriteNode){
        //player.removeFromParent()
        enemy.removeFromParent()
        enemyKilled = enemyKilled + 1
        
        // testar se tem vidas e remover uma, caso contrario Game Over Scene
        if (lives == 0){
            
            let scoreDefaults = UserDefaults.standard
            scoreDefaults.setValue(score, forKey: "Score")
            
            if (self.score > highScore) {
                let highScoreDefaults = UserDefaults.standard
                highScoreDefaults.setValue(self.score, forKey: "highScore")
            }
            
            self.removeAllActions()
            self.removeAllChildren()
            self.scoreLabel.removeFromSuperview()
            self.view?.presentScene(GameOverScene())
            
            
        }
        else {
            lives = lives - 1
        }
        
        
    }
    
    
    func spawnBullets() {
        
        // Criar as balas e posicionar por tras do player
        //var bullet = ammonition
        let (am, sz) = ammoArray[playerAmmoIndex]
        ammo = SKSpriteNode(imageNamed: am)
        // Tamanho da munição
        ammo.size.height = ammo.size.height / sz
        ammo.size.width = ammo.size.width / sz
        
        // posição correta
        ammo.zPosition = 0
        if (ammoMode == 1) {
            
            // Coordenadas da ammo
            ammo.position = CGPoint(x: player.position.x, y: player.position.y)
            
            // Mover a bala para frente
            let action = SKAction.moveTo(y: self.size.height + 40, duration: vTirosTempo)
            let actionDone = SKAction.removeFromParent()
            ammo.run(SKAction.sequence([action, actionDone]))
            
            // fisicos do jogo
            ammo.physicsBody = SKPhysicsBody(rectangleOf: ammo.size)
            ammo.physicsBody?.affectedByGravity = false
            ammo.physicsBody?.categoryBitMask = physicsCategory.bullet
            ammo.physicsBody?.contactTestBitMask = physicsCategory.enemy
            ammo.physicsBody?.isDynamic = false
            
            self.addChild(ammo)
        }
        else if (ammoMode == 2) {
            let ammo2 = SKSpriteNode(imageNamed: am)
            //Tamanho da munição
            ammo2.size.height = ammo2.size.height / sz
            ammo2.size.width = ammo2.size.width / sz
            ammo2.zPosition = 0
            
            ammo2.position = CGPoint(x: player.position.x - 10, y: player.position.y)
            ammo.position = CGPoint(x: player.position.x + 10, y: player.position.y)
            
            // Mover a bala para frente
            let action = SKAction.moveTo(y: self.size.height + 40, duration: vTirosTempo)
            let actionDone = SKAction.removeFromParent()
            ammo.run(SKAction.sequence([action, actionDone]))
            ammo2.run(SKAction.sequence([action, actionDone]))
            
            // fisicos do jogo
            ammo.physicsBody = SKPhysicsBody(rectangleOf: ammo.size)
            ammo.physicsBody?.affectedByGravity = false
            ammo.physicsBody?.categoryBitMask = physicsCategory.bullet
            ammo.physicsBody?.contactTestBitMask = physicsCategory.enemy
            ammo.physicsBody?.isDynamic = false
            ammo2.physicsBody = SKPhysicsBody(rectangleOf: ammo.size)
            ammo2.physicsBody?.affectedByGravity = false
            ammo2.physicsBody?.categoryBitMask = physicsCategory.bullet
            ammo2.physicsBody?.contactTestBitMask = physicsCategory.enemy
            ammo2.physicsBody?.isDynamic = false
            
            self.addChild(ammo)
            self.addChild(ammo2)
        }
        else if (ammoMode == 3) {
            let ammo2 = ammo
            let ammo3 = ammo
            ammo.position = CGPoint(x: player.position.x, y: player.position.y)
            ammo2.position = CGPoint(x: player.position.x + 10, y: player.position.y)
            ammo3.position = CGPoint(x: player.position.x - 10, y: player.position.y)
            
            // Mover a bala para frente
            let action = SKAction.moveTo(y: self.size.height + 40, duration: vTirosTempo)
            let actionDone = SKAction.removeFromParent()
            ammo.run(SKAction.sequence([action, actionDone]))
            ammo2.run(SKAction.sequence([action, actionDone]))
            ammo3.run(SKAction.sequence([action, actionDone]))
            
            // fisicos do jogo
            ammo.physicsBody = SKPhysicsBody(rectangleOf: ammo.size)
            ammo.physicsBody?.affectedByGravity = false
            ammo.physicsBody?.categoryBitMask = physicsCategory.bullet
            ammo.physicsBody?.contactTestBitMask = physicsCategory.enemy
            ammo.physicsBody?.isDynamic = false
            ammo2.physicsBody = SKPhysicsBody(rectangleOf: ammo.size)
            ammo2.physicsBody?.affectedByGravity = false
            ammo2.physicsBody?.categoryBitMask = physicsCategory.bullet
            ammo2.physicsBody?.contactTestBitMask = physicsCategory.enemy
            ammo2.physicsBody?.isDynamic = false
            ammo3.physicsBody = SKPhysicsBody(rectangleOf: ammo.size)
            ammo3.physicsBody?.affectedByGravity = false
            ammo3.physicsBody?.categoryBitMask = physicsCategory.bullet
            ammo3.physicsBody?.contactTestBitMask = physicsCategory.enemy
            ammo3.physicsBody?.isDynamic = false
            
            self.addChild(ammo)
            self.addChild(ammo2)
            self.addChild(ammo3)
        }

        
    }
    
    
    
    
    
    // Spawn dos eimigos normais
    func spawnEnemies(){
        // criação do enimigo tipo 1 & rotação & dimensão
        let (en,sz) = enemyArray[enemySkinIndex]
        enemy = SKSpriteNode(imageNamed: en)
        // Tamanho do enimigo
        enemy.size.height = enemy.size.height / sz
        enemy.size.width = enemy.size.width / sz
        // Rotação do enimigo a 90º
        enemy.zRotation = CGFloat(M_PI)
        enemy.size.height = enemy.size.height / 8
        enemy.size.width = enemy.size.width / 8
        
        // randomize da posição x para spwan (1024.0 - 768.0)
        let xPos = randomBetweenNumbers(0, secondNum: frame.width )
        enemy.position = CGPoint(x: xPos, y: self.size.height + 20)
        
        
        // Acao de mover o enimigo para baixo
        let action = SKAction.moveTo(y: -40, duration: vEnimigosTempo)
        let actionDone = SKAction.removeFromParent()
        enemy.run(SKAction.sequence([action, actionDone]))
        
        // Fisicos do jogo
        enemy.physicsBody = SKPhysicsBody(rectangleOf: enemy.size)
        enemy.physicsBody?.affectedByGravity = false
        enemy.physicsBody?.categoryBitMask = physicsCategory.enemy
        enemy.physicsBody?.contactTestBitMask = physicsCategory.bullet
        enemy.physicsBody?.isDynamic = true
        
        
        self.addChild(enemy)
        
    }
    
    
    // funcao que gera um random para spawn
    func randomBetweenNumbers(_ firstNum: CGFloat, secondNum: CGFloat) -> CGFloat{
        return CGFloat(arc4random()) / CGFloat(UINT32_MAX) * abs(firstNum - secondNum) + min(firstNum, secondNum)
    }
    
    
    // permite mover o jogador progressivamente
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            
            player.position.x = location.x
            
        }
    }
    
    // permite mover o jogador para o local tocado
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
       /* Called when a touch begins */
        
        for touch in touches {
            let location = touch.location(in: self)
            
            
            player.position.x = location.x
           
        }
    }
   
    override func update(_ currentTime: TimeInterval) {
        /* Called before each frame is rendered */
    }
    
    
    
    
    
}
