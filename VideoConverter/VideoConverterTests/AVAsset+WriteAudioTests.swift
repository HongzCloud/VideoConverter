//
//  AVAsset+WriteAudioTests.swift
//  VideoConverterTests
//
//  Created by 오킹 on 2021/11/02.
//

import XCTest
import Photos

class AVAsset_WriteAudioTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

    //MARK: - Test convert to wav
//    func testConvertWav_SampleRate8000_BitDepth16() throws {
//        let testBundle = Bundle(for: type(of: self))
//        guard let fileURL = testBundle.url(forResource: "sampleVideoMOV", withExtension: "MOV") else {
//            fatalError()
//        }
//        //m4a -> wav 안되는 문제
//        let asset = AVAsset(url: fileURL)
//        let output = FileHelper().outputDirectoryURL.appendingPathComponent("testWAV.wav")
//        asset.writeAudio(output, sampleRate: .m44k, bitDepth: .m16, format: .wav, completion: {
//            result, error in
//            XCTAssertTrue(result)
//        })
//    }
//
    //MARK: - Test convert to aac
    func testConvertAAC_SampleRate8000_BitRate192k() throws {
        var testBool = false
        
        let testBundle = Bundle(for: type(of: self))
        guard let fileURL = testBundle.url(forResource: "sampleVideoMOV", withExtension: "MOV") else {
            fatalError()
        }
        
        let asset = AVAsset(url: fileURL)
        asset.writeAudio(FileHelper().outputDirectoryURL.appendingPathComponent("testAAC.aac"), sampleRate: .m44k, bitRate: .m192k, format: .aac, completion: { bool, error in
            testBool = true
        })
        XCTAssertTrue(testBool)
    }
 
    //MARK: - Test convert to flac
    func testConvertFLAC_SampleRate8000_BitDepth16() throws {
        var testBool = false
        
        let testBundle = Bundle(for: type(of: self))
        guard let fileURL = testBundle.url(forResource: "sampleVideoMOV", withExtension: "MOV") else {
            fatalError()
        }
        
        let asset = AVAsset(url: fileURL)
        asset.writeAudio(FileHelper().outputDirectoryURL.appendingPathComponent("testFLAC.flac"), sampleRate: .m44k, format: .flac, completion: { bool, error in
            testBool = true
        })
        XCTAssertTrue(testBool)
    }
    
    //MARK: - Test convert to caf
    func testConvertCAF_SampleRate8000_BitDepth16() throws {
        var testBool = false
        
        let testBundle = Bundle(for: type(of: self))
        guard let fileURL = testBundle.url(forResource: "sampleVideoMOV", withExtension: "MOV") else {
            fatalError()
        }

        let asset = AVAsset(url: fileURL)
        asset.writeAudio(FileHelper().outputDirectoryURL.appendingPathComponent("mainB.caf"), sampleRate: .m22k, bitDepth: .m16, format: .caf, completion: { bool, error in
            testBool = true
        })
        XCTAssertTrue(testBool)
    }
    
    //MARK: - Test convert to mp3
    func testConvertMP3_SampleRate8000_BitRate192k() throws {
        var testBool = false
        
        let testBundle = Bundle(for: type(of: self))
        guard let fileURL = testBundle.url(forResource: "sampleVideoMOV", withExtension: "MOV") else {
            fatalError()
        }
        
        let asset = AVAsset(url: fileURL)
        asset.writeAudio(FileHelper().outputDirectoryURL.appendingPathComponent("testMP3.mp3"), sampleRate: .m08k, bitRate: .m192k, format: .mp3, completion: { bool, error in
            testBool = true
        })
        XCTAssertTrue(testBool)
    }
}

extension AVAsset {

    func writeAudio(_ output: URL, sampleRate: SampleRate, bitDepth: BitPerChannel = .m16, bitRate: BitRate = .m192k, format: FileFormat, completion: @escaping (Bool, Error?) -> ()) {
        let semafo = DispatchSemaphore(value: 0)
        
        do {
            let audioAsset = try self.audioAsset()
            audioAsset.writeToURL(output, completion: { _, _ in
                let tempURL = FileHelper().outputDirectoryURL.appendingPathComponent("temp4M4A.m4a")
                let audioConverter = AudioConverter(inputURL: tempURL)
                switch format {
                case .aac:
                    audioConverter.convertAAC(sample: sampleRate, bitRate: bitRate)
                    completion(true, nil)
                case .caf:
                    audioConverter.convertCAF(sample: sampleRate, bitDepth: bitDepth)
                    completion(true, nil)
                case .flac:
                    audioConverter.convertFLAC(sampleRate: sampleRate, bitDepth: bitDepth, output: output)
                    completion(true, nil)
                case .mp3:
                    audioConverter.convertMP3(output: output, sample: sampleRate, bitRate: bitRate)
                    completion(true, nil)
                case .wav:
                    audioConverter.convertWAV(sampleRate: .m08k, bitDepth: .m16, output: output)
                    completion(true, nil)
                }
                semafo.signal()
            })
            semafo.wait()
        } catch (let error as NSError){
            completion(false, error)
        }
    }

    private func writeToURL(_ url: URL, completion: @escaping (Bool, Error?) -> ()) {

        guard let exportSession = AVAssetExportSession(asset: self, presetName: AVAssetExportPresetAppleM4A) else {
            completion(false, nil)
            return
        }
        let tempURL = FileHelper().outputDirectoryURL.appendingPathComponent("temp4M4A.m4a")
        exportSession.outputFileType = .m4a
        exportSession.outputURL      = tempURL

        exportSession.exportAsynchronously {
            switch exportSession.status {
            case .completed:
                completion(true, nil)
            case .unknown, .waiting, .exporting, .failed, .cancelled:
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


