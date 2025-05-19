//
//  AudioPlayerService.swift
//  PodWave
//
//  Created by zhang on 18/05/2025.
//

import Foundation
import AVFoundation
import MediaPlayer

class AudioPlayerService: ObservableObject {
    static let shared = AudioPlayerService()
    
    private var player: AVPlayer?
    private var playerItem: AVPlayerItem?
    
    @Published var isPlaying = false
    @Published var currentTime: TimeInterval = 0
    @Published var duration: TimeInterval = 0
    @Published var currentEpisode: Episode?
    
    private var timeObserver: Any?
    
    init() {
        setupRemoteTransportControls()
        setupNotifications()
    }
    
    func play(episode: Episode) {
        guard let url = URL(string: episode.audioUrl) else { return }
        
        currentEpisode = episode
        playerItem = AVPlayerItem(url: url)
        player = AVPlayer(playerItem: playerItem)
        
        if episode.playbackPosition > 0 {
            player?.seek(to: CMTime(seconds: episode.playbackPosition, preferredTimescale: 1000))
        }
        
        timeObserver = player?.addPeriodicTimeObserver(forInterval: CMTime(seconds: 1, preferredTimescale: 1000), queue: .main) { [weak self] time in
            self?.currentTime = time.seconds
            self?.updateNowPlaying()
        }
        
        if let duration = playerItem?.asset.duration.seconds, !duration.isNaN {
            self.duration = duration
        }
        
        player?.play()
        isPlaying = true
        updateNowPlaying()
    }
    
    func playPause() {
        if isPlaying {
            player?.pause()
        } else {
            player?.play()
        }
        isPlaying = !isPlaying
        updateNowPlaying()
    }
    
    func stop() {
        player?.pause()
        isPlaying = false
        
        if let episode = currentEpisode {
            
            
        }
        
        updateNowPlaying()
    }
    
    func seek(to time: TimeInterval) {
        player?.seek(to: CMTime(seconds: time, preferredTimescale: 1000))
        currentTime = time
        updateNowPlaying()
    }
    
    private func setupRemoteTransportControls() {
        let commandCenter = MPRemoteCommandCenter.shared()
        
        commandCenter.playCommand.addTarget { [weak self] event in
            guard let self = self else { return .commandFailed}
            if !self.isPlaying {
                self.playPause()
                return .success
            }
            return .commandFailed
        }
        
        commandCenter.pauseCommand.addTarget { [weak self] event in
            guard let self = self else { return .commandFailed }
            if self.isPlaying {
                self.playPause()
                return .success
            }
            return .commandFailed
        }
        
        commandCenter.skipForwardCommand.addTarget {[weak self] event in
            guard let self = self else { return .commandFailed}
            self.seek(to: self.currentTime + 30)
            return .success
        }
    }
    
    private func setupNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleInterruption), name: AVAudioSession.interruptionNotification, object: nil)
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Failed to set audio session category: \(error)")
        }
    }
    
    @objc private func handleInterruption(notification: Notification) {
        guard let userInfo = notification.userInfo,
              let typeValue = userInfo[AVAudioSessionInterruptionTypeKey] as? UInt,
              let type = AVAudioSession.InterruptionType(rawValue: typeValue) else { return }
        
        switch type {
        case .began:
            if isPlaying {
                playPause()
            }
        case .ended:
            guard let optionsValue = userInfo[AVAudioSessionInterruptionTypeKey] as? UInt else { return }
            let options = AVAudioSession.InterruptionOptions(rawValue: optionsValue)
            if options.contains(.shouldResume) {
                if !isPlaying {
                    playPause()
                }
            }
        @unknown default:
            break
        }
    }
    
    private func updateNowPlaying() {
        guard let episode = currentEpisode else { return }
        
        var nowPlayingInfo = [String: Any]()
        nowPlayingInfo[MPMediaItemPropertyTitle] = episode.title
        nowPlayingInfo[MPMediaItemPropertyArtist] = "Podcast"
        nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = currentTime
        nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = duration
        nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = isPlaying ? 1.0 : 0.0
        
        if let imageUrl = episode.imageUrl, let url = URL(string: imageUrl) {
            
        }
        
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    }
    
    deinit {
        if let timeObserver = timeObserver {
            player?.removeTimeObserver(timeObserver)
        }
        NotificationCenter.default.removeObserver(self)
    }
}
