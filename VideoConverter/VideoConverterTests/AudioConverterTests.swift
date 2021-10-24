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
    
    func testConvertWav_SampleRate22050_BitDepth16() throws {
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
    
    func testConvertWav_SampleRate22050_BitDepth24() throws {
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
    
    //MARK: - Test convert to aac
    func testConvertAAC_SampleRate8000_BitRate192k() throws {
        let testBundle = Bundle(for: type(of: self))
        guard let fileURL = testBundle.url(forResource: "sampleTest", withExtension: "mp3") else {
            fatalError()
        }

        let audioConverter = AudioConverter.init(inputURL: fileURL)
        XCTAssertTrue(audioConverter.convertAAC(sample: .m08k, bitRate: .m192k))
    }
    
    func testConvertAAC_SampleRate11025_BitRate192k() throws {
        let testBundle = Bundle(for: type(of: self))
        guard let fileURL = testBundle.url(forResource: "sampleTest", withExtension: "mp3") else {
            fatalError()
        }

        let audioConverter = AudioConverter.init(inputURL: fileURL)
        XCTAssertTrue(audioConverter.convertAAC(sample: .m11k, bitRate: .m192k))
    }
    
    func testConvertAAC_SampleRate22050_BitRate192k() throws {
        let testBundle = Bundle(for: type(of: self))
        guard let fileURL = testBundle.url(forResource: "sampleTest", withExtension: "mp3") else {
            fatalError()
        }

        let audioConverter = AudioConverter.init(inputURL: fileURL)
        XCTAssertTrue(audioConverter.convertAAC(sample: .m22k, bitRate: .m192k))
    }
    
    func testConvertAAC_SampleRate44100_BitRate192k() throws {
        let testBundle = Bundle(for: type(of: self))
        guard let fileURL = testBundle.url(forResource: "sampleTest", withExtension: "mp3") else {
            fatalError()
        }

        let audioConverter = AudioConverter.init(inputURL: fileURL)
        XCTAssertTrue(audioConverter.convertAAC(sample: .m44k, bitRate: .m192k))
    }
    
    func testConvertAAC_SampleRate8000_BitRate320k() throws {
        let testBundle = Bundle(for: type(of: self))
        guard let fileURL = testBundle.url(forResource: "sampleTest", withExtension: "mp3") else {
            fatalError()
        }

        let audioConverter = AudioConverter.init(inputURL: fileURL)
        XCTAssertTrue(audioConverter.convertAAC(sample: .m08k, bitRate: .m320k))
    }
    
    func testConvertAAC_SampleRate11025_BitRate320k() throws {
        let testBundle = Bundle(for: type(of: self))
        guard let fileURL = testBundle.url(forResource: "sampleTest", withExtension: "mp3") else {
            fatalError()
        }

        let audioConverter = AudioConverter.init(inputURL: fileURL)
        XCTAssertTrue(audioConverter.convertAAC(sample: .m11k, bitRate: .m320k))
    }
    
    func testConvertAAC_SampleRate22050_BitRate320k() throws {
        let testBundle = Bundle(for: type(of: self))
        guard let fileURL = testBundle.url(forResource: "sampleTest", withExtension: "mp3") else {
            fatalError()
        }

        let audioConverter = AudioConverter.init(inputURL: fileURL)
        XCTAssertTrue(audioConverter.convertAAC(sample: .m22k, bitRate: .m320k))
    }
    
    func testConvertAAC_SampleRate44100_BitRate320k() throws {
        let testBundle = Bundle(for: type(of: self))
        guard let fileURL = testBundle.url(forResource: "sampleTest", withExtension: "mp3") else {
            fatalError()
        }

        let audioConverter = AudioConverter.init(inputURL: fileURL)
        XCTAssertTrue(audioConverter.convertAAC(sample: .m44k, bitRate: .m320k))
    }
    
}
