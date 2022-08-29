//
//  GameScene.swift
//  liux8550_a5
//
//  Created by jingxuan liu on 2021-03-23.
//

import SpriteKit
import GameplayKit
import Foundation

//MARK: GAMESCENE LEVEL1
//---------------------------------------------------------------------------------------------
//---------------------------------------------------------------------------------------------
//---------------------------------------------------------------------------------------------
//---------------------------------------------------------------------------------------------
class GameScene: SKScene, SKPhysicsContactDelegate {
    
    //private let playerBullets = SKNode()
    let Spaceship = SKSpriteNode(imageNamed: "Spaceship.png")
    let Invader = SKSpriteNode(imageNamed: "space-invader-small.png")
    //Setting
    let shipSpeed: CGFloat = 13.0
    let rockSpeed = 4.0 // speed of rock
    let bulletSpeed = 2.0 // defender's bullet
    let invaderSpeed = 3.0
    let rockFrequency = 1.0 // the frequency a rock is throw by the invader
    
    override func didMove(to view: SKView) {
        backgroundColor = SKColor.black
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        physicsWorld.contactDelegate = self
        
        let windowHeight = self.frame.height
        let windowWidth = self.frame.width
        let xScale = windowWidth/3
        let yScale = windowHeight/15
        
        //initial the UI button
        let rightButton = SKSpriteNode(imageNamed: "right-arrow-unit")
        rightButton.name = "Right"
        rightButton.size = CGSize(width: xScale, height: yScale)
        rightButton.position = CGPoint(x: windowWidth - xScale/2, y: yScale/2)
        
        let leftButton = SKSpriteNode(imageNamed: "left-arrow-unit")
        leftButton.name = "Left"
        leftButton.size = CGSize(width: xScale, height: yScale)
        leftButton.position = CGPoint(x: xScale/2, y: yScale/2)
        
        let shootButton = SKSpriteNode(imageNamed: "bullet-unit")
        shootButton.name = "Shoot"
        shootButton.size = CGSize(width: xScale, height: yScale)
        shootButton.position = CGPoint(x: self.frame.midX, y: yScale/2)
        
        //initial the object
        Spaceship.size = CGSize(width: windowWidth/10, height: windowHeight/20)
        Spaceship.position = CGPoint(x: self.frame.midX, y: yScale + Spaceship.size.height/2)
        Spaceship.physicsBody = SKPhysicsBody(rectangleOf: Spaceship.size)
        Spaceship.physicsBody?.isDynamic = true
        Spaceship.physicsBody?.categoryBitMask = PhysicsCategory.Spaceship
        Spaceship.physicsBody?.contactTestBitMask = PhysicsCategory.invaderRock
        Spaceship.physicsBody?.collisionBitMask = PhysicsCategory.None
        
        
        Invader.size = CGSize(width: windowWidth/17, height: windowHeight/37)
        Invader.position = CGPoint(x: Invader.size.width/2, y: windowHeight - 2*Invader.size.height)
        Invader.physicsBody = SKPhysicsBody(rectangleOf: Invader.size)
        Invader.physicsBody?.isDynamic = true
        Invader.physicsBody?.categoryBitMask = PhysicsCategory.Invader
        Invader.physicsBody?.contactTestBitMask = PhysicsCategory.playerBullet
        Invader.physicsBody?.collisionBitMask = PhysicsCategory.None
        
        
        //add to scene
        self.addChild(Invader)
        self.addChild(rightButton)
        self.addChild(leftButton)
        self.addChild(shootButton)
        self.addChild(Spaceship)
        
        runInvaders(invader: Invader)
        shootRock()
    }
    
    //MARK: Invader run and shoot
    func runInvaders(invader: SKSpriteNode) {
        let actionMoveRight = SKAction.move(to: CGPoint(x: self.frame.maxX - invader.size.width/2, y: invader.position.y), duration: invaderSpeed)
        //let actionMoveDown1 = SKAction.move(to: CGPoint(x: self.frame.maxX - invader.size.width/2, y: invader.position.y - invaderDownSpeed), duration: 0.2)
        let actionMoveLeft = SKAction.move(to: CGPoint(x: invader.size.width/2, y: invader.position.y), duration: invaderSpeed)
        //let actionMoveDown2 = SKAction.move(to: CGPoint(x: invader.size.width/2, y: invader.position.y - 2*invaderDownSpeed), duration: 0.2)
        
        invader.run(SKAction.repeatForever(SKAction.sequence([actionMoveRight, actionMoveLeft])))
    }
    
    func addRock() {
        run(SKAction.playSoundFileNamed("fastinvader1.wav", waitForCompletion: false))
        let rock = SKSpriteNode(imageNamed: "rock.png")
        rock.size = CGSize(width: Invader.size.width/3, height: Invader.size.height/3)
        rock.physicsBody = SKPhysicsBody(rectangleOf: rock.size)
        rock.position = Invader.position
        rock.physicsBody?.isDynamic = true
        rock.physicsBody?.categoryBitMask = PhysicsCategory.invaderRock
        rock.physicsBody?.contactTestBitMask = PhysicsCategory.Spaceship
        rock.physicsBody?.collisionBitMask = PhysicsCategory.None
        addChild(rock)
        //set the bullet moving action
        let actionMove = SKAction.move(to: CGPoint(x: rock.position.x, y: Spaceship.frame.minY), duration: rockSpeed)
        let actionMoveDone = SKAction.removeFromParent()
        //let actionWait = SKAction.wait(forDuration: 0.1)
        rock.run(SKAction.sequence([actionMove, actionMoveDone]))
    }
    
