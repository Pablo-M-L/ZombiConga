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
    let fondoImage2 = SKTexture(imageNamed: "background2")

    let imagenZombie = SKTexture(imageNamed: "zombie1")
    var zombieAnimation: SKAction = SKAction()
    var isInvincible = false
    let imagenEnemigo = SKTexture(imageNamed: "enemy")
    let imagenGato = SKTexture(imageNamed: "cat")

    var i: CGFloat = 10.0
    
    var lastUpdateTime : TimeInterval = 0 //tiene el control de cuando ha sido la ultima vez que hemos actualizado la pantalla en le metodo update.
    var dt: TimeInterval = 0 //Delta time (diferencia de tiempo) desde la ultima acutalizacion.
    
    let backgroundPixelPerSeconds: CGFloat = 100.0
    let catPixelPerSeconds: CGFloat = 220.0
    let zombiePixelPerSecond: CGFloat = 200.0 //movimiento lineal.
    let zombieAnglePerSecond: CGFloat = 2.5 * π // una vuelta son 2 * π

    var velocity = CGPoint(x: 0, y: 0) //vector de movimiento

    var lastTouchLocation = CGPoint.zero
    
    let catSound = SKAction.playSoundFileNamed("hitCat", waitForCompletion: false)
    let enemySound = SKAction.playSoundFileNamed("hitCatLady", waitForCompletion: false)
    
    var zombieLifes = 50
    var isGameOver = false
    var congaCount = 0
    let objective = 25
    
    let backgroundLayer = SKNode()
    
    let livesLabel: SKLabelNode
    let catsLabel: SKLabelNode
    
    override init(size: CGSize) {
        livesLabel = SKLabelNode(fontNamed: "Copperplate")
        catsLabel = SKLabelNode(fontNamed: "Copperplate")
        
        
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init code no ha sido implementado")

    }
    
    // se ejecuta cuando se crea la vista.
    override func didMove(to view: SKView) {

        var zombieTextures:[SKTexture] = []
        for i in 1...4{
            zombieTextures.append(SKTexture(imageNamed: "zombie\(i)"))
        }
        zombieTextures.append(zombieTextures[2])
        zombieTextures.append(zombieTextures[1])
        
        zombieAnimation = SKAction.repeatForever(SKAction.animate(with: zombieTextures, timePerFrame: 0.15))
        backgroundLayer.zPosition = -2
        addChild(backgroundLayer)
        
        addFondoPlaya()
        addZombie()
        //spawnEnemy()
        //saca enemigos aleatoriamente, de forma continua y esperando 3 segundos.
        run(SKAction.repeatForever(
            SKAction.sequence( [SKAction.run(spawnEnemy), SKAction.wait(forDuration: 2.0)] )
            )
        )

        run(SKAction.repeatForever(
            SKAction.sequence( [SKAction.run(spawnCat), SKAction.wait(forDuration: 1.5)] )
            )
        )
        
        playBackgroundMusic(fileName: "backgroundMusic.mp3")
        
        //HUD
        livesLabel.position = CGPoint(x: frame.minX, y: frame.maxY)
        livesLabel.fontSize = 42
        livesLabel.fontColor = UIColor.red
        livesLabel.verticalAlignmentMode = .top
        livesLabel.horizontalAlignmentMode = .left
        addChild(livesLabel)
        
        catsLabel.position = CGPoint(x: frame.maxX, y: frame.maxY)
        catsLabel.fontSize = 42
        catsLabel.fontColor = UIColor.red
        catsLabel.verticalAlignmentMode = .top
        catsLabel.horizontalAlignmentMode = .right
        addChild(catsLabel)
        
        updateHud()
        
    }
    
    func addZombie(){
        zombie1 = SKSpriteNode(texture: imagenZombie)
        zombie1.name = "zombie"
        //definimos el tamaño del zombie con respecto al tamaño de la vista.
        zombie1.scale(to: CGSize(width: frame.size.width * 0.12, height: frame.size.height * 0.13))
        zombie1.position = CGPoint(x: 450 , y: 150)

        //los puntos x e y van de 0 a 1
        //zombie1.anchorPoint = CGPoint(x: 0.9, y: 0.9)
        //zombie1.zRotation = CGFloat(Double.pi)/2
        zombie1.zPosition = 10
        backgroundLayer.addChild(zombie1)
    }
    
    func updateHud(){
        livesLabel.text = "Vidas: \(zombieLifes)"
        catsLabel.text = "Objetivo: \(congaCount) // \(objective)"
    }
    
    func animatedZombie(){
        if zombie1.action(forKey: "animation") == nil{
            zombie1.run(SKAction.repeatForever(zombieAnimation), withKey: "animation")
        }
    }
    
    func stopZombie(){
        zombie1.removeAction(forKey: "animation")
    }
    
    func girarZombie(){
        i -= 0.5
        if i > -10.0 {
            zombie1.zRotation = CGFloat(Double.pi)/i
        }
        else {
            i = 10
            zombie1.zRotation = CGFloat(Double.pi)/i
        }

    }
    
    //colisiones
    func checkCollisions(){
        //colision con gatos
        var hitCats: [SKSpriteNode] = []
        
        backgroundLayer.enumerateChildNodes(withName: "gato") { node, _  in
            let cat = node as! SKSpriteNode
            if cat.intersects(self.zombie1){
                hitCats.append(cat)
            }
        }
        for cat in hitCats{
            zombieHitsCat(cat: cat)
        }

        if self.isInvincible{
            return
        }
        //colision con enemigo
        var hitEnemys: [SKSpriteNode] = []
        
        backgroundLayer.enumerateChildNodes(withName: "enemy") { node, _  in
            let enemy = node as! SKSpriteNode
            if enemy.intersects(self.zombie1){
                hitEnemys.append(enemy)
            }
        }
        for enemy in hitEnemys{
            zombieHitsEnemy(enemy: enemy)
        }
        
    }
    
    func zombieHitsCat(cat: SKSpriteNode){
        run(catSound)
        congaCount += 1
        updateHud()
        
        cat.name = "conga"
        cat.removeAllActions()
        cat.zRotation = 0
        cat.setScale(0.2)
        let greenCat = SKAction.colorize(with: SKColor.green, colorBlendFactor: 1.0, duration: 0.5)
        cat.run(greenCat)

    }
    
    func zombieHitsEnemy(enemy: SKSpriteNode){
        run(enemySound)
        loseCats()
        switch congaCount {
        case 0...3:
            congaCount = 0
        default:
            congaCount -= 3
        }
        
        zombieLifes -= 1
        updateHud()
        isInvincible = true
        let blinkTimes = 12.0 //parpadeos
        let blinkDuration = 4.0
        let blinkAction = SKAction.customAction(withDuration: blinkDuration) { (node, elapsedTime) in
            //elapsedTime es tiempo transcurrido de la animacion
            let slice = blinkDuration / blinkTimes //duracion de cada parpadeo
            let remainer = Double(elapsedTime).truncatingRemainder(dividingBy: slice)
            node.isHidden = remainer > slice / 2
        }
        
        let setHiden = SKAction.run {
            self.zombie1.isHidden = false
            self.isInvincible = false
        }
        
        zombie1.run(SKAction.sequence([blinkAction, setHiden]))

    }
    
    func backgroudNode()-> SKSpriteNode{
        
        let background = SKSpriteNode()
        //background.anchorPoint = CGPoint.zero
        background.name = "background"
        
        let background1 = SKSpriteNode(texture: fondoImage)
        //lo escalamos a la misma altura y anchura que la vista principal.
        background1.anchorPoint = CGPoint.zero
        background1.position = CGPoint(x: frame.minX, y: frame.minY)
        background1.scale(to: CGSize(width: self.frame.width * 2, height: self.frame.height))
        background1.zPosition = -1
        background.addChild(background1)
        
        let background2 = SKSpriteNode(texture: fondoImage2)
        background2.anchorPoint = CGPoint.zero
        //lo escalamos a la misma altura y anchura que la vista principal.
        background2.position = CGPoint(x: background1.size.width, y: frame.minY)
        background2.scale(to: CGSize(width: self.frame.width * 2, height: self.frame.height))
        background2.zPosition = -1
        background.addChild(background2)
        
        background.size = CGSize(width: background1.size.width + background2.size.width, height: background1.size.height)
        
        return background
    }
    
    func addFondoPlaya(){
        //añadir fondo.
        for i in 0...1{
        let background = backgroudNode()
        //lo escalamos a la misma altura y anchura que la vista principal.
        //background.anchorPoint = CGPoint.zero
        //background.position = CGPoint(x: frame.minX, y: frame.minY)
        background.position = CGPoint(x: CGFloat(i)*(background.size.width/2), y: 0.0)
        background.scale(to: CGSize(width: self.frame.width * 2, height: self.frame.height))
        background.zPosition = -1
        background.name = "background"

        backgroundLayer.addChild(background)
            
        }
    }

    func moveBackground(){
        let velocity = CGPoint(x: -self.backgroundPixelPerSeconds, y: 0.0)
        let amountToMove = velocity * CGFloat(self.dt)
        backgroundLayer.position += amountToMove
        
        backgroundLayer.enumerateChildNodes(withName: "background") { (node, _) in
            let background = node as! SKSpriteNode
            
            let backgroundLayerPosition = self.backgroundLayer.convert(background.position, to: self)
            //cuando el background1 sale de la pantalla lo pasa detras del bacground2
            if backgroundLayerPosition.x <= -background.size.width{
                background.position = CGPoint(x: background.position.x + 2.0 * background.size.width, y: 0.0)
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // se llama cada frame.
    
        //calcula el tiempo pasado entre frames.
        if lastUpdateTime > 0{
            dt = currentTime - lastUpdateTime
        }
        else{
            dt = 0
        }
        lastUpdateTime = currentTime
        
        //print("la ultima actualizacion ha sido hace \(dt*1000) milisegundos")
        //calcular el movimiento segun el tiempo que ha pasado entre frames, para que siempre se mueva igual independientemente de los fps.
         //zombie1.position = CGPoint(x: zombie1.position.x+5, y: zombie1.position.y)
        //moveSprite(sprite: zombie1, velocity: velocity)
        checkBounds()
        //rotateSprite(sprite: zombie1, direction: velocity)
        //si la posicion del zombie menos donde debe moverse, es menor que lo que tiene que moverse el zombie
        //en ese intervalo de tiempo, pasamos la velocidad a 0 para que pare.
        
        if (zombie1.position - lastTouchLocation).lenght() < zombiePixelPerSecond * CGFloat(dt){
            velocity = CGPoint.zero
            stopZombie()
        }
        else{
            moveSprite(sprite: zombie1, velocity: velocity)
            if velocity != CGPoint.zero{
                rotateSprite(sprite: zombie1, direction: velocity)
            }
        }
 
        
        //moveSprite(sprite: zombie1, velocity: velocity)
        //rotateSprite(sprite: zombie1, direction: velocity)
            
        moveConga()
        moveBackground()
        
        if zombieLifes <= 0 && !isGameOver{
            bacgroundAudioPlayer.stop()
            isGameOver = true
            let gameOverScene = GameOverScene(size: size, hasWon: false)
            gameOverScene.scaleMode = scaleMode
            
            let transition = SKTransition.flipVertical(withDuration: 1.0)
            view?.presentScene(gameOverScene, transition: transition)
        }
        
        if congaCount >= objective && !isGameOver{
            bacgroundAudioPlayer.stop()
            isGameOver = true
            let gameOverScene = GameOverScene(size: size, hasWon: true)
            gameOverScene.scaleMode = scaleMode
            
            let transition = SKTransition.flipVertical(withDuration: 1.0)
            view?.presentScene(gameOverScene, transition: transition)

        }
        
        
        
    }
    
    func moveZombieToLocation(location: CGPoint){
        /*
        //cantidad de movimiento que hay que incrementar al zombie para que llegue donde hemos tocado (flecha naranja)
        let offset = CGPoint(x: location.x - zombie1.position.x, y: location.y - zombie1.position.y)
        //teorema de pitagoras para calcular lo que mide offset.
        let offsetLength = sqrt(Double((offset.x * offset.x) + (offset.y * offset.y)))
        //calcular vector unitario de movimiento.
        let direction = CGPoint(x: offset.x/CGFloat(offsetLength), y: offset.y/CGFloat(offsetLength))
        //calculamos la velocidad multiplicamos la direccion por los pixeles por segundo que se mueve el sprite.
        velocity = CGPoint(x: direction.x * zombiePixelPerSecond, y: direction.y * zombiePixelPerSecond)
        */
        
        //cantidad de movimiento que hay que incrementar al zombie para que llegue donde hemos tocado (flecha naranja)
        animatedZombie()
        let offset = location - zombie1.position
        let direction = offset.normalize() //vector unitario de movimiento.
        velocity = direction * zombiePixelPerSecond
        
    }
    
    func moveSprite(sprite:SKSpriteNode, velocity: CGPoint){
        //S = V*t -- espacio = velocidad * tiempo
        //let amount = CGPoint(x: velocity.x * CGFloat(dt), y: velocity.y * CGFloat(dt))
        //print("la cantida que tenemos que mover el sprite es \(amount)")
        //sprite.position = CGPoint(x: sprite.position.x + amount.x, y: sprite.position.y + amount.y)
    
        let amount = velocity * CGFloat(dt)
        sprite.position += amount
        
        
        
        
    }
    
    //funciones para detectar toques en pantalla, el usuario puede hacer un toque
    //o deslizar el dedo por la pantalla.
    
    func sceneTouched(touchLocation: CGPoint){
        lastTouchLocation = touchLocation
        moveZombieToLocation(location: touchLocation)
    }
    /*
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //llamado cuando empieza touch. (antes de levantar el dedo)
        let touch = touches.first! as UITouch
        let location = touch.location(in: backgroundLayer)
        sceneTouched(touchLocation: location)
    }
    */
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first! as UITouch
        let location = touch.location(in: backgroundLayer)
        sceneTouched(touchLocation: location)
    }
    
    //detecta los limites de la pantalla.
    func checkBounds(){
        //coordenadas de pantalla
        /*
        let boundLetf = frame.minX + zombie1.size.width/2.5
        let boundRight = frame.maxX - zombie1.size.width/2.5
        let boundTop = frame.minY + zombie1.size.height/2
        let boundBottom = frame.maxY - zombie1.size.height/2
        */
        //coordenadas de capa fondo
        
        let boundLetfFrame = CGPoint(x: frame.minX + zombie1.size.width/2.5, y: 0.0)
        let boundRightFrame = CGPoint(x: frame.maxX - zombie1.size.width/2.5, y: 0.0)
        let boundTopFrame = CGPoint(x: 0.0, y: frame.minY + zombie1.size.height/2)
        let boundBottomFrame = CGPoint(x: 0.0, y: frame.maxY - zombie1.size.height/2)
        let boundLetf = backgroundLayer.convert(boundLetfFrame, from: self)
        let boundRight = backgroundLayer.convert(boundRightFrame, from: self)
        let boundTop = backgroundLayer.convert(boundTopFrame, from: self)
        let boundBottom = backgroundLayer.convert(boundBottomFrame, from: self)
 

        if zombie1.position.x <= boundLetf.x{
            zombie1.position.x = boundLetf.x
            velocity.x = -velocity.x
        }
        if zombie1.position.x >= boundRight.x{

            zombie1.position.x = boundRight.x
            velocity.x = -velocity.x
        }
        if zombie1.position.y <= boundTop.y{
            zombie1.position.y = boundTop.y
            velocity.y = -velocity.y
        }
        if zombie1.position.y >= boundBottom.y{
            zombie1.position.y = boundBottom.y
            velocity.y = -velocity.y
        }

        
    }
    
    func rotateSprite(sprite: SKSpriteNode, direction: CGPoint){
        //sprite.zRotation = CGFloat(atan2(Double(direction.y), Double(direction.x)))
        let shortesAngle = shortesAngleBetween(angle1: sprite.zRotation, angle2: velocity.angle)
        let amountToRotate = min(zombieAnglePerSecond * CGFloat(dt), abs(shortesAngle))
        //sprite.zRotation = direction.angle
        sprite.zRotation += amountToRotate * shortesAngle.sign()
    }
    
    func spawnEnemy(){
        let enemy = SKSpriteNode(texture: imagenEnemigo)
        enemy.name = "enemy"
        enemy.scale(to: CGSize(width: frame.size.width * 0.12, height: frame.size.height * 0.12))
        //con referencia a coordenadas frame
        //let posAleatoriaY = CGFloat.random(min: frame.minY + enemy.size.height/2, max: frame.maxY - enemy.size.height/2)
        
        //con referencia a coordenadas bacgroungLayer
        
        let posicionMinimaEnElFrame = CGPoint(x: frame.minX + enemy.size.height/2, y: frame.minY + enemy.size.height/2)
        let posicionMaximaEnElFrame = CGPoint(x: frame.maxX - enemy.size.height/2, y: frame.maxY - enemy.size.height/2)
        let posicionMinimaConvertida = self.backgroundLayer.convert(posicionMinimaEnElFrame, from: self)
        let posicionMaximaConvertida = self.backgroundLayer.convert(posicionMaximaEnElFrame, from: self)
        
        let posAleatoriaY = CGFloat.random(min: posicionMinimaConvertida.y, max: posicionMaximaConvertida.y)

        enemy.position = CGPoint(x: posicionMaximaConvertida.x + enemy.size.width, y: posAleatoriaY)
        //enemy.position = CGPoint(x: frame.maxX + enemy.size.width, y: posAleatoriaY)
        
        //enemy.position = CGPoint.zero
        enemy.zPosition = 0
        backgroundLayer.addChild(enemy)
        
    //movimiento lineal
       // let actionTranslation = SKAction.move(to: CGPoint(x: (size.width/2 + enemy.size.width/2) * -1, y: enemy.position.y), duration: 10.0)
       //con referencia a coordenadas bacgroungLayer
        let posicionFinalXconvertida = self.backgroundLayer.convert(CGPoint(x: (size.width/2 + enemy.size.width/2) * -1, y: 0.0), from: self)
        let actionTranslation = SKAction.move(to: CGPoint(x: posicionFinalXconvertida.x, y: enemy.position.y), duration: 7.0)
        
        let actionRemove = SKAction.removeFromParent()
        enemy.run(SKAction.sequence([actionTranslation, actionRemove]))
        
        
   
        //acciones en secuencia e inversas
        /*
        let actionWait = SKAction.wait(forDuration: 1.0)
        let actionPrint = SKAction.run {
            print("he llegado")
        }
        //let actionFirstMove = SKAction.move(to: CGPoint(x: (frame.midX), y: frame.maxY ), duration: 4.0)
        //let actionSecondtMove = SKAction.move(to: CGPoint(x: (size.width/2) * -1, y: enemy.position.y), duration: 4.0)
        
        let actionFirstMove = SKAction.moveBy(x: -size.width/2, y: frame.maxY, duration: 4.0)
        let actionSecondtMove = SKAction.moveBy(x: (size.width/2) * -1, y: -size.height, duration: 4.0)
        
        //revertit acciones
        let actionFirstMoveReverseActon = actionFirstMove.reversed()
        let actionSecondMoveReverseActon = actionSecondtMove.reversed()
        
        let sequence = SKAction.sequence([actionFirstMove, actionPrint, actionWait, actionSecondtMove, actionWait, actionSecondMoveReverseActon, actionWait, actionPrint, actionFirstMoveReverseActon])
        
        
        //revertit secuencia
        let secuencia1 = SKAction.sequence([actionFirstMove, actionPrint, actionWait, actionSecondtMove])
        let secuenciaInvertida = secuencia1.reversed()
        let cicloSecuencia = SKAction.sequence([secuencia1, secuenciaInvertida])
        
        //repetocion en bucle de uns accion
        //let actionRepeat = SKAction.repeat(sequence, count: 10)
        let actionRepeat = SKAction.repeatForever(cicloSecuencia)
        enemy.run(actionRepeat)
        */
    }
    
    func spawnCat(){
        let gato = SKSpriteNode(texture: imagenGato)
        gato.name = "gato"
        
        //con referencia a coordenadas frame
        //let posAleatoriaY = CGFloat.random(min: frame.minY + gato.size.height/2, max: frame.maxY - gato.size.height/2)
        //let posAleatoriaX = CGFloat.random(min: frame.minX + gato.size.width/2, max: frame.maxX - gato.size.width/2)
        
        //con referencia a coordenadas bacgroungLayer
        let posicionMinimaEnElFrame = CGPoint(x: frame.minX + gato.size.height/2, y: frame.minY + gato.size.height/2)
        let posicionMaximaEnElFrame = CGPoint(x: frame.maxX - gato.size.height/2, y: frame.maxY - gato.size.height/2)
        let posicionMinimaConvertida = self.backgroundLayer.convert(posicionMinimaEnElFrame, from: self)
        let posicionMaximaConvertida = self.backgroundLayer.convert(posicionMaximaEnElFrame, from: self)

        let posAleatoriaY = CGFloat.random(min: posicionMinimaConvertida.y, max: posicionMaximaConvertida.y)
        let posAleatoriaX = CGFloat.random(min: posicionMinimaConvertida.x, max: posicionMaximaConvertida.x)
        
        gato.position = CGPoint(x: posAleatoriaX, y: posAleatoriaY)
        gato.zPosition = 0
        //desaparece el gato escalandolo
        gato.scale(to: CGSize(width: 0 , height: 0 ))
        backgroundLayer.addChild(gato)
        
        //secuencia de acciones que hace que el gato aparezca durante 8 segundos y desaparezca.
        let appear = SKAction.scale(to: CGSize(width: frame.size.width * 0.07 , height: frame.size.height * 0.07 ), duration: 1)
        
        //rotacion gato durante el tiempo en pantalla -------------------------------------------------
        //let wait = SKAction.wait(forDuration: 8.0)
        //durante los 8 segundos que esta en pantalla gira de arriba a abajo para que no este estatico y sea mas dinsmico el juego.
        gato.zRotation = -π/16.0 //rotamos aproximadamente 11º hacia abajo.
        let rotationLeft = SKAction.rotate(byAngle: π/8.0, duration: 0.25) //rotamos aproximadamente 22º hacia arriba.
        let rotationRight = rotationLeft.reversed()//rotamos aproximadamente 22º hacia abajo, para volver a la posicion original.
        let fullRotation = SKAction.sequence([rotationLeft, rotationRight])
        //let rotationWait = SKAction.repeat(fullRotation, count: 16)
        
        //escalado gato durante el tiempo en pantalla.-----------------------------------------------
        let scaleUp = SKAction.scale(by: 1.25, duration: 0.25)
        let scaleDown = scaleUp.reversed()
        let fullScale = SKAction.sequence([scaleUp, scaleDown])
        
        //bloque de espera
        let group = SKAction.group([fullScale, fullRotation])
        let groupWait = SKAction.repeat(group, count: 16)
        
        
        let disapper = SKAction.scale(to: 0, duration: 1)
        let removeGato = SKAction.removeFromParent()
        
       // let sequence = SKAction.sequence([appear, rotationWait, disapper, removeGato])
        let sequence = SKAction.sequence([appear, groupWait, disapper, removeGato])
        gato.run(sequence)
    }
    
    override func didEvaluateActions() {
        checkCollisions()
    }
    
    func moveConga(){
        var congaPosition = zombie1.position
        
        backgroundLayer.enumerateChildNodes(withName: "conga") { node, _ in
            if !node.hasActions(){
                let actionDuration = 0.2
                let offset = congaPosition - node.position //calcula cuanto se desplaza
                let director = offset.normalize()
                
                let amountToMovePerSecond = director * self.catPixelPerSeconds
                let totalAmountToMove = amountToMovePerSecond * CGFloat(actionDuration)
                
                let actionMove = SKAction.moveBy(x:totalAmountToMove.x, y: totalAmountToMove.y, duration: actionDuration)
                
                //rotacion
                let actionRotate = SKAction.rotate(byAngle: offset.angle - node.zRotation, duration: actionDuration)
                
                
                node.run(SKAction.group([actionMove, actionRotate]))

            }
            congaPosition = node.position
            
            
            
        }
        
    }
    
    func loseCats(){
        var lostCastCount = 0
        backgroundLayer.enumerateChildNodes(withName: "conga") { node, stop in
            var randomCatPosition = node.position
            randomCatPosition.x += CGFloat.random(min: -150.0, max: 150.0)
            randomCatPosition.y += CGFloat.random(min: -50.0, max: 50.0)
            
            node.name = ""
            let rotation = SKAction.rotate(byAngle: 6*π, duration: 2.0)
            let translate = SKAction.move(to: randomCatPosition, duration: 2.0)
            let disappear = SKAction.scale(to: 0, duration: 2.0)
            
            let groupAction = SKAction.group([rotation,translate,disappear])
            let fullSequence = SKAction.sequence([groupAction, SKAction.removeFromParent()])
            node.run(fullSequence)
            
            lostCastCount += 1
            if lostCastCount >= 3 {
                stop.pointee = true
            }
        }
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
