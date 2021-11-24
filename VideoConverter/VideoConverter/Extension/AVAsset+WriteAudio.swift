//
//  AVAsset+WriteAudio.swift
//  VideoConverter
//
//  Created by 오킹 on 2021/11/01.
//

import Foundation
import Photos

extension AVAsset {
    func writeAudio(output: URL, format: FileFormat, sampleRate: SampleRate, bitRate: BitRate?, bitDepth: BitPerChannel?, completion: @escaping () -> Void) {
 
        let assetConverter = AudioConverter(asset: self)
        switch format {
        case .mp3:
            //lame encoder needs wav file
            let tempOutput = FileHelper().createFileURL("temp.wav", in: .temporary)
            let tempSetting = assetConverter.outputSetting(format: .wav,
                                                           sampleRate: .m44k,
                                                           bitRate: nil,
                                                           bitDepth: .m16)
            let outputType = assetConverter.fileFormatToFileType(fileFormat: .mp3)
            assetConverter.convert(output: tempOutput,
                                   outputType: outputType,
                                   outputSettins: tempSetting,
                                   completion: {
                //wav -> mp3
                let asset = AVAsset(url: tempOutput)
                AudioConverter(asset: asset).convertMP3(output: output,
                                                        sample: sampleRate,
                                                        bitRate: bitRate!,
                                                        onProgress: nil,
                                                        onComplete: completion)
            })
        default:
            //wav, caf, m4a
            let settings = assetConverter.outputSetting(format: format,
                                         sampleRate: sampleRate,
                                         bitRate: bitRate,
                                         bitDepth: bitDepth)
            let outputType = assetConverter.fileFormatToFileType(fileFormat: format)
            assetConverter.convert(output: output, outputType: outputType, outputSettins: settings, completion: nil)
        }
    }
}
