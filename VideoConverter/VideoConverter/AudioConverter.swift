//
//  AudioConverter.swift
//  VideoConverter
//
//  Created by 오킹 on 2021/10/22.
//

import Foundation
import AVFoundation

struct AudioConverter {
    private var localDocumentsURL: URL
    private var inputFile: AVAudioFile?
    private let outputURL: URL
    
    init(inputURL: URL) {
        self.inputFile = try? AVAudioFile(forReading: inputURL)
        self.localDocumentsURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        self.outputURL = localDocumentsURL
    }
    
    func convertWAV(sampleRate: SampleRate, bitDepth: BitPerChannel) -> Bool {
        do {
            guard let inputFile = inputFile else { return false }
            guard let format = AVAudioFormat(commonFormat: .pcmFormatFloat32,
                                             sampleRate: inputFile.fileFormat.sampleRate,
                                             channels: inputFile.fileFormat.channelCount,
                                             interleaved: false) else { return false }
            guard let inputBuffer = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: AVAudioFrameCount(inputFile.length)) else { return false }

            try inputFile.read(into: inputBuffer)
            guard let floatChannelData = inputBuffer.floatChannelData else { return false }
            let frameLength = Int(inputBuffer.frameLength)
            let outputBuffers = createBuffers(channelData: floatChannelData, frameLength: frameLength, channelNum: Int32(inputFile.fileFormat.channelCount))
            let settings = configSettings(formatID: .wav, sampleRate: sampleRate, bitDepth: bitDepth)
 
            saveWav(outputBuffers, settings: settings)
          
        } catch {
            assertionFailure("convert fail")
            return false
        }
        