    func shootRock(){
        addRock()
        run(SKAction.repeatForever(
          SKAction.sequence([
            SKAction.run(addRock),
            SKAction.wait(forDuration: rockFrequency)
          ])
        ))
    }
    
    //MARK: Collision reaction
    func playerBulletDidCollideWithInvader(_ invader:SKSpriteNode, playerBullet:SKSpriteNode){
        run(SKAction.playSoundFileNamed("crash.mp3", waitForCompletion: false))
        print("hit")
        let explosionImage = SKSpriteNode(imageNamed: "explosion-small.png")
        explosionImage.size = CGSize(width: Invader.size.width, height: Invader.size.height)
        explosionImage.position = invader.position
        playerBullet.removeFromParent()
        invader.removeFromParent()
        addChild(explosionImage)
        run(SKAction.sequence([
            SKAction.wait(forDuration: 0.3),
            SKAction.run() {
                let winScene = WinScene1(size: self.size)
                let transition = SKTransition.doorway(withDuration: 1.0)
                self.view?.presentScene(winScene, transition: transition) // we killed the monster, we win!
            }//block
        ]))

    }
    
    func rockDidCollideWithPlayer(_ player:SKSpriteNode, rock: SKSpriteNode){
        run(SKAction.playSoundFileNamed("scream.mp3", waitForCompletion: false))
        print("you are dead")
        let screamImage = SKSpriteNode(imageNamed: "scream.png")
        screamImage.size = CGSize(width: Spaceship.size.width, height: Spaceship.size.height)
        screamImage.position = Spaceship.position
        rock.removeFromParent()
        player.removeFromParent()
        addChild(screamImage)
        run(SKAction.sequence([
            SKAction.wait(forDuration: 0.3),
            SKAction.run() {
                let loseScene = LoseScene(size: self.size)
                let transition = SKTransition.doorway(withDuration: 1.0)
                self.view?.presentScene(loseScene, transition: transition) // we killed the monster, we win!
            }//block
        ]))
    }
    
    //MARK: touch began method
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //let windowHeight = self.frame.height
        let windowWidth = self.frame.width
        //let xScale = windowWidth/3
        //let yScale = windowHeight/15
        
        for touch in touches {
            let theNode = atPoint(touch.location(in: self))
            if theNode.name == "Left" {
                if Spaceship.position.x >= Spaceship.size.width/2{
                    Spaceship.position.x -= shipSpeed
                }
            }else if theNode.name == "Right" {
                if Spaceship.position.x <= windowWidth - Spaceship.size.width/2 {
                    Spaceship.position.x += shipSpeed
                }
            }else if theNode.name == "Shoot" {
                print("Shoot button clicked")
                run(SKAction.playSoundFileNamed("artillery2.m4a", waitForCompletion: false))
                
                let bullet = SKSpriteNode(imageNamed: "defenderBullet2.png")
                bullet.size = CGSize(width: Spaceship.size.width/12, height: Spaceship.size.height/3)
                bullet.position = Spaceship.position
                bullet.physicsBody = SKPhysicsBody(rectangleOf: bullet.size)
                bullet.physicsBody?.isDynamic = true
                bullet.physicsBody?.categoryBitMask = PhysicsCategory.playerBullet
                bullet.physicsBody?.contactTestBitMask = PhysicsCategory.Invader
                bullet.physicsBody?.collisionBitMask = PhysicsCategory.None
                addChild(bullet)
                //set the bullet moving action
                let actionMove = SKAction.move(to: CGPoint(x: bullet.position.x, y: self.frame.maxY), duration: bulletSpeed)
                let actionMoveDone = SKAction.removeFromParent()
                bullet.run(SKAction.sequence([actionMove, actionMoveDone]))
            }
        }
    }
    
    //MARK: touchesMoved method
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let windowWidth = self.frame.width
        let windowHeight = self.frame.height
        let yScale = windowHeight/15
        let touch = touches.first
        if let location = touch?.location(in: self){
            if location.y <= yScale{
                return
            }
            if location.x > Spaceship.position.x{
                if Spaceship.position.x <= windowWidth - Spaceship.size.width/2 {
                    Spaceship.position.x += shipSpeed
                }
            }else if location.x < Spaceship.position.x{
                if Spaceship.position.x >= Spaceship.size.width/2{
                        Spaceship.position.x -= shipSpeed
                }
            }
        }
    }
    
    override func update(_ currentTime: CFTimeInterval) {
        
    }
    
    //MARK: Physics Contact detector
    func didBegin(_ contact: SKPhysicsContact) {
        // bodyA and bodyB collide, we have to sort them by their bitmasks
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        if ((firstBody.categoryBitMask == PhysicsCategory.Invader) &&
            (secondBody.categoryBitMask == PhysicsCategory.playerBullet )) {
            playerBulletDidCollideWithInvader(firstBody.node as! SKSpriteNode, playerBullet: secondBody.node as! SKSpriteNode)
        }else if ((firstBody.categoryBitMask == PhysicsCategory.Spaceship ) &&
                (secondBody.categoryBitMask == PhysicsCategory.invaderRock)) {
            rockDidCollideWithPlayer(firstBody.node as! SKSpriteNode, rock: secondBody.node as! SKSpriteNode)
        }else if ((firstBody.categoryBitMask == PhysicsCategory.playerBullet) &&
                    (secondBody.categoryBitMask == PhysicsCategory.invaderRock)) {
            firstBody.node?.removeFromParent()
            secondBody.node?.removeFromParent()
        }
    }
    
 
}





