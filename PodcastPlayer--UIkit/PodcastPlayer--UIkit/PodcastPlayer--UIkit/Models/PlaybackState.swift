//
//  PlaybackState.swift
//  PodcastPlayer--UIkit
//
//  Created by zhang on 26/05/2025.
//

import Foundation

enum PlaybackState {
    case stopped
    case playing
    case paused
    case buffering
    case error(String)
}

struct PlayerState {
    var currentEpisode: Episode?
    var playbackState: PlaybackState = .stopped
    var currentTime: TimeInterval = 0
    var duration: TimeInterval = 0
    var playbackRate: Float = 1.0
    var volume: Float = 1.0
}
