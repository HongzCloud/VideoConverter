//
//  AudioConverter.swift
//  VideoConverter
//
//  Created by 오킹 on 2021/10/22.
//

import Foundation
import AVFoundation
import lame

final class AudioConverter {
    private var asset: AVAsset
    private var assetReader: AVAssetReader!
    private var assetWriter: AVAssetWriter!
    private var assetReaderAudioOutput: AVAssetReaderTrackOutput!
    private var assetWriterAudioInput: AVAssetWriterInput!
    private var assetAudioTrack:AVAssetTrack? = nil
    
    init(asset: AVAsset) {
        self.asset = asset
    }
    
    //video -> wav, caf, m4a
    func convert(output: URL, outputType: AVFileType,  outputSettins: [String : Any], completion: (() -> Void)?) {
        let convertAudioQueueLabel = "convertAudioQueue"
        let convertAudioQueue = DispatchQueue(label: convertAudioQueueLabel)
        
        //load asset data
        asset.loadValuesAsynchronously(forKeys: ["tracks"], completionHandler: { [self] in
            var success = true
            var localError:NSError?
            success = (asset.statusOfValue(forKey: "tracks", error: &localError) == AVKeyValueStatus.loaded)
            

            if (success) {
                success = setupAssetReaderAndWriter(output: output,
                                                    outputSettings: outputSettins,
                                                    fileType: outputType,
                                                    dispatchQueue: convertAudioQueue)
            } else {
                print("Failed setting up Asset Reader and Writer")
            }
            if (success) {
                success = self.startAssetReaderAndWriter(dispatchQueue: convertAudioQueue, completion: completion)
                return
            } else {
                print("Failed to start Asset Reader and Writer")
            }
            
        })
    }
    
    private let encoderQueue = DispatchQueue(label: "com.audio.encoder.queue")

    //must be inputFile: .wav, sampleRate: 44100, bitDepth: 16
    func convertMP3(
        output: URL,
        sample: SampleRate,
        bitRate: BitRate,
        onProgress: ((Float) -> (Void))? = nil,
        onComplete: (() -> (Void))? = nil
    ) -> Bool {
        let avUrlAsset = asset as! AVURLAsset
        let pcmFile: UnsafeMutablePointer<FILE>
        
        pcmFile = fopen(avUrlAsset.url.path, "rb")

        encoderQueue.async {
            
            let lame = lame_init()
            
            lame_set_in_samplerate(lame, 44100)
            lame_set_out_samplerate(lame, Int32(sample.rawValue))
            lame_set_brate(lame, Int32(bitRate.rawValue))
            lame_set_quality(lame, 4)
            lame_set_VBR(lame, vbr_default)
            lame_init_params(lame)
            
            fseek(pcmFile, 0 , SEEK_END)
            let fileSize = ftell(pcmFile)
            // Skip file header.
            let fileHeader = 4 * 1024
            fseek(pcmFile, fileHeader, SEEK_SET)
            
            let mp3File: UnsafeMutablePointer<FILE> = fopen(output.path, "wb")
            
            let pcmSize = 1024 * 8
            let pcmbuffer = UnsafeMutablePointer<Int16>.allocate(capacity: Int(pcmSize * 2))
            
            let mp3Size: Int32 = 1024 * 8
            let mp3buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: Int(mp3Size))
            
            var write: Int32 = 0
            var read = 0
            
            repeat {
                
                let size = MemoryLayout<Int16>.size * 2
                read = fread(pcmbuffer, size, pcmSize, pcmFile)
                // Progress
                if read != 0 {
                    let progress = Float(ftell(pcmFile)) / Float(fileSize)
                    
                    DispatchQueue.main.sync {
                        if let onProgress = onProgress {
                            onProgress(progress)
                        }
                    }
                }
                
                if read == 0 {
                    write = lame_encode_flush(lame, mp3buffer, mp3Size)
                } else {
                    write = lame_encode_buffer_interleaved(lame, pcmbuffer, Int32(read), mp3buffer, mp3Size)
                }
                
                fwrite(mp3buffer, Int(write), 1, mp3File)
                
            } while read != 0
            
            // Clean up
            lame_close(lame)
            fclose(mp3File)
            fclose(pcmFile)
            
            pcmbuffer.deallocate()
            mp3buffer.deallocate()
            
            DispatchQueue.main.sync {
                if let onComplete = onComplete {
                    onComplete()
                }
            }
        }
        