//---------------------------------------------------------------------------------------------
//---------------------------------------------------------------------------------------------
//MARK: GAMESCENE LEVEL2
//---------------------------------------------------------------------------------------------
//---------------------------------------------------------------------------------------------
//---------------------------------------------------------------------------------------------
//---------------------------------------------------------------------------------------------
enum InvaderMovementDirection{
    case right
    case left
    case downThenRight
    case downThenLeft
    case none
}

class GameScene2: SKScene, SKPhysicsContactDelegate {
    
    //private let playerBullets = SKNode()
    let Spaceship = SKSpriteNode(imageNamed: "Spaceship.png")
    var Invader = SKSpriteNode()
    var Invaders =  [SKSpriteNode]()
    

    //Setting
    let shipSpeed: CGFloat = 13.0
    let rockSpeed = 4.0 // speed of rock
    let bulletSpeed = 2.0 // defender's bullet
    let invaderSpeed = 1.0
    let invaderDownSpeed = 30.0
    let rockFrequency = 1.5 // the frequency a rock is throw by the invader
    var timeOfLastMove: CFTimeInterval = 0.0
    var invaderMovementDirection: InvaderMovementDirection = .right
    
    override func sceneDidLoad() {

    }
    
    override func didMove(to view: SKView) {
        backgroundColor = SKColor.black
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        physicsWorld.contactDelegate = self
        
        let windowHeight = self.frame.height
        let windowWidth = self.frame.width
        let xScale = windowWidth/3
        let yScale = windowHeight/15
        
        //initial the UI button
        let rightButton = SKSpriteNode(imageNamed: "right-arrow-unit")
        rightButton.name = "Right"
        rightButton.size = CGSize(width: xScale, height: yScale)
        rightButton.position = CGPoint(x: windowWidth - xScale/2, y: yScale/2)
        
        let leftButton = SKSpriteNode(imageNamed: "left-arrow-unit")
        leftButton.name = "Left"
        leftButton.size = CGSize(width: xScale, height: yScale)
        leftButton.position = CGPoint(x: xScale/2, y: yScale/2)
        
        let shootButton = SKSpriteNode(imageNamed: "bullet-unit")
        shootButton.name = "Shoot"
        shootButton.size = CGSize(width: xScale, height: yScale)
        shootButton.position = CGPoint(x: self.frame.midX, y: yScale/2)
        
        //initial the object
        Spaceship.size = CGSize(width: windowWidth/10, height: windowHeight/20)
        Spaceship.position = CGPoint(x: self.frame.midX, y: yScale + Spaceship.size.height/2)
        Spaceship.physicsBody = SKPhysicsBody(rectangleOf: Spaceship.size)
        Spaceship.physicsBody?.isDynamic = true
        Spaceship.physicsBody?.categoryBitMask = PhysicsCategory.Spaceship
        Spaceship.physicsBody?.contactTestBitMask = PhysicsCategory.invaderRock
        Spaceship.physicsBody?.collisionBitMask = PhysicsCategory.None
        
 
        for i in 0...3 {
            let Invader = SKSpriteNode(imageNamed: "space-invader-small.png")
            
            Invader.size = CGSize(width: windowWidth/17, height: windowHeight/37)
            if i == 0{
                Invader.position = CGPoint(x: Invader.size.width/2, y: windowHeight - 2*Invader.size.height)
            }else{
                Invader.position = CGPoint(x: (CGFloat(i)+0.5)*Invader.size.width, y: windowHeight - 2*Invader.size.height)
            }
            Invader.name = "invader"
            Invader.physicsBody = SKPhysicsBody(rectangleOf: Invader.size)
            Invader.physicsBody?.isDynamic = true
            Invader.physicsBody?.categoryBitMask = PhysicsCategory.Invader
            Invader.physicsBody?.contactTestBitMask = PhysicsCategory.playerBullet
            Invader.physicsBody?.collisionBitMask = PhysicsCategory.None
            
            //Invader.userData = NSMutableDictionary()
            //Invader.userData?.setObject(i, forKey: "ROW" as NSCopying)
            //Invader.userData?.setObject(true, forKey: "ALIVE" as NSCopying)
            
            Invaders.append(Invader)
            self.addChild(Invader)
        }
        
    
        //add to scene
        //self.addChild(Invaders)
        self.addChild(rightButton)
        self.addChild(leftButton)
        self.addChild(shootButton)
        self.addChild(Spaceship)
        
        //runInvaders(invader: Invader)
        //shootRock()
    }
    
