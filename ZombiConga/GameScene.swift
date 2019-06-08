//
//  GameScene.swift
//  ZombiConga
//
//  Created by admin on 05/06/2019.
//  Copyright © 2019 admin. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var zombie1 = SKSpriteNode()
    let fondoImage = SKTexture(imageNamed: "background1")
    let imagenZombie = SKTexture(imageNamed: "zombie1")
    var i: CGFloat = 10.0
    

    
    // se ejecuta cuando se crea la vista.
    override func didMove(to view: SKView) {
        
        addFondoPlaya()
        addZombie()
    }
    
    func addZombie(){
        zombie1 = SKSpriteNode(texture: imagenZombie)
        //definimos el tamaño del zombie con respecto al tamaño de la vista.
        zombie1.scale(to: CGSize(width: frame.size.width * 0.2, height: frame.size.height * 0.2))
        zombie1.position = CGPoint(x: -320, y: 100)
        //los puntos x e y van de 0 a 1
        //zombie1.anchorPoint = CGPoint(x: 0.9, y: 0.9)
        //zombie1.zRotation = CGFloat(Double.pi)/2
        zombie1.zPosition = 0
        addChild(zombie1)
    }
    
    func girarZombie(){
        print(i)
        i -= 0.5
        if i > -10.0 {
            zombie1.zRotation = CGFloat(Double.pi)/i
        }
        else {
            i = 10
            zombie1.zRotation = CGFloat(Double.pi)/i
        }

    }
    
    func addFondoPlaya(){
        //añadir fondo.
        let background = SKSpriteNode(texture: fondoImage)
        //lo escalamos a la misma altura y anchura que la vista principal.
        background.scale(to: CGSize(width: self.frame.width, height: self.frame.height))
        background.zPosition = -1
        addChild(background)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //llamado cuando empieza touch. (antes de levantar el dedo)
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // se llama cada frame.
        //girarZombie()
    }
    
    /*
    
    func touchDown(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.green
            self.addChild(n)
        }
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.blue
            self.addChild(n)
        }
    }
    
    func touchUp(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.red
            self.addChild(n)
        }
    }

    
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    */

}
