//
//  MainScene.swift
//  liux8550_a5
//
//  Created by jingxuan liu on 2021-03-23.
//

import SpriteKit

class MenuScene: SKScene {
    var playLabel: SKSpriteNode?
    var instructionLabel: SKSpriteNode?
    var playMusicLabel: SKSpriteNode?
    var stopMusicLabel: SKSpriteNode?
    
    override init(size: CGSize) {
        super.init(size: size)
        backgroundColor = SKColor.white
        
        print("Screen Max X(width): \(self.frame.maxX)")
        print("Screen Max Y(height): \(self.frame.maxY)")
    
        
        let playLabel = SKLabelNode(fontNamed: "Courier")
        playLabel.fontColor = SKColor.darkGray
        playLabel.fontSize = 40
        playLabel.text = "Play"
        playLabel.name = "Play"
        playLabel.position = CGPoint(x: self.frame.midX, y: self.frame.midY + 120)
        
        let instructionLabel = SKLabelNode(fontNamed: "Courier")
        instructionLabel.fontColor = SKColor.darkGray
        instructionLabel.fontSize = 25
        instructionLabel.text = "Instruction"
        instructionLabel.name = "Instruction"
        instructionLabel.position = CGPoint(x: self.frame.midX, y: self.frame.midY + 60)
        
        let playMusicLabel = SKLabelNode(fontNamed: "Courier")
        playMusicLabel.fontColor = SKColor.darkGray
        playMusicLabel.fontSize = 25
        playMusicLabel.text = "Play Music"
        playMusicLabel.name = "Playmusic"
        playMusicLabel.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        
        let stopMusicLabel = SKLabelNode(fontNamed: "Courier")
        stopMusicLabel.fontColor = SKColor.darkGray
        stopMusicLabel.fontSize = 25
        stopMusicLabel.text = "Stop Music"
        stopMusicLabel.name = "Stopmusic"
        stopMusicLabel.position = CGPoint(x: self.frame.midX, y: self.frame.midY - 60)
        
        self.addChild(playLabel)
        self.addChild(instructionLabel)
        self.addChild(playMusicLabel)
        self.addChild(stopMusicLabel)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let theNode = self.atPoint(location)
            
            if theNode.name == "Play" {
                print("Play button clicked")
                let transition = SKTransition.crossFade(withDuration: 0.5)
                let gameScene = GameScene(size: self.size)
                self.view?.presentScene(gameScene, transition: transition)
            }else if theNode.name == "Instruction" {
                print("Instruction button clicked")
                let transition = SKTransition.crossFade(withDuration: 0.5)
                let instruction = InstructionScene(size: self.size)
                self.view?.presentScene(instruction, transition: transition)
            }else if theNode.name == "Playmusic" {
                print("The play music button is clicked")
                BackgroudMusicPlayer.sharedPlayer.playBackgroundMusic()
            }else if theNode.name == "Stopmusic" {
                print("The stop music button is clicked")
                BackgroudMusicPlayer.sharedPlayer.stopBackgroundMusic()
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
