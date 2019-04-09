//
//  SoundManager.swift
//  cardmatch
//
//  Created by Rahul khurana on 06/01/19.
//  Copyright © 2019 Rahul khurana. All rights reserved.
//

import Foundation
import AVFoundation

class SoundManager {
    
    
   static var audioPlayer :  AVAudioPlayer?
   
    
    enum soundEffect
    {
        case flip
        case shuffle
        case match
        case noMatch
    }
    
    
    static func playSound(_ effect : soundEffect)
    {
        var soundFileName = ""
        switch effect {
        case .flip:
            soundFileName = "cardflip"
        case .match:
            soundFileName =  "dingcorrect"
        case .noMatch:
            soundFileName = "dingwrong"
        case .shuffle:
            soundFileName = "shuffle"
        default:
           soundFileName = ""
        }
  let bundlePath = Bundle.main.path(forResource: soundFileName, ofType: ".wav")
   
        guard bundlePath != nil else {
            print("no sound file path found")
            return
        }
        let soundURL   = URL(fileURLWithPath : bundlePath!)
        
        do{
            audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            audioPlayer?.play()
           
        }
        catch{
            print("cant play")
        }
    }
    
}
