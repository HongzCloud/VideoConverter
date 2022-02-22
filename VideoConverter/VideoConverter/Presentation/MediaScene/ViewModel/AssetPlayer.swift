//
//  AssetPlayer.swift
//  VideoConverter
//
//  Created by 오킹 on 2022/01/09.
//

import AVFoundation
import MediaPlayer

class AssetPlayer {

    enum PlayerState {
        case stopped
        case playing
        case paused
    }
    
    // MARK: - Singleton
    
    static let shared = AssetPlayer()
    
    // MARK: - Properties
    
    private(set) var player: AVPlayer!
    private var nowPlayableBehavior: NowPlayable!
    
    var playerState: PlayerState = .stopped {
        didSet {
            Log.info(("**** Set player state \(playerState)"))
            NotificationCenter.default.post(name: Notification.Name(rawValue: "playerStateDidChanged"), object: self)
        }
    }
    
    private var itemObserver: NSKeyValueObservation!
    private var rateObserver: NSKeyValueObservation!
    private var statusObserver: NSObjectProtocol!
    
    private var nextTrackClosure: (() -> Void)?
    private var previousTrackClosure: (() -> Void)?
    
    // MARK: - Init Properties
    
    func initPlayer(url: URL, nowPlayableBehavior: NowPlayable) {
        self.player = AVPlayer(url: url)
        self.nowPlayableBehavior = nowPlayableBehavior
        
        
        try! nowPlayableBehavior.handleNowPlayableConfiguration(commands: nowPlayableBehavior.defaultCommands, commandHandler: handleCommand(command:event:))

        if self.player.currentItem != nil {
  
            try! nowPlayableBehavior.handleNowPlayableSessionStart()

            itemObserver = player.observe(\.currentItem, options: .initial) {
                [unowned self] _, _ in
                self.handlePlayerItemChange()
            }
            
            rateObserver = player.observe(\.rate, options: .initial) {
                [unowned self] _, _ in
                self.handlePlaybackChange()
            }
            
            statusObserver = player.observe(\.currentItem?.status, options: .initial) {
                [unowned self] _, _ in
                self.handlePlaybackChange()
            }
    
        }
 
            play()
    }
    
    // MARK: - Control Player
    
    private func seek(to position: TimeInterval) {
        self.player.seek(to: CMTime(seconds: position, preferredTimescale: 1))
    }
    
    func play() {
        switch playerState {
            
        case .stopped:
            playerState = .playing
            player.play()
            
            handlePlayerItemChange()
            
        case .playing:
            player.play()

        case .paused:
            playerState = .playing
            player.play()

        }
    }
    
    func pause() {
        switch playerState {
            
        case .stopped:
            break
 
        case .playing:
            playerState = .paused
            player.pause()

        case .paused:
            break
        }
    }
    
    func forward(to second: Double) {
        let currentTime = CMTimeGetSeconds(player.currentTime())
        
        if let currentItem = player.currentItem {
            if currentTime > currentItem.duration.seconds - 2.0 {
                self.nextTrackClosure?()
                return
            }
        }
    
        var newTime = currentTime + second
        let duration = player.currentItem!.asset.duration
        
        if newTime > CMTimeGetSeconds(duration) {
            newTime = CMTimeGetSeconds(duration)
        }
        
        let time = CMTimeMake(value: Int64(newTime * 1000), timescale: 1000)
        
        player.seek(to: time)
    }
    
    func backward(to second: Double) {
        let currentTime = CMTimeGetSeconds(player.currentTime())
    
        if currentTime < 2.0 {
            previousTrackClosure?()
        }
        
        var newTime = currentTime - 10.0
        
        if newTime < 0 {
            newTime = 0
        }
        
        let time = CMTimeMake(value: Int64(newTime * 1000), timescale: 1000)
        player.seek(to: time)
    }
    
    func nextTrack(closure: @escaping () -> Void) {
        nextTrackClosure = closure
    }
    
    func previousTrack(closure: @escaping () -> Void) {
        previousTrackClosure = closure
    }
    
    // MARK: - Control Remote Commands
    
    func handlePlayerItemChange() {
        
        guard playerState != .stopped else { return }
        
        guard let currentItem = player.currentItem else { optOut(); return }
        let asset = currentItem.asset as! AVURLAsset
 
        let metadata = NowPlayableStaticMetadata(assetURL: asset.url, isLiveStream: false, title: asset.url.lastPathComponent, artist: nil, artwork: nil, albumArtist: nil, albumTitle: nil)
        
        nowPlayableBehavior.handleNowPlayableItemChange(metadata: metadata)
    }
    
    func handlePlaybackChange() {
        guard let currentItem = self.player.currentItem else { return }
        guard currentItem.status == .readyToPlay else { return }
        
        let isPlaying = playerState == .playing
        let metadata = NowPlayableDynamicMetadata(rate: player.rate,
                                                  position: Float(currentItem.currentTime().seconds),
                                              duration: Float(currentItem.duration.seconds))
    
        nowPlayableBehavior.handleNowPlayablePlaybackChange(playing: isPlaying, metadata: metadata)
    }
    
    func changeMedia(url: URL) {
        let item = AVAsset(url: url)
//        /self.player.currentItem = item
    }
    
    private func handleCommand(command: NowPlayableCommand, event: MPRemoteCommandEvent) -> MPRemoteCommandHandlerStatus {
        
        switch command {
            
        case .pause:
            pause()
            
        case .play:
            play()
            
        case .stop:
            optOut()
            
        case .nextTrack:
            nextTrackClosure?()
    
        case .previousTrack:
            previousTrackClosure?()
    
        case .changePlaybackPosition:
            guard let event = event as? MPChangePlaybackPositionCommandEvent else { return .commandFailed }
            seek(to: event.positionTime)

        default:
            break
        }
        
        return .success
    }
    
    // Stop the playback session.
    
    func optOut() {
        
        itemObserver = nil
        rateObserver = nil
        statusObserver = nil
        
        player.pause()
        playerState = .stopped
        
        nowPlayableBehavior.handleNowPlayableSessionEnd()
    }
}
