//
//  Note.swift
//  KeyGrids
//
//  Created by James on 28/5/18.
//  Copyright © 2018 james. All rights reserved.
//

import UIKit
import AudioToolbox

class Note {
    var name: String
    var index: UInt8
    var color: UIColor
    
    init() {
        self.name = ""
        self.index = 0
        self.color = .background
    }
    
    init(name: String, index: UInt8, color: UIColor) {
        self.name = name
        self.index = index
        self.color = color
    }
    
    var sequence: MusicSequence? = nil
    var track: MusicTrack? = nil
    var musicPlayer:MusicPlayer? = nil
    
    func play(with duration: Float32) {
        if name != "" {
            NewMusicSequence(&sequence)
            MusicSequenceNewTrack(sequence!, &track)
            
            var note = MIDINoteMessage(channel: 0, note: index, velocity: 127, releaseVelocity: 64, duration: duration)
            MusicTrackNewMIDINoteEvent(track!, 0, &note)
            
            var musicPlayer: MusicPlayer? = nil
            NewMusicPlayer(&musicPlayer)
            MusicPlayerSetSequence(musicPlayer!, sequence!)
            MusicPlayerStart(musicPlayer!)
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(duration)) {
                MusicPlayerStop(musicPlayer!)
            }
        }
    }
}
