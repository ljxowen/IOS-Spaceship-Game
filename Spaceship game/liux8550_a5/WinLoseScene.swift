//
//  WinScene.swift
//  liux8550_a5
//
//  Created by jingxuan liu on 2021-03-25.
//

import Foundation
import SpriteKit

class WinScene1: SKScene {
    
    override init(size: CGSize) {
        super.init(size: size)
        backgroundColor = SKColor.white
        
        let label = SKLabelNode(fontNamed: "Courier")
        label.fontColor = SKColor.darkGray
        label.fontSize = 60
        label.text = "You Win"
        label.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        addChild(label)
        
        let label2 = SKLabelNode(fontNamed: "Courier")
        label2.fontColor = SKColor.darkGray
        label2.fontSize = 30
        label2.text = "Going to second level"
        label2.position = CGPoint(x: self.frame.midX, y: self.frame.midY - 50)
        addChild(label2)
        
        Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(WinScene1.toNext), userInfo: nil, repeats: false)
    } //init
    
    @objc func toNext() {
        let nextScene = GameScene2(size: size)
        scene?.view?.presentScene(nextScene, transition: SKTransition.crossFade(withDuration: 1))
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
} //winScene1

class WinScene2: SKScene {
    
    override init(size: CGSize) {
        super.init(size: size)
        backgroundColor = SKColor.white
        
        let label = SKLabelNode(fontNamed: "Courier")
        label.fontColor = SKColor.darkGray
        label.fontSize = 60
        label.text = "You Win"
        label.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        addChild(label)
        
        let label2 = SKLabelNode(fontNamed: "Courier")
        label2.fontColor = SKColor.darkGray
        label2.fontSize = 30
        label2.text = "Going to third level"
        label2.position = CGPoint(x: self.frame.midX, y: self.frame.midY - 50)
        addChild(label2)
        
        Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(WinScene2.toNext), userInfo: nil, repeats: false)
    } //init
    
    @objc func toNext() {
        let nextScene = GameScene3(size: size)
        scene?.view?.presentScene(nextScene, transition: SKTransition.crossFade(withDuration: 1))
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
} //winScene1

class WinScene3: SKScene {
    
    override init(size: CGSize) {
        super.init(size: size)
        backgroundColor = SKColor.white
        
        let label = SKLabelNode(fontNamed: "Courier")
        label.fontColor = SKColor.darkGray
        label.fontSize = 60
        label.text = "You Win"
        label.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        addChild(label)
        
        let label2 = SKLabelNode(fontNamed: "Courier")
        label2.fontColor = SKColor.darkGray
        label2.fontSize = 30
        label2.text = "Going back to menu..."
        label2.position = CGPoint(x: self.frame.midX, y: self.frame.midY - 50)
        addChild(label2)
        
        Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(WinScene3.toMenu), userInfo: nil, repeats: false)
    } //init
    
    @objc func toMenu() {
        let menuScene = MenuScene(size: size)
        scene?.view?.presentScene(menuScene, transition: SKTransition.doorsCloseHorizontal(withDuration: 1))
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
} //winScene3

class LoseScene: SKScene {
    
    override init(size: CGSize) {
        super.init(size: size)
        backgroundColor = SKColor.white
        
        let label = SKLabelNode(fontNamed: "Courier")
        label.fontColor = SKColor.darkGray
        label.fontSize = 60
        label.text = "You Lose"
        label.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        addChild(label)
        
        let label2 = SKLabelNode(fontNamed: "Courier")
        label2.fontColor = SKColor.darkGray
        label2.fontSize = 30
        label2.text = "Going back to menu..."
        label2.position = CGPoint(x: self.frame.midX, y: self.frame.midY - 50)
        addChild(label2)
        
        Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(LoseScene.toMenu), userInfo: nil, repeats: false)
    }
    
    @objc func toMenu() {
        let menuScene = MenuScene(size: size)
        scene?.view?.presentScene(menuScene, transition: SKTransition.doorsCloseHorizontal(withDuration: 1))
    }
        
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
