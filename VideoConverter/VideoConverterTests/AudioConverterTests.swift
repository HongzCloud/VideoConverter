//
//  AudioConverterTests.swift
//  VideoConverterTests
//
//  Created by 오킹 on 2021/10/23.
//

import XCTest

class AudioConverterTests: XCTestCase {
    //MARK: - Test convert to wav
    func testConvertWav_SampleRate8000_BitDepth16() throws {
        let testBundle = Bundle(for: type(of: self))
        guard let fileURL = testBundle.url(forResource: "sampleTest", withExtension: "mp3") else {
            fatalError()
        }

        let audioConverter = AudioConverter.init(inputURL: fileURL)
        XCTAssertTrue(audioConverter.convertWAV(sampleRate: .m08k, bitDepth: .m16))
    }
    
    func testConvertWav_SampleRate11025_BitDepth16() throws {
        let testBundle = Bundle(for: type(of: self))
        guard let fileURL = testBundle.url(forResource: "sampleTest", withExtension: "mp3") else {
            fatalError()
        }

        let audioConverter = AudioConverter.init(inputURL: fileURL)
        XCTAssertTrue(audioConverter.convertWAV(sampleRate: .m11k, bitDepth: .m16))
    }
    
    func testConvertWav_SampleRate22000_BitDepth16() throws {
        let testBundle = Bundle(for: type(of: self))
        guard let fileURL = testBundle.url(forResource: "sampleTest", withExtension: "mp3") else {
            fatalError()
        }

        let audioConverter = AudioConverter.init(inputURL: fileURL)
        XCTAssertTrue(audioConverter.convertWAV(sampleRate: .m22k, bitDepth: .m16))
    }
    
    func testConvertWav_SampleRate44100_BitDepth16() throws {
        let testBundle = Bundle(for: type(of: self))
        guard let fileURL = testBundle.url(forResource: "sampleTest", withExtension: "mp3") else {
            fatalError()
        }

        let audioConverter = AudioConverter.init(inputURL: fileURL)
        XCTAssertTrue(audioConverter.convertWAV(sampleRate: .m44k, bitDepth: .m16))
    }
    
    func testConvertWav_SampleRate8000_BitDepth24() throws {
        let testBundle = Bundle(for: type(of: self))
        guard let fileURL = testBundle.url(forResource: "sampleTest", withExtension: "mp3") else {
            fatalError()
        }

        let audioConverter = AudioConverter.init(inputURL: fileURL)
        XCTAssertTrue(audioConverter.convertWAV(sampleRate: .m08k, bitDepth: .m24))
    }
    
    func testConvertWav_SampleRate11025_BitDepth24() throws {
        let testBundle = Bundle(for: type(of: self))
        guard let fileURL = testBundle.url(forResource: "sampleTest", withExtension: "mp3") else {
            fatalError()
        }

        let audioConverter = AudioConverter.init(inputURL: fileURL)
        XCTAssertTrue(audioConverter.convertWAV(sampleRate: .m11k, bitDepth: .m24))
    }
    
    func testConvertWav_SampleRate22000_BitDepth24() throws {
        let testBundle = Bundle(for: type(of: self))
        guard let fileURL = testBundle.url(forResource: "sampleTest", withExtension: "mp3") else {
            fatalError()
        }

        let audioConverter = AudioConverter.init(inputURL: fileURL)
        XCTAssertTrue(audioConverter.convertWAV(sampleRate: .m22k, bitDepth: .m24))
    }
    
    func testConvertWav_SampleRate44100_BitDepth24() throws {
        let testBundle = Bundle(for: type(of: self))
        guard let fileURL = testBundle.url(forResource: "sampleTest", withExtension: "mp3") else {
            fatalError()
        }

        let audioConverter = AudioConverter.init(inputURL: fileURL)
        XCTAssertTrue(audioConverter.convertWAV(sampleRate: .m44k, bitDepth: .m24))
    }
    
}
