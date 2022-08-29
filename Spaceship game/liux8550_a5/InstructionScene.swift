//
//  InstructionScene.swift
//  liux8550_a5
//
//  Created by jingxuan liu on 2021-03-24.
//

import SpriteKit


class InstructionScene: SKScene {
    var instruction1: SKSpriteNode?
    var instruction2: SKSpriteNode?
    var backButton: SKSpriteNode?
    
    override init(size: CGSize) {
        super.init(size: size)
        backgroundColor = SKColor.white
        
        let instruction1 = SKLabelNode(fontNamed: "Courier")
        instruction1.fontColor = SKColor.darkGray
        instruction1.text = "Shoot at the invaders"
        instruction1.fontSize = 31
        instruction1.position = CGPoint(x: self.frame.midX, y: self.frame.midY+80)
        
        let instruction2 = SKLabelNode(fontNamed: "Courier")
        instruction2.fontColor = SKColor.darkGray
        instruction2.text = "Don't let the rock hit you"
        instruction2.fontSize = 22
        instruction2.position = CGPoint(x: self.frame.midX, y: self.frame.midY+55)
        
        let backButton = SKLabelNode(fontNamed: "Courier")
        backButton.fontColor = SKColor.darkGray
        backButton.text = "Back"
        backButton.fontSize = 45
        backButton.name = "Back"
        backButton.position = CGPoint(x: self.frame.midX, y: self.frame.midY-60)
        
        self.addChild(instruction1)
        self.addChild(instruction2)
        self.addChild(backButton)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location  = touch.location(in: self)
            let theNode = self.atPoint(location)
            if theNode.name == "Back" {
                print("Back button clicked")
                let transition = SKTransition.crossFade(withDuration: 0.5)
                let menuScene = MenuScene(size: self.size)
                self.view?.presentScene(menuScene, transition: transition)
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