    //MARK: Invader run and shoot
    func addRock(Invader: SKSpriteNode) {
        run(SKAction.playSoundFileNamed("fastinvader1.wav", waitForCompletion: false))
        let rock = SKSpriteNode(imageNamed: "rock.png")
        rock.size = CGSize(width: Invader.size.width/3, height: Invader.size.height/3)
        rock.name = "rock"
        rock.physicsBody = SKPhysicsBody(rectangleOf: rock.size)
        rock.position = Invader.position
        rock.physicsBody?.isDynamic = true
        rock.physicsBody?.categoryBitMask = PhysicsCategory.invaderRock
        rock.physicsBody?.contactTestBitMask = PhysicsCategory.Spaceship
        rock.physicsBody?.collisionBitMask = PhysicsCategory.None
        addChild(rock)
        //set the bullet moving action
        let actionMove = SKAction.move(to: CGPoint(x: rock.position.x, y: Spaceship.frame.minY), duration: rockSpeed)
        let actionMoveDone = SKAction.removeFromParent()
        //let actionWait = SKAction.wait(forDuration: 0.1)
        rock.run(SKAction.sequence([actionMove, actionMoveDone]))
    }

    
    func shootRock(forUpdate currentTime: CFTimeInterval) {
        
        if (currentTime - timeOfLastMove < rockFrequency) || Invaders.count == 0 {
          return
        }
        
        if Invaders.count > 0 {
            let allInvadersIndex = Int(arc4random_uniform(UInt32(Invaders.count)))
            let invader = Invaders[allInvadersIndex]
            
            addRock(Invader: invader)
        }
        self.timeOfLastMove = currentTime
    }
    

    func moveInvaders(forUpdate currentTime: CFTimeInterval) {

        determineInvaderDirection()
      
      enumerateChildNodes(withName: "invader") { node, stop in
        switch self.invaderMovementDirection {
        case .right:
            node.position = CGPoint(x: node.position.x + CGFloat(self.invaderSpeed), y: node.position.y)
        case .left:
            node.position = CGPoint(x: node.position.x - CGFloat(self.invaderSpeed), y: node.position.y)
        case .downThenLeft, .downThenRight:
            node.position = CGPoint(x: node.position.x, y: node.position.y - CGFloat(self.invaderDownSpeed))
        case .none:
          break
        }
      }
    }
    
    func determineInvaderDirection() {
        var movementDirection: InvaderMovementDirection = invaderMovementDirection
        
        enumerateChildNodes(withName: "invader") {
            node, stop in
            switch self.invaderMovementDirection{
            case.right:
                if(node.frame.maxX >= node.scene!.size.width - 1.0){
                    movementDirection = .downThenLeft
                    stop.pointee = true
                }
            case.left:
                if(node.frame.minX <= 1.0) {
                    movementDirection = .downThenRight
                    stop.pointee = true
                }
            case.downThenLeft:
                movementDirection = .left
                stop.pointee = true
            case.downThenRight:
                movementDirection = .right
                stop.pointee = true
            default:
                break
            }
            }
        
        if(movementDirection != invaderMovementDirection) {
            invaderMovementDirection = movementDirection
        
        }
    }
    
    
    //MARK: Collision reaction
    func playerBulletDidCollideWithInvader(_ invader:SKSpriteNode, playerBullet:SKSpriteNode){
        run(SKAction.playSoundFileNamed("crash.mp3", waitForCompletion: false))
        print("hit")
        playerBullet.removeFromParent()
        invader.removeFromParent()
        if let index = Invaders.firstIndex(of: invader) {
            Invaders.remove(at: index)
        }
        if Invaders.count == 0 {
            let explosionImage = SKSpriteNode(imageNamed: "explosion-small.png")
            explosionImage.size = CGSize(width: Invader.size.width, height: Invader.size.height)
            explosionImage.position = invader.position
            playerBullet.removeFromParent()
            invader.removeFromParent()
            addChild(explosionImage)
            run(SKAction.sequence([
                SKAction.wait(forDuration: 0.3),
                SKAction.run() {
                    let winScene = WinScene2(size: self.size)
                    let transition = SKTransition.doorway(withDuration: 1.0)
                    self.view?.presentScene(winScene, transition: transition) // we killed the monster, we win!
                }//block
            ]))
        }
    }
    
    func rockDidCollideWithPlayer(_ player:SKSpriteNode, rock: SKSpriteNode){
        run(SKAction.playSoundFileNamed("scream.mp3", waitForCompletion: false))
        print("you are dead")
        let screamImage = SKSpriteNode(imageNamed: "scream.png")
        screamImage.size = CGSize(width: Spaceship.size.width, height: Spaceship.size.height)
        screamImage.position = Spaceship.position
        rock.removeFromParent()
        player.removeFromParent()
        addChild(screamImage)
        run(SKAction.sequence([
            SKAction.wait(forDuration: 0.3),
            SKAction.run() {
                let loseScene = LoseScene(size: self.size)
                let transition = SKTransition.doorway(withDuration: 1.0)
                self.view?.presentScene(loseScene, transition: transition) // we killed the monster, we win!
            }//block
        ]))
    }
    
    //MARK: touch began method
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //let windowHeight = self.frame.height
        let windowWidth = self.frame.width
        //let xScale = windowWidth/3
        //let yScale = windowHeight/15
        