        return true
    }
    
    func convertAAC(sample: SampleRate, bitRate: BitRate) -> Bool {
        do {
            guard let inputFile = inputFile else { return false }
            guard let format = AVAudioFormat(commonFormat: .pcmFormatFloat32,
                                             sampleRate: inputFile.fileFormat.sampleRate,
                                             channels: inputFile.fileFormat.channelCount,
                                             interleaved: false) else { return false }
            guard let inputBuffer = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: AVAudioFrameCount(inputFile.length)) else { return false }

            try inputFile.read(into: inputBuffer)
            guard let floatChannelData = inputBuffer.floatChannelData else { return false }
            let frameLength = Int(inputBuffer.frameLength)
            let outputBuffers = createBuffers(channelData: floatChannelData, frameLength: frameLength, channelNum: Int32(inputFile.fileFormat.channelCount))
            let settings = configSettings(formatID: .aac, sampleRate: sample, bitDepth: .m16, bitRate: bitRate)
 
            saveAAC(outputBuffers, settings: settings)
          
        } catch {
            assertionFailure("convert fail")
            return false
        }
        
        return true
    }
    
    func convertFLAC(sample: SampleRate, bitDepth: BitPerChannel) -> Bool {
        do {
            guard let inputFile = inputFile else { return false }
            guard let format = AVAudioFormat(commonFormat: .pcmFormatFloat32,
                                             sampleRate: inputFile.fileFormat.sampleRate,
                                             channels: inputFile.fileFormat.channelCount,
                                             interleaved: false) else { return false }
            guard let inputBuffer = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: AVAudioFrameCount(inputFile.length)) else { return false }

            try inputFile.read(into: inputBuffer)
            guard let floatChannelData = inputBuffer.floatChannelData else { return false }
            let frameLength = Int(inputBuffer.frameLength)
            let outputBuffers = createBuffers(channelData: floatChannelData, frameLength: frameLength, channelNum: Int32(inputFile.fileFormat.channelCount))
            let settings = configSettings(formatID: .flac, sampleRate: sample, bitDepth: bitDepth)
 
            saveFLAC(outputBuffers, settings: settings)
          
        } catch {
            assertionFailure("convert fail")
            return false
        }
        
        return true
    }
        
    private func saveWav(_ buf: [[Float]], settings: [String : Any]) {
        guard let inputFile = inputFile else { return }
        if let format = AVAudioFormat(commonFormat: .pcmFormatFloat32, sampleRate: 44100, channels: inputFile.fileFormat.channelCount, interleaved: false) {
            let pcmBuf = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: AVAudioFrameCount(buf[0].count))
           
            for i in 0..<Int(inputFile.fileFormat.channelCount) {
                memcpy(pcmBuf?.floatChannelData?[i], buf[i], 4 * buf[i].count)
            }
            
            pcmBuf?.frameLength = UInt32(buf[0].count)

            let fileHelper = FileHelper()
            do {
                let outputfileName = String(inputFile.url.lastPathComponent.split(separator: ".")[0]) + ".wav"
                let outputURL = fileHelper.createOutputFileURL(outputfileName)
                let audioFile = try AVAudioFile(forWriting: outputURL, settings: settings)
                try audioFile.write(from: pcmBuf!)
            } catch {
                assertionFailure("save fail")
            }
        }
    }
    
    private func saveAAC(_ buf: [[Float]], settings: [String : Any]) {
        guard let inputFile = inputFile else { return }
        if let format = AVAudioFormat(commonFormat: .pcmFormatFloat32, sampleRate: 44100, channels: inputFile.fileFormat.channelCount, interleaved: false) {
            let pcmBuf = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: AVAudioFrameCount(buf[0].count))
           
            for i in 0..<Int(inputFile.fileFormat.channelCount) {
                memcpy(pcmBuf?.floatChannelData?[i], buf[i], 4 * buf[i].count)
            }
            
            pcmBuf?.frameLength = UInt32(buf[0].count)

            let fileHelper = FileHelper()
            do {
                let outputfileName = String(inputFile.url.lastPathComponent.split(separator: ".")[0]) + ".aac"
                let outputURL = fileHelper.createOutputFileURL(outputfileName)
                let audioFile = try AVAudioFile(forWriting: outputURL, settings: settings)
                try audioFile.write(from: pcmBuf!)
            } catch {
                assertionFailure("save fail")
            }
        }
    }
    
    private func saveFLAC(_ buf: [[Float]], settings: [String : Any]) {
        guard let inputFile = inputFile else { return }
        if let format = AVAudioFormat(commonFormat: .pcmFormatFloat32, sampleRate: 44100, channels: inputFile.fileFormat.channelCount, interleaved: false) {
            let pcmBuf = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: AVAudioFrameCount(buf[0].count))
           
            for i in 0..<Int(inputFile.fileFormat.channelCount) {
                memcpy(pcmBuf?.floatChannelData?[i], buf[i], 4 * buf[i].count)
            }
            
            pcmBuf?.frameLength = UInt32(buf[0].count)

            let fileHelper = FileHelper()
            do {
                let outputfileName = String(inputFile.url.lastPathComponent.split(separator: ".")[0]) + ".flac"
                let outputURL = fileHelper.createOutputFileURL(outputfileName)
                let audioFile = try AVAudioFile(forWriting: outputURL, settings: settings)
                try audioFile.write(from: pcmBuf!)
            } catch {
                assertionFailure("save fail")
            }
        }
    }
        
    private func createBuffers(channelData: UnsafePointer<UnsafeMutablePointer<Float>>, frameLength: Int, channelNum: Int32) -> [[Float]] {
        var buffers = [[Float]]()
        for i in 0..<channelNum {
            buffers.append(Array(UnsafeBufferPointer(start: channelData[Int(i)], count: frameLength)))
        }
        return buffers
    }

    private func configSettings(formatID: FileFormat, sampleRate: SampleRate, bitDepth: BitPerChannel, bitRate: BitRate = .m192k) -> [String : Any] {
        guard let inputFile = inputFile else { return [String:Any]() }
        
        var settings: [String : Any] = [String : Any]()
        settings.updateValue(formatID.rawValue, forKey: AVFormatIDKey)
        settings.updateValue(sampleRate.rawValue, forKey: AVSampleRateKey)
        settings.updateValue(bitDepth.rawValue, forKey: AVLinearPCMBitDepthKey)
        settings.updateValue(bitRate.rawValue, forKey: AVEncoderBitRateKey)
        settings.updateValue(inputFile.fileFormat.channelCount, forKey: AVNumberOfChannelsKey)

        return settings
    }
}

