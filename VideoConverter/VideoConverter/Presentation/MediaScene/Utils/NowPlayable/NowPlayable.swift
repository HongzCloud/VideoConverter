//
//  NowPlayable.swift
//  VideoConverter
//
//  Created by 오킹 on 2022/01/10.
//

import Foundation

import Foundation
import MediaPlayer

protocol NowPlayable: AnyObject {
 
    var defaultAllowsExternalPlayback: Bool { get }

    var defaultCommands: [NowPlayableCommand] { get }

    func handleNowPlayableConfiguration(commands: [NowPlayableCommand],
                                        commandHandler: @escaping (NowPlayableCommand, MPRemoteCommandEvent) -> MPRemoteCommandHandlerStatus) throws

    func handleNowPlayableSessionStart() throws

    func handleNowPlayableSessionEnd()
 
    func handleNowPlayableItemChange(metadata: NowPlayableStaticMetadata)

    func handleNowPlayablePlaybackChange(playing: Bool, metadata: NowPlayableDynamicMetadata)
}

extension NowPlayable {
    
    func configureRemoteCommands(_ commands: [NowPlayableCommand],
                                 commandHandler: @escaping (NowPlayableCommand, MPRemoteCommandEvent) -> MPRemoteCommandHandlerStatus) throws {
  
        guard commands.count > 1 else { throw NowPlayableError.noRegisteredCommands }
 
        for command in NowPlayableCommand.allCases {
 
            command.removeHandler()
   
            if commands.contains(command) {
                command.addHandler(commandHandler)
            }
        }
    }

    func setNowPlayingMetadata(_ metadata: NowPlayableStaticMetadata) {
       
        let nowPlayingInfoCenter = MPNowPlayingInfoCenter.default()
        var nowPlayingInfo = [String: Any]()
        
        NSLog("%@", "**** Set track metadata: title \(metadata.title)")
        nowPlayingInfo[MPNowPlayingInfoPropertyAssetURL] = metadata.assetURL
        nowPlayingInfo[MPNowPlayingInfoPropertyIsLiveStream] = metadata.isLiveStream
        nowPlayingInfo[MPMediaItemPropertyTitle] = metadata.title
        nowPlayingInfo[MPMediaItemPropertyArtist] = metadata.artist
        nowPlayingInfo[MPMediaItemPropertyArtwork] = metadata.artwork
        nowPlayingInfo[MPMediaItemPropertyAlbumArtist] = metadata.albumArtist
        nowPlayingInfo[MPMediaItemPropertyAlbumTitle] = metadata.albumTitle
        
        nowPlayingInfoCenter.nowPlayingInfo = nowPlayingInfo
    }

    func setNowPlayingPlaybackInfo(_ metadata: NowPlayableDynamicMetadata) {
        
        let nowPlayingInfoCenter = MPNowPlayingInfoCenter.default()
        var nowPlayingInfo = nowPlayingInfoCenter.nowPlayingInfo ?? [String: Any]()
        
        NSLog("%@", "**** Set playback info: rate \(metadata.rate), position \(metadata.position), duration \(metadata.duration)")
        nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = metadata.duration
        nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = metadata.position
        nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = metadata.rate
        nowPlayingInfo[MPNowPlayingInfoPropertyDefaultPlaybackRate] = 1.0

        nowPlayingInfoCenter.nowPlayingInfo = nowPlayingInfo
    }
    
    func handleNowPlayableConfiguration(commands: [NowPlayableCommand], commandHandler: @escaping (NowPlayableCommand, MPRemoteCommandEvent) -> MPRemoteCommandHandlerStatus) throws {

        try configureRemoteCommands(commands, commandHandler: commandHandler)
    }
    
    func handleNowPlayableSessionStart() throws {
        
        let audioSession = AVAudioSession.sharedInstance()
         
        try audioSession.setCategory(.playback, mode: .default)
 
         try audioSession.setActive(true)
    }
    
    func handleNowPlayableSessionEnd() {
        do {
            try AVAudioSession.sharedInstance().setActive(false)
        } catch {
            Log.error("Failed to deactivate audio session, error: \(error)")
        }
    }
    
    func handleNowPlayableItemChange(metadata: NowPlayableStaticMetadata) {
        setNowPlayingMetadata(metadata)
    }
    
    func handleNowPlayablePlaybackChange(playing: Bool, metadata: NowPlayableDynamicMetadata) {
        setNowPlayingPlaybackInfo(metadata)
    }
}