        for touch in touches {
            let theNode = atPoint(touch.location(in: self))
            if theNode.name == "Left" {
                if Spaceship.position.x >= Spaceship.size.width/2{
                    Spaceship.position.x -= shipSpeed
                }
            }else if theNode.name == "Right" {
                if Spaceship.position.x <= windowWidth - Spaceship.size.width/2 {
                    Spaceship.position.x += shipSpeed
                }
            }else if theNode.name == "Shoot" {
                print("Shoot button clicked")
                run(SKAction.playSoundFileNamed("artillery2.m4a", waitForCompletion: false))
                
                let bullet = SKSpriteNode(imageNamed: "defenderBullet2.png")
                bullet.size = CGSize(width: Spaceship.size.width/12, height: Spaceship.size.height/3)
                bullet.position = Spaceship.position
                bullet.physicsBody = SKPhysicsBody(rectangleOf: bullet.size)
                bullet.physicsBody?.isDynamic = true
                bullet.physicsBody?.categoryBitMask = PhysicsCategory.playerBullet
                bullet.physicsBody?.contactTestBitMask = PhysicsCategory.Invader
                bullet.physicsBody?.collisionBitMask = PhysicsCategory.None
                addChild(bullet)
                //set the bullet moving action
                let actionMove = SKAction.move(to: CGPoint(x: bullet.position.x, y: self.frame.maxY), duration: bulletSpeed)
                let actionMoveDone = SKAction.removeFromParent()
                bullet.run(SKAction.sequence([actionMove, actionMoveDone]))
            }
        }
    }
    
    
    //MARK: touchesMoved method
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let windowWidth = self.frame.width
        let windowHeight = self.frame.height
        let yScale = windowHeight/15
        let touch = touches.first
        if let location = touch?.location(in: self){
            if location.y <= yScale{
                return
            }
            if location.x > Spaceship.position.x{
                if Spaceship.position.x <= windowWidth - Spaceship.size.width/2 {
                    Spaceship.position.x += shipSpeed
                }
            }else if location.x < Spaceship.position.x{
                if Spaceship.position.x >= Spaceship.size.width/2{
                        Spaceship.position.x -= shipSpeed
                }
            }
        }
    }
    
    //MARK: Update Method
    override func update(_ currentTime: CFTimeInterval) {
        moveInvaders(forUpdate: currentTime)
        shootRock(forUpdate: currentTime)
    }
    
    //MARK: Physics Contact detector
    func didBegin(_ contact: SKPhysicsContact) {
        if contact.bodyA.node?.parent == nil || contact.bodyB.node?.parent == nil {
          return
        }
        // bodyA and bodyB collide, we have to sort them by their bitmasks
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody

        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        if ((firstBody.categoryBitMask == PhysicsCategory.Invader) &&
            (secondBody.categoryBitMask == PhysicsCategory.playerBullet )) {
            playerBulletDidCollideWithInvader(firstBody.node as! SKSpriteNode, playerBullet: secondBody.node as! SKSpriteNode)
        }else if ((firstBody.categoryBitMask == PhysicsCategory.Spaceship ) &&
                (secondBody.categoryBitMask == PhysicsCategory.invaderRock)) {
            rockDidCollideWithPlayer(firstBody.node as! SKSpriteNode, rock: secondBody.node as! SKSpriteNode)
        }else if ((firstBody.categoryBitMask == PhysicsCategory.playerBullet) &&
                    (secondBody.categoryBitMask == PhysicsCategory.invaderRock)) {
            firstBody.node?.removeFromParent()
            secondBody.node?.removeFromParent()
        }else if ((firstBody.categoryBitMask == PhysicsCategory.Invader) &&
                    (secondBody.categoryBitMask == PhysicsCategory.Spaceship)){
            run(SKAction.playSoundFileNamed("scream.mp3", waitForCompletion: false))
            print("you are dead")
            let screamImage = SKSpriteNode(imageNamed: "scream.png")
            screamImage.size = CGSize(width: Spaceship.size.width, height: Spaceship.size.height)
            screamImage.position = Spaceship.position
            secondBody.node?.removeFromParent()
            addChild(screamImage)
            run(SKAction.sequence([
                SKAction.wait(forDuration: 0.3),
                SKAction.run() {
                    let loseScene = LoseScene(size: self.size)
                    let transition = SKTransition.doorway(withDuration: 1.0)
                    self.view?.presentScene(loseScene, transition: transition) // we killed the monster, we win!
                }//block
            ]))
        }
        
        
    }
    

    
}








//---------------------------------------------------------------------------------------------
//---------------------------------------------------------------------------------------------
//MARK: GAMESCENE LEVEL3
//---------------------------------------------------------------------------------------------
//---------------------------------------------------------------------------------------------
//---------------------------------------------------------------------------------------------
//---------------------------------------------------------------------------------------------
class GameScene3: SKScene, SKPhysicsContactDelegate {
    
    //private let playerBullets = SKNode()
    let Spaceship = SKSpriteNode(imageNamed: "Spaceship.png")
    var Invader = SKSpriteNode()
    var Invaders =  [[SKSpriteNode]]()
    var leaders = [SKSpriteNode]()

    //Setting
    let shipSpeed: CGFloat = 13.0
    let rockSpeed = 4.0 // speed of rock
    let bulletSpeed = 2.0 // defender's bullet
    let invaderSpeed = 1.0
    let invaderDownSpeed = 30.0
    let rockFrequency = 1.5 // the frequency a rock is throw by the invader
    var timeOfLastMove: CFTimeInterval = 0.0
    var invaderMovementDirection: InvaderMovementDirection = .right
    var killed = 0
    
  
    
