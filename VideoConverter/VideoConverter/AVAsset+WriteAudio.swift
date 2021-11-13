//
//  AVAsset+WriteAudio.swift
//  VideoConverter
//
//  Created by 오킹 on 2021/11/01.
//

import Foundation
import Photos

extension AVAsset {

    func writeAudio(_ output: URL, sampleRate: SampleRate, bitDepth: BitPerChannel = .m16, bitRate: BitRate = .m192k, format: FileFormat, completion: @escaping (Bool, Error?) -> ()) {
        do {
            let audioAsset = try self.audioAsset()
            audioAsset.writeToURL(output, completion: { _, _ in
                let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent("tempM4A.m4a")
                let audioConverter = AudioConverter(inputURL: tempURL)
                switch format {
                case .aac:
                    completion(audioConverter.convertAAC(sampleRate: sampleRate, bitRate: bitRate, output: output), nil)
                case .caf:
                    completion(audioConverter.convertCAF(sampleRate: sampleRate, bitDepth: bitDepth, output: output), nil)
                case .flac:
                    completion(audioConverter.convertFLAC(sampleRate: sampleRate, bitDepth: bitDepth, output: output), nil)
                case .mp3:
                    completion(audioConverter.convertMP3(output: output, sample: sampleRate, bitRate: bitRate), nil)
                case .wav:
                    completion(audioConverter.convertWAV(sampleRate: .m08k, bitDepth: .m16, output: output), nil)
                }
            })
        } catch (let error as NSError){
            completion(false, error)
        }
    }

    private func writeToURL(_ url: URL, completion: @escaping (Bool, Error?) -> ()) {

        guard let exportSession = AVAssetExportSession(asset: self, presetName: AVAssetExportPresetAppleM4A) else {
            completion(false, nil)
            return
        }
        let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent("tempM4A.m4a")
        exportSession.outputFileType = .m4a
        exportSession.outputURL      = tempURL

        exportSession.exportAsynchronously {
            switch exportSession.status {
            case .completed:
                completion(true, nil)
            case .unknown, .waiting, .exporting, .failed, .cancelled:
                completion(false, nil)
            default:
                completion(false, nil)
            }
        }
    }

    func audioAsset() throws -> AVAsset {

        let composition = AVMutableComposition()
        let audioTracks = tracks(withMediaType: .audio)

        for track in audioTracks {

            let compositionTrack = composition.addMutableTrack(withMediaType: .audio, preferredTrackID: kCMPersistentTrackID_Invalid)
            try compositionTrack?.insertTimeRange(track.timeRange, of: track, at: track.timeRange.start)
            compositionTrack?.preferredTransform = track.preferredTransform
        }
        return composition
    }
}
