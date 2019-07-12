//
//  GameViewController.swift
//  ZombiConga
//
//  Created by admin on 05/06/2019.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            //MainMenuScene(size: CGSize(width: 2048, height: 1536))
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "MainMenuScene")//SKScene(fileNamed: "GameOverScene")
                {
                // Set the scale mode to scale to fit the window
                //scene.scaleMode = .aspectFill
                //ordena en z el orden de los nodos hay que ponerlo a false y configurar los zposition por codigo.
                //si se deja en true, puede que cada vez salga en un orden distinto.
                view.ignoresSiblingOrder = false
                view.showsFPS = true
                view.showsNodeCount = true
                // Present the scene
                view.presentScene(scene)
            
            }

        }
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