    override func didMove(to view: SKView) {
        backgroundColor = SKColor.black
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        physicsWorld.contactDelegate = self
        
        let windowHeight = self.frame.height
        let windowWidth = self.frame.width
        let xScale = windowWidth/3
        let yScale = windowHeight/15
        
        //initial the UI button
        let rightButton = SKSpriteNode(imageNamed: "right-arrow-unit")
        rightButton.name = "Right"
        rightButton.size = CGSize(width: xScale, height: yScale)
        rightButton.position = CGPoint(x: windowWidth - xScale/2, y: yScale/2)
        
        let leftButton = SKSpriteNode(imageNamed: "left-arrow-unit")
        leftButton.name = "Left"
        leftButton.size = CGSize(width: xScale, height: yScale)
        leftButton.position = CGPoint(x: xScale/2, y: yScale/2)
        
        let shootButton = SKSpriteNode(imageNamed: "bullet-unit")
        shootButton.name = "Shoot"
        shootButton.size = CGSize(width: xScale, height: yScale)
        shootButton.position = CGPoint(x: self.frame.midX, y: yScale/2)
        
        let leftShelter = SKSpriteNode(imageNamed: "shelter2.png")
        leftShelter.name = "leftshelter"
        leftShelter.size = CGSize(width: xScale * 2/3, height: yScale * 2/3)
        leftShelter.position = CGPoint(x: xScale * 2/3, y: 3 * yScale)
        leftShelter.physicsBody = SKPhysicsBody(rectangleOf: leftShelter.size)
        leftShelter.physicsBody?.isDynamic = true
        leftShelter.physicsBody?.categoryBitMask = PhysicsCategory.shelters
        leftShelter.physicsBody?.contactTestBitMask = PhysicsCategory.invaderRock | PhysicsCategory.playerBullet
        leftShelter.physicsBody?.collisionBitMask = PhysicsCategory.None
        
        let rightShelter = SKSpriteNode(imageNamed: "shelter2.png")
        rightShelter.name = "rightshelter"
        rightShelter.size = CGSize(width: xScale * 2/3, height: yScale * 2/3)
        rightShelter.position = CGPoint(x: windowWidth - xScale * 2/3, y: 3 * yScale)
        rightShelter.physicsBody = SKPhysicsBody(rectangleOf: rightShelter.size)
        rightShelter.physicsBody?.isDynamic = true
        rightShelter.physicsBody?.categoryBitMask = PhysicsCategory.shelters
        rightShelter.physicsBody?.contactTestBitMask = PhysicsCategory.invaderRock | PhysicsCategory.playerBullet
        rightShelter.physicsBody?.collisionBitMask = PhysicsCategory.None
        
        //initial the object
        Spaceship.size = CGSize(width: windowWidth/10, height: windowHeight/20)
        Spaceship.position = CGPoint(x: self.frame.midX, y: yScale + Spaceship.size.height/2)
        Spaceship.physicsBody = SKPhysicsBody(rectangleOf: Spaceship.size)
        Spaceship.physicsBody?.isDynamic = true
        Spaceship.physicsBody?.categoryBitMask = PhysicsCategory.Spaceship
        Spaceship.physicsBody?.contactTestBitMask = PhysicsCategory.invaderRock
        Spaceship.physicsBody?.collisionBitMask = PhysicsCategory.None
        
 
        for r in 0...3 {
            Invaders.append([])
            for c in 0...6{
                
                let Invader = SKSpriteNode(imageNamed: "space-invader-small.png")
                
                Invader.size = CGSize(width: windowWidth/17, height: windowHeight/37)
                //////
                if c == 0{
                    Invader.position = CGPoint(x: Invader.size.width/2, y: windowHeight - 2*Invader.size.height - CGFloat(r)*Invader.size.height)
                }else{
                    Invader.position = CGPoint(x: (CGFloat(c)+0.5)*Invader.size.width, y: windowHeight - 2*Invader.size.height-CGFloat(r)*Invader.size.height)
                }
                Invader.name = "invader"
                Invader.physicsBody = SKPhysicsBody(rectangleOf: Invader.size)
                Invader.physicsBody?.isDynamic = true
                Invader.physicsBody?.categoryBitMask = PhysicsCategory.Invader
                Invader.physicsBody?.contactTestBitMask = PhysicsCategory.playerBullet
                Invader.physicsBody?.collisionBitMask = PhysicsCategory.None
                
                Invader.userData = NSMutableDictionary()
                Invader.userData?.setObject(r, forKey: "ROW" as NSCopying)
                Invader.userData?.setObject(c, forKey: "COL" as NSCopying)
                Invader.userData?.setObject(true, forKey: "ALIVE" as NSCopying)
                if r == 3{
                    Invader.userData?.setObject(true, forKey: "LEADER" as NSCopying)
                }else{
                    Invader.userData?.setObject(false, forKey: "LEADER" as NSCopying)
                }
                
                Invaders[r].append(Invader)
                self.addChild(Invader)
            }
        }
        
    
        //add to scene
        self.addChild(leftShelter)
        self.addChild(rightShelter)
        self.addChild(rightButton)
        self.addChild(leftButton)
        self.addChild(shootButton)
        self.addChild(Spaceship)
        
        //runInvaders(invader: Invader)
        //shootRock()
    }
    
