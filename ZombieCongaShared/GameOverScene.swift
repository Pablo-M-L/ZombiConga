//
//  GameOverScene.swift
//  ZombiConga
//
//  Created by admin on 12/07/2019.
//  Copyright © 2019 admin. All rights reserved.
//

import Foundation
import SpriteKit

class GameOverScene: SKScene{
    
    let hasWon: Bool
    init(size: CGSize, hasWon:Bool){
        self.hasWon = hasWon
        
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init code no ha sido implementado")
    }
    
    override func didMove(to view: SKView) {
        var background: SKSpriteNode

        if(hasWon){
            //si es true es que ha ganado y ponemos el fondo y sonido de ganar.
            background = SKSpriteNode(imageNamed: "YouWin")
            run(SKAction.sequence([SKAction.wait(forDuration: 0.25), SKAction.playSoundFileNamed("win", waitForCompletion: false)]))
        }
        else{
            //si es true es que ha ganado y ponemos el fondo y sonido de ganar.
            background = SKSpriteNode(imageNamed: "YouLose")
            run(SKAction.sequence([SKAction.wait(forDuration: 0.25), SKAction.playSoundFileNamed("lose", waitForCompletion: false)]))
        }
        background.position = CGPoint(x: frame.midX, y: frame.midY)
        background.scale(to: CGSize(width: self.frame.width, height: self.frame.height))
        
        background.zPosition = -1
        addChild(background)
        
        let waitAction = SKAction.wait(forDuration: 4.0)
        let blockAction = SKAction.run { () -> Void in
            let gameScene = MainMenuScene(size: self.size)
            gameScene.scaleMode = self.scaleMode
            let transition =  SKTransition.flipHorizontal(withDuration: 1)
            self.view?.presentScene(gameScene, transition: transition)
        }
        self.run(SKAction.sequence([waitAction,blockAction]))
    }
}
