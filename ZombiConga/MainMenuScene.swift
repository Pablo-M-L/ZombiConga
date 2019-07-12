//
//  MainMenuScene.swift
//  ZombiConga
//
//  Created by admin on 12/07/2019.
//  Copyright © 2019 admin. All rights reserved.
//

import Foundation
import SpriteKit

class MainMenuScene: SKScene{
    
    
    override func didMove(to view: SKView) {
       let background = SKSpriteNode(imageNamed: "MainMenu")
        background.position = CGPoint(x: frame.midX, y: frame.midY)
        background.scale(to: CGSize(width: self.frame.width, height: self.frame.height))
        
        background.zPosition = -1
        addChild(background)
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let blockAction = SKAction.run { () -> Void in
            let gameScene = GameScene(size: self.size)
            gameScene.scaleMode = self.scaleMode
            let transition =  SKTransition.doorsOpenHorizontal(withDuration: 2)
            self.view?.presentScene(gameScene, transition: transition)
        }
        self.run(blockAction)
    }
    
}