    //MARK: Invader run and shoot
    func addRock(Invader: SKSpriteNode) {
        run(SKAction.playSoundFileNamed("fastinvader1.wav", waitForCompletion: false))
        let rock = SKSpriteNode(imageNamed: "rock.png")
        rock.size = CGSize(width: Invader.size.width/3, height: Invader.size.height/3)
        rock.name = "rock"
        rock.physicsBody = SKPhysicsBody(rectangleOf: rock.size)
        rock.position = Invader.position
        rock.physicsBody?.isDynamic = true
        rock.physicsBody?.categoryBitMask = PhysicsCategory.invaderRock
        rock.physicsBody?.contactTestBitMask = PhysicsCategory.Spaceship
        rock.physicsBody?.collisionBitMask = PhysicsCategory.None
        addChild(rock)
        //set the bullet moving action
        let actionMove = SKAction.move(to: CGPoint(x: rock.position.x, y: Spaceship.frame.minY), duration: rockSpeed)
        let actionMoveDone = SKAction.removeFromParent()
        //let actionWait = SKAction.wait(forDuration: 0.1)
        rock.run(SKAction.sequence([actionMove, actionMoveDone]))
    }

    
    func shootRock(forUpdate currentTime: CFTimeInterval) {
        
        if (currentTime - timeOfLastMove < rockFrequency) || Invaders.count == 0 {
          return
        }
        
        determineLeader()
        if leaders.count > 0 {
            let allInvadersIndex = Int(arc4random_uniform(UInt32(leaders.count)))
            let invader = leaders[allInvadersIndex]
            
            addRock(Invader: invader)
        }
        self.timeOfLastMove = currentTime
    }
    
    func determineLeader(){
        leaders = []
        for r in 0...Invaders.count - 1 {
            for c in 0...Invaders[r].count - 1{
                let invader = Invaders[r][c]
                let alive = invader.userData?.object(forKey: "ALIVE") as! Bool
                let leader = invader.userData?.object(forKey: "LEADER") as! Bool
                if alive == false && leader == true{
                    invader.userData?.setObject(false, forKey: "LEADER" as NSCopying)
                    if r >= 1{
                        Invaders[r-1][c].userData?.setObject(true, forKey: "LEADER" as NSCopying)
                    }
                }
                
                if alive == true && leader == true{
                    leaders.append(invader)
                }
            }
        }
    
    }
    

    func moveInvaders(forUpdate currentTime: CFTimeInterval) {

        determineInvaderDirection()
      
      enumerateChildNodes(withName: "invader") { node, stop in
        switch self.invaderMovementDirection {
        case .right:
            node.position = CGPoint(x: node.position.x + CGFloat(self.invaderSpeed), y: node.position.y)
        case .left:
            node.position = CGPoint(x: node.position.x - CGFloat(self.invaderSpeed), y: node.position.y)
        case .downThenLeft, .downThenRight:
            node.position = CGPoint(x: node.position.x, y: node.position.y - CGFloat(self.invaderDownSpeed))
        case .none:
          break
        }
      }
    }
    
    func determineInvaderDirection() {
        var movementDirection: InvaderMovementDirection = invaderMovementDirection
        
        enumerateChildNodes(withName: "invader") {
            node, stop in
            switch self.invaderMovementDirection{
            case.right:
                if(node.frame.maxX >= node.scene!.size.width - 1.0){
                    movementDirection = .downThenLeft
                    stop.pointee = true
                }
            case.left:
                if(node.frame.minX <= 1.0) {
                    movementDirection = .downThenRight
                    stop.pointee = true
                }
            case.downThenLeft:
                movementDirection = .left
                stop.pointee = true
            case.downThenRight:
                movementDirection = .right
                stop.pointee = true
            default:
                break
            }
            }
        
        if(movementDirection != invaderMovementDirection) {
            invaderMovementDirection = movementDirection
        
        }
    }
    
    
    //MARK: Collision reaction
    func playerBulletDidCollideWithInvader(_ invader:SKSpriteNode, playerBullet:SKSpriteNode){
        run(SKAction.playSoundFileNamed("crash.mp3", waitForCompletion: false))
        print("hit")
        
        invader.userData?.setObject(false, forKey: "ALIVE" as NSCopying)
        playerBullet.removeFromParent()
        invader.removeFromParent()
        killed += 1
        let totalInvader = Invaders.count * Invaders[0].count
        if killed == totalInvader {
            let explosionImage = SKSpriteNode(imageNamed: "explosion-small.png")
            explosionImage.size = CGSize(width: Invader.size.width, height: Invader.size.height)
            explosionImage.position = invader.position
            playerBullet.removeFromParent()
            invader.removeFromParent()
            addChild(explosionImage)
            run(SKAction.sequence([
                SKAction.wait(forDuration: 0.3),
                SKAction.run() {
                    let winScene = WinScene3(size: self.size)
                    let transition = SKTransition.doorway(withDuration: 1.0)
                    self.view?.presentScene(winScene, transition: transition) // we killed the monster, we win!
                }//block
            ]))
        }
    }
    
    func rockDidCollideWithPlayer(_ player:SKSpriteNode, rock: SKSpriteNode){
        run(SKAction.playSoundFileNamed("scream.mp3", waitForCompletion: false))
        print("you are dead")
        let screamImage = SKSpriteNode(imageNamed: "scream.png")
        screamImage.size = CGSize(width: Spaceship.size.width, height: Spaceship.size.height)
        screamImage.position = Spaceship.position
        rock.removeFromParent()
        player.removeFromParent()
        addChild(screamImage)
        run(SKAction.sequence([
            SKAction.wait(forDuration: 0.3),
            SKAction.run() {
                let loseScene = LoseScene(size: self.size)
                let transition = SKTransition.doorway(withDuration: 1.0)
                self.view?.presentScene(loseScene, transition: transition) // we killed the monster, we win!
            }//block
        ]))
    }
    
