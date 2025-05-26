//
//  AudioPlayerManager.swift
//  PodcastPlayer--UIkit
//
//  Created by zhang on 26/05/2025.
//

import AVFoundation
import MediaPlayer

protocol AudioPlayerDelegate: AnyObject {
    func audioPlayerDidUpdatePlaybackState(_ state: PlaybackState)
    func audioPlayerDidUpdateCurrentTime(_ time: TimeInterval)
    func audioPlayerDidFinishPlaying()
}

class AudioPlayerManager: NSObject {
    static let shared = AudioPlayerManager()
    
    private var player: AVPlayer?
    private var playerItem: AVPlayerItem?
    private var timeObserver: Any?
    
    weak var delegate: AudioPlayerDelegate?
    
    private(set) var currentEpisode: Episode?
    private(set) var playbackState: PlaybackState = .stopped
    private(set) var currentTime: TimeInterval = 0
    private(set) var duration: TimeInterval = 0
    
    override init() {
        super.init()
        setupNotifications()
    }
    
    deinit {
        if let timeObserver = timeObserver {
            player?.removeTimeObserver(timeObserver)
        }
        NotificationCenter.default.removeObserver(self)
    }
    
    func playEpisode(_ episode: Episode) {
        currentEpisode = episode
        
        let url: URL
        if episode.isDownloaded, let localPath = episode.localFileURL {
            url = URL(fileURLWithPath: localPath)
        } else {
            guard let audioURL = URL(string: episode.audioURL) else { return }
            url = audioURL
        }
        
        playerItem = AVPlayerItem(url: url)
        player = AVPlayer(playerItem: playerItem)
        
        setupTimeObserver()
        updateNowPlayingInfo()
        
        if episode.playbackPosition > 0 {
            seek(to: episode.playbackPosition)
        }
        
        play()
    }
    
    func play() {
        player?.play()
        playbackState = .playing
        delegate?.audioPlayerDidUpdatePlaybackState(.playing)
        updateNowPlayingInfo()
    }
    
    func pause() {
        player?.pause()
        playbackState = .paused
        delegate?.audioPlayerDidUpdatePlaybackState(.paused)
        saveCurrentPlaybackPosition()
    }
    
    func stop() {
        player?.pause()
        player = nil
        playerItem = nil
        playbackState = .stopped
        currentTime = 0
        delegate?.audioPlayerDidUpdatePlaybackState(.stopped)
        clearNowPlayingInfo()
    }
    
    func seek(to time: TimeInterval) {
        let cmTime = CMTime(seconds: time, preferredTimescale: 600)
        player?.seek(to: cmTime)
        currentTime = time
        delegate?.audioPlayerDidUpdateCurrentTime(time)
    }
    
    func skipForward(_ seconds: TimeInterval = 30) {
        let newTime = min(currentTime + seconds, duration)
        seek(to: newTime)
    }
    
    func skipBackward(_ seconds: TimeInterval = 15) {
        let newTime = min(currentTime - seconds, 0)
        seek(to: newTime)
    }
    
    func setPlaybackRate(_ rate: Float) {
        player?.rate = rate
    }
    
    private func setupTimeOnserver() {
        timeObserver = player?.addPeriodicTimeObserver(
            forInterval: CMTime(seconds: 1, preferredTimescale: 600),
            queue: .main
        ){[weak self] time in
            self?.currentTime = time.seconds
            self?.delegate?.audioPlayerDidUpdateCurrentTime(time.seconds)
        }
    }
    
    private func setupNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(playerDidFinishPlaying),
            name: .AVPlayerItemFailedToPlayToEndTime,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(playerDidFailToPlay),
            name: .AVPlayerItemFailedToPlayToEndTime,
            object: nil
        )
    }
    
    @objc private func playerDidFinishPlaying() {
        delegate?.audioPlayerDidFinishPlaying()
        playbackState = .stopped
    }
    
    @objc private func playerDidFailToPlay() {
        playbackState = .error("Failed to play episode")
        delegate?.audioPlayerDidUpdatePlaybackState(playbackState)
    }
    
    private func saveCurrentPlaybackPosition() {
        guard let episode = currentEpisode else { return }
        CoreDataManager.shared.updateEpisodePlaybackPosition(episode.id, position: currentTime)
    }
    
    private func updateNowPlayingInfo() {
        guard let episode = currentEpisode else { return }
        
        var nowPlayingInfo: [String: Any] = [
            MPMediaItemPropertyTitle: episode.title,
            MPMediaItemPropertyArtist: episode.podcastTitle,
            MPNowPlayingInfoPropertyElapsedPlaybackTime: currentTime,
            MPMediaItemPropertyPlaybackDuration: duration,
            MPNowPlayingInfoPropertyPlaybackRate: playbackState == .playing ? 1.0 : 0.0
        ]
        
        if let imageURL = episode.imageURL {
            
        }
        
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    }
    
    private func clearNowPlayingInfo() {
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nil
    }
}