        return true
    }
    
    func fileFormatToFileType(fileFormat: FileFormat) -> AVFileType {
        switch fileFormat {
        case .caf:
            return AVFileType.caf
        case .wav:
            return AVFileType.wav
        case .m4a:
            return AVFileType.m4a
        case .mp3:
            //video -> wav -> lame(encoder) mp3
            return AVFileType.wav
        default:
            return AVFileType.m4a
        }
    }
    
    //압축 오디오파일: bitrate만 설정, 무압축 오디오파일: bitDepth만 설정
    func outputSetting(format: FileFormat, sampleRate: SampleRate, bitRate: BitRate?, bitDepth: BitPerChannel?) -> [String : Any] {
        var channelLayout = AudioChannelLayout()
        memset(&channelLayout, 0, MemoryLayout<AudioChannelLayout>.size);
        channelLayout.mChannelLayoutTag = kAudioChannelLayoutTag_Stereo;
        
        var outputSettings = [String : Any]()
        outputSettings[AVFormatIDKey] = format.rawValue
        outputSettings[AVSampleRateKey] = sampleRate.rawValue
        outputSettings[AVNumberOfChannelsKey] = 2
        outputSettings[AVChannelLayoutKey] = NSData(bytes:&channelLayout, length:MemoryLayout<AudioChannelLayout>.size)
        if let bitDepth = bitDepth {
            outputSettings[AVLinearPCMIsBigEndianKey] = false
            outputSettings[AVLinearPCMIsFloatKey] = false
            outputSettings[AVLinearPCMIsNonInterleaved] = false
            outputSettings[AVLinearPCMBitDepthKey] = bitDepth.rawValue
        }
        if let bitRate = bitRate {
            outputSettings[AVEncoderBitRateKey] = bitRate.rawValue
        }
        
        return outputSettings
    }
    
    private func setupAssetReaderAndWriter(output: URL, outputSettings: [String : Any], fileType: AVFileType, dispatchQueue: DispatchQueue) -> Bool {
        let audioTracks = asset.tracks(withMediaType: AVMediaType.audio)
        
        if (audioTracks.count > 0) {
            self.assetAudioTrack = audioTracks[0]
        }
        
        guard let assetAudioTrack = assetAudioTrack else { return false }
        
        let decompressionAudioSettings:[String : Any] = [
            AVFormatIDKey:Int(kAudioFormatLinearPCM)
        ]
   
        do {
            self.assetReader = try AVAssetReader(asset: asset)
            self.assetWriter = try AVAssetWriter(outputURL: output, fileType: fileType)
            self.assetReaderAudioOutput = AVAssetReaderTrackOutput(track: assetAudioTrack, outputSettings: decompressionAudioSettings)
            self.assetWriterAudioInput = AVAssetWriterInput(mediaType: AVMediaType.audio, outputSettings: outputSettings)
            
            self.assetReader.add(assetReaderAudioOutput)
            self.assetWriter.add(assetWriterAudioInput)
        } catch {
            print("Fail setup AVAssetReader, AVAssetWriter")
        }
        
        return true
    }
    
    private func startAssetReaderAndWriter(dispatchQueue: DispatchQueue, completion: (() -> Void)?) -> Bool {
        print("Writing Asset...")
        assetWriter.startWriting()
        assetReader.startReading()
        assetWriter.startSession(atSourceTime: CMTime.zero)
        
        assetWriterAudioInput.requestMediaDataWhenReady(on: dispatchQueue, using: {
            
            while(self.assetWriterAudioInput.isReadyForMoreMediaData ) {
                var sampleBuffer = self.assetReaderAudioOutput.copyNextSampleBuffer()
                if(sampleBuffer != nil) {
                    self.assetWriterAudioInput.append(sampleBuffer!)
                    sampleBuffer = nil
                } else {
                    self.assetWriterAudioInput.markAsFinished()
                    self.assetReader.cancelReading()
                    self.assetWriter.finishWriting {
                        completion?()
                        print("Complete Writing Asset")
                    }
                    break
                }
            }
        })
        return true
    }
}