    //MARK: touch began method
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //let windowHeight = self.frame.height
        let windowWidth = self.frame.width
        //let xScale = windowWidth/3
        //let yScale = windowHeight/15
        
        for touch in touches {
            let theNode = atPoint(touch.location(in: self))
            if theNode.name == "Left" {
                if Spaceship.position.x >= Spaceship.size.width/2{
                    Spaceship.position.x -= shipSpeed
                }
            }else if theNode.name == "Right" {
                if Spaceship.position.x <= windowWidth - Spaceship.size.width/2 {
                    Spaceship.position.x += shipSpeed
                }
            }else if theNode.name == "Shoot" {
                print("Shoot button clicked")
                run(SKAction.playSoundFileNamed("artillery2.m4a", waitForCompletion: false))
                
                let bullet = SKSpriteNode(imageNamed: "defenderBullet2.png")
                bullet.size = CGSize(width: Spaceship.size.width/12, height: Spaceship.size.height/3)
                bullet.position = Spaceship.position
                bullet.physicsBody = SKPhysicsBody(rectangleOf: bullet.size)
                bullet.physicsBody?.isDynamic = true
                bullet.physicsBody?.categoryBitMask = PhysicsCategory.playerBullet
                bullet.physicsBody?.contactTestBitMask = PhysicsCategory.Invader
                bullet.physicsBody?.collisionBitMask = PhysicsCategory.None
                addChild(bullet)
                //set the bullet moving action
                let actionMove = SKAction.move(to: CGPoint(x: bullet.position.x, y: self.frame.maxY), duration: bulletSpeed)
                let actionMoveDone = SKAction.removeFromParent()
                bullet.run(SKAction.sequence([actionMove, actionMoveDone]))
            }
        }
    }
    
    //MARK: touchesMoved method
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let windowWidth = self.frame.width
        let windowHeight = self.frame.height
        let yScale = windowHeight/15
        let touch = touches.first
        if let location = touch?.location(in: self){
            if location.y <= yScale{
                return
            }
            if location.x > Spaceship.position.x{
                if Spaceship.position.x <= windowWidth - Spaceship.size.width/2 {
                    Spaceship.position.x += shipSpeed
                }
            }else if location.x < Spaceship.position.x{
                if Spaceship.position.x >= Spaceship.size.width/2{
                        Spaceship.position.x -= shipSpeed
                }
            }
        }
    }
    
    //MARK: Update Method
    override func update(_ currentTime: CFTimeInterval) {
        moveInvaders(forUpdate: currentTime)
        shootRock(forUpdate: currentTime)
    }
    
    //MARK: Physics Contact detector
    func didBegin(_ contact: SKPhysicsContact) {
        if contact.bodyA.node?.parent == nil || contact.bodyB.node?.parent == nil {
          return
        }
        // bodyA and bodyB collide, we have to sort them by their bitmasks
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody

        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        if ((firstBody.categoryBitMask == PhysicsCategory.Invader) &&
            (secondBody.categoryBitMask == PhysicsCategory.playerBullet )) {
            playerBulletDidCollideWithInvader(firstBody.node as! SKSpriteNode, playerBullet: secondBody.node as! SKSpriteNode)
        }else if ((firstBody.categoryBitMask == PhysicsCategory.Spaceship ) &&
                (secondBody.categoryBitMask == PhysicsCategory.invaderRock)) {
            rockDidCollideWithPlayer(firstBody.node as! SKSpriteNode, rock: secondBody.node as! SKSpriteNode)
        }else if ((firstBody.categoryBitMask == PhysicsCategory.playerBullet) &&
                    (secondBody.categoryBitMask == PhysicsCategory.invaderRock)) {
            firstBody.node?.removeFromParent()
            secondBody.node?.removeFromParent()
        }else if ((firstBody.categoryBitMask == PhysicsCategory.playerBullet || firstBody.categoryBitMask == PhysicsCategory.invaderRock) &&
                    (secondBody.categoryBitMask == PhysicsCategory.shelters)) {
            firstBody.node?.removeFromParent()
        }else if ((firstBody.categoryBitMask == PhysicsCategory.Invader) &&
                    (secondBody.categoryBitMask == PhysicsCategory.Spaceship)){
            run(SKAction.playSoundFileNamed("scream.mp3", waitForCompletion: false))
            print("you are dead")
            let screamImage = SKSpriteNode(imageNamed: "scream.png")
            screamImage.size = CGSize(width: Spaceship.size.width, height: Spaceship.size.height)
            screamImage.position = Spaceship.position
            secondBody.node?.removeFromParent()
            addChild(screamImage)
            run(SKAction.sequence([
                SKAction.wait(forDuration: 0.3),
                SKAction.run() {
                    let loseScene = LoseScene(size: self.size)
                    let transition = SKTransition.doorway(withDuration: 1.0)
                    self.view?.presentScene(loseScene, transition: transition) // we killed the monster, we win!
                }//block
            ]))
        }
        
    }
    
    
}
