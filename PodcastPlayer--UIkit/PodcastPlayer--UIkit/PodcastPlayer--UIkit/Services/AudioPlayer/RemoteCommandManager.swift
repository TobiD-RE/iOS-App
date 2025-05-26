//
//  RemoteCommandManager.swift
//  PodcastPlayer--UIkit
//
//  Created by zhang on 26/05/2025.
//

import MediaPlayer

class RemoteCommandManager {
    static let shared = RemoteCommandManager()
    
    private init() {}
    
    func setupRemoteCommands() {
        let commandCenter = MPRemoteCommandCenter.shared()
        
        commandCenter.playCommand.addTarget { [weak self] _ in
            AudioPlayerManager.shared.play()
            return .success
        }
        
        commandCenter.pauseCommand.addTarget{ [weak self] _ in
            AudioPlayerManager.shared.pause()
            return .success
        }
        
        commandCenter.skipForwardCommand.addTarget{ [weak self] event in
            if let skipEvent = event as? MPSkipIntervalCommandEvent {
                AudioPlayerManager.shared.skipForward(skipEvent.interval)
            } else {
                AudioPlayerManager.shared.skipForward()
            }
            return .success
        }
        
        commandCenter.skipBackwardCommand.addTarget{ [weak self] event in
            if let skipEvent = event as? MPSkipIntervalCommandEvent {
                AudioPlayerManager.shared.skipBackward(skipEvent.interval)
            } else {
                AudioPlayerManager.shared.skipBackward()
            }
            return .success
        }
        
        commandCenter.changePlaybackPositionCommand.addTarget { [weak self] event in
            if let positionEvent = event as? MPChangePlaybackPositionCommandEvent {
                AudioPlayerManager.shared.seek(to: positionEvent.positionTime)
            }
            return .success
        }
        
        commandCenter.skipForwardCommand.preferredIntervals = [30]
        commandCenter.skipBackwardCommand.preferredIntervals = [15]
    }
}
