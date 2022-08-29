//
//  BackgroundMusicPlayer.swift
//  liux8550_a5
//
//  Created by jingxuan liu on 2021-03-24.
//

import AVFoundation

class BackgroudMusicPlayer {
    static let sharedPlayer = BackgroudMusicPlayer()
    var backgroundMusicPlayer: AVAudioPlayer?

    func playBackgroundMusic()  {
        let BGM = Bundle.main.url(forResource: "spaceinvaders-background", withExtension: "mp3")
        do{
            try backgroundMusicPlayer = AVAudioPlayer(contentsOf: BGM!)
        }catch{
            print("Could not create audio player")
        }
        
        backgroundMusicPlayer!.numberOfLoops = -1
        backgroundMusicPlayer!.prepareToPlay()
        backgroundMusicPlayer!.play()
    }
    
    func stopBackgroundMusic() {
        backgroundMusicPlayer?.stop()
    }
}
