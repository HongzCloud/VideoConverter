//
//  AudioConverter.swift
//  VideoConverter
//
//  Created by 오킹 on 2021/10/22.
//

import Foundation
import AVFoundation
import lame

struct AudioConverter {
    private var inputFile: AVAudioFile?

    init(inputURL: URL) {
        self.inputFile = try? AVAudioFile(forReading: inputURL)
    }
    
    func convertWAV(sampleRate: SampleRate, bitDepth: BitPerChannel, output: URL) -> Bool {
        do {
            //input's info
            guard let inputFile = inputFile else { return false }
            let inputFormat = inputFile.processingFormat
            guard let inputBuffer = AVAudioPCMBuffer(pcmFormat: inputFormat,
                                                     frameCapacity: AVAudioFrameCount(inputFile.length))
            else { return false }
            guard (try? inputFile.read(into: inputBuffer)) != nil else { return false }
            
            //output's info
            let settings = configSettings(formatID: .wav, sampleRate: sampleRate, bitDepth: bitDepth)
            guard let outputFile = createOutputFile(url: output, bitDepth: bitDepth, settings: settings) else { return false }
            guard let outputFormat = createAVAudioFormat(sampleRate: sampleRate, bitDepth: bitDepth, channels: inputFormat.channelCount) else { return false }
            
            //format converting(inputBuffer -> outputBuffer)
            guard let outputBuffer = convertBuffer(inputBuffer, from: inputFormat, to: outputFormat) else { return false }
            
            //write file
            try outputFile.write(from: outputBuffer)
            print("convert success")
        } catch {
            assertionFailure("convert Fail")
            return false
    }
        return true
    }
    
    private func createAVAudioFormat(sampleRate: SampleRate, bitDepth: BitPerChannel, channels: AVAudioChannelCount) -> AVAudioFormat? {
        let commonFormat: AVAudioCommonFormat = bitDepth == .m16 ? .pcmFormatInt16 : .pcmFormatFloat32
        return AVAudioFormat(commonFormat: commonFormat, sampleRate: Double(sampleRate.rawValue), channels: channels, interleaved: false)
    }
  
    private func convertBuffer(_ pcmBuffer: AVAudioPCMBuffer, from inputFormat: AVAudioFormat, to outputFormat: AVAudioFormat) -> AVAudioPCMBuffer? {
        let avConverter = AVAudioConverter(from: inputFormat, to: outputFormat)
        var myError: NSError? = nil
        
        var newBufferAvailable = true
        let inputBlock: AVAudioConverterInputBlock = { inNumPackets, outStatus in
            if newBufferAvailable {
                outStatus.pointee = .haveData
                newBufferAvailable = false
                return pcmBuffer
            } else {
                outStatus.pointee = .noDataNow
                return nil
            }
        }
        
        let convertedBufferFrameCapacity = Int(AVAudioFrameCount(outputFormat.sampleRate)) * Int(pcmBuffer.frameLength) / Int(AVAudioFrameCount(pcmBuffer.format.sampleRate))
        
        let convertedBuffer = AVAudioPCMBuffer(pcmFormat: outputFormat, frameCapacity: AVAudioFrameCount(convertedBufferFrameCapacity) )!
        
        avConverter?.convert(to: convertedBuffer, error: &myError, withInputFrom: inputBlock)
        
        return convertedBuffer
    }
    
    private func createOutputFile(url: URL, bitDepth: BitPerChannel, settings: [String :Any]) -> AVAudioFile? {
        if bitDepth == .m16 {
            return try? AVAudioFile(forWriting: url, settings: settings, commonFormat: .pcmFormatInt16, interleaved: false)
        } else {
            return  try? AVAudioFile(forWriting: url, settings: settings)
        }
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
    
    func convertFLAC(sampleRate: SampleRate, bitDepth: BitPerChannel, output: URL) -> Bool {
        do {
            //input's info
            guard let inputFile = inputFile else { return false }
            let inputFormat = inputFile.processingFormat
            guard let inputBuffer = AVAudioPCMBuffer(pcmFormat: inputFormat,
                                                     frameCapacity: AVAudioFrameCount(inputFile.length))
            else { return false }
            guard (try? inputFile.read(into: inputBuffer)) != nil else { return false }
            
            //output's info
            let settings = configSettings(formatID: .flac, sampleRate: sampleRate, bitDepth: bitDepth)
            guard let outputFile = createOutputFile(url: output, bitDepth: bitDepth, settings: settings) else { return false }
            guard let outputFormat = createAVAudioFormat(sampleRate: sampleRate, bitDepth: bitDepth, channels: inputFormat.channelCount) else { return false }
            
            //format converting(inputBuffer -> outputBuffer)
            guard let outputBuffer = convertBuffer(inputBuffer, from: inputFormat, to: outputFormat) else { return false }
            
            //write file
            try outputFile.write(from: outputBuffer)
            print("convert success")
        } catch {
            assertionFailure("convert Fail")
            return false
    }
        return true
    }
    
    func convertCAF(sampleRate: SampleRate, bitDepth: BitPerChannel, output: URL) -> Bool {
        do {
            //input's info
            guard let inputFile = inputFile else { return false }
            let inputFormat = inputFile.processingFormat
            guard let inputBuffer = AVAudioPCMBuffer(pcmFormat: inputFormat,
                                                     frameCapacity: AVAudioFrameCount(inputFile.length))
            else { return false }
            guard (try? inputFile.read(into: inputBuffer)) != nil else { return false }
            
            //output's info
            let settings = configSettings(formatID: .caf, sampleRate: sampleRate, bitDepth: bitDepth)
            guard let outputFile = createOutputFile(url: output, bitDepth: bitDepth, settings: settings) else { return false }
            guard let outputFormat = createAVAudioFormat(sampleRate: sampleRate, bitDepth: bitDepth, channels: inputFormat.channelCount) else { return false }
            
            //format converting(inputBuffer -> outputBuffer)
            guard let outputBuffer = convertBuffer(inputBuffer, from: inputFormat, to: outputFormat) else { return false }
            
            //write file
            try outputFile.write(from: outputBuffer)
            print("convert success")
        } catch {
            assertionFailure("convert Fail")
            return false
    }
        return true
    }
    
    private let encoderQueue = DispatchQueue(label: "com.audio.encoder.queue")

    func convertMP3(
        output: URL,
        sample: SampleRate,
        bitRate: BitRate,
        onProgress: ((Float) -> (Void))? = nil,
        onComplete: (() -> (Void))? = nil
    ) -> Bool {
        guard let inputFile = inputFile else {
            return false
        }
        let pcmFile: UnsafeMutablePointer<FILE>
        let fileInfo = inputFile.url.lastPathComponent.split(separator: ".")
        if fileInfo[1] != "wav" {
            let outputfileName = fileInfo[0] + ".wav"
            let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent(String(outputfileName)
            )
            guard convertWAV(sampleRate: .m44k, bitDepth: .m16, output: tempURL) else {
                return false
            }

            pcmFile = fopen(tempURL.path, "rb")
        } else {
            pcmFile = fopen(inputFile.url.path, "rb")
        }
        
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
