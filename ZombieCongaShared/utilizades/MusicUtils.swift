//
//  MusicUtils.swift
//  ZombiConga
//
//  Created by admin on 12/07/2019.
//  Copyright © 2019 admin. All rights reserved.
//

import Foundation
import AVFoundation

var bacgroundAudioPlayer: AVAudioPlayer!

func playBackgroundMusic(fileName: String){
    let urlSound = Bundle.main.url(forResource: fileName, withExtension: nil)
    if (urlSound == nil){
        return
    }
    
    do {
        bacgroundAudioPlayer = try AVAudioPlayer(contentsOf: urlSound!)
        if bacgroundAudioPlayer == nil{
            return
        }
        
        bacgroundAudioPlayer.numberOfLoops = -1
        bacgroundAudioPlayer.prepareToPlay()
        bacgroundAudioPlayer.play()
        
    } catch  {
        print("ERROR")
    }
    
    

}
