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
        guard let fileURL = testBundle.url(forResource: "sampleTestMP3", withExtension: "mp3") else {
            fatalError()
        }
        let output = FileHelper().outputDirectoryURL.appendingPathComponent("testWAV.wav")
        let audioConverter = AudioConverter.init(inputURL: fileURL)
        XCTAssertTrue(audioConverter.convertWAV(sampleRate: .m08k, bitDepth: .m16, output: output))
    }
    
    func testConvertWav_SampleRate11025_BitDepth16() throws {
        let testBundle = Bundle(for: type(of: self))
        guard let fileURL = testBundle.url(forResource: "sampleTestMP3", withExtension: "mp3") else {
            fatalError()
        }
        let output = FileHelper().outputDirectoryURL.appendingPathComponent("testWAV.wav")
        let audioConverter = AudioConverter.init(inputURL: fileURL)
        XCTAssertTrue(audioConverter.convertWAV(sampleRate: .m11k, bitDepth: .m16, output: output))
    }
    
    func testConvertWav_SampleRate22050_BitDepth16() throws {
        let testBundle = Bundle(for: type(of: self))
        guard let fileURL = testBundle.url(forResource: "sampleTestMP3", withExtension: "mp3") else {
            fatalError()
        }
        let output = FileHelper().outputDirectoryURL.appendingPathComponent("testWAV.wav")
        let audioConverter = AudioConverter.init(inputURL: fileURL)
        XCTAssertTrue(audioConverter.convertWAV(sampleRate: .m22k, bitDepth: .m16, output: output))
    }
    
    func testConvertWav_SampleRate44100_BitDepth16() throws {
        let testBundle = Bundle(for: type(of: self))
        guard let fileURL = testBundle.url(forResource: "sampleTestMP3", withExtension: "mp3") else {
            fatalError()
        }
        let output = FileHelper().outputDirectoryURL.appendingPathComponent("testWAV.wav")
        let audioConverter = AudioConverter.init(inputURL: fileURL)
        XCTAssertTrue(audioConverter.convertWAV(sampleRate: .m44k, bitDepth: .m16, output: output))
    }
    
    func testConvertWav_SampleRate8000_BitDepth32() throws {
        let testBundle = Bundle(for: type(of: self))
        guard let fileURL = testBundle.url(forResource: "sampleTestMP3", withExtension: "mp3") else {
            fatalError()
        }
        let output = FileHelper().outputDirectoryURL.appendingPathComponent("testWAV.wav")
        let audioConverter = AudioConverter.init(inputURL: fileURL)
        XCTAssertTrue(audioConverter.convertWAV(sampleRate: .m08k, bitDepth: .m32, output: output))
    }
    
    func testConvertWav_SampleRate11025_BitDepth32() throws {
        let testBundle = Bundle(for: type(of: self))
        guard let fileURL = testBundle.url(forResource: "sampleTestMP3", withExtension: "mp3") else {
            fatalError()
        }
        let output = FileHelper().outputDirectoryURL.appendingPathComponent("testWAV.wav")
        let audioConverter = AudioConverter.init(inputURL: fileURL)
        XCTAssertTrue(audioConverter.convertWAV(sampleRate: .m11k, bitDepth: .m32, output: output))
    }
    
    func testConvertWav_SampleRate22050_BitDepth32() throws {
        let testBundle = Bundle(for: type(of: self))
        guard let fileURL = testBundle.url(forResource: "sampleTestMP3", withExtension: "mp3") else {
            fatalError()
        }
        let output = FileHelper().outputDirectoryURL.appendingPathComponent("testWAV.wav")
        let audioConverter = AudioConverter.init(inputURL: fileURL)
        XCTAssertTrue(audioConverter.convertWAV(sampleRate: .m22k, bitDepth: .m32, output: output))
    }
    
    func testConvertWav_SampleRate44100_BitDepth32() throws {
        let testBundle = Bundle(for: type(of: self))
        guard let fileURL = testBundle.url(forResource: "sampleTestMP3", withExtension: "mp3") else {
            fatalError()
        }
        let output = FileHelper().outputDirectoryURL.appendingPathComponent("testWAV.wav")
        let audioConverter = AudioConverter.init(inputURL: fileURL)
        XCTAssertTrue(audioConverter.convertWAV(sampleRate: .m44k, bitDepth: .m32, output: output))
    }
    
    //MARK: - Test convert to aac
    func testConvertAAC_SampleRate8000_BitRate192k() throws {
        let testBundle = Bundle(for: type(of: self))
        guard let fileURL = testBundle.url(forResource: "sampleTestMP3", withExtension: "mp3") else {
            fatalError()
        }

        let audioConverter = AudioConverter.init(inputURL: fileURL)
        XCTAssertTrue(audioConverter.convertAAC(sample: .m08k, bitRate: .m192k))
    }
    
    func testConvertAAC_SampleRate11025_BitRate192k() throws {
        let testBundle = Bundle(for: type(of: self))
        guard let fileURL = testBundle.url(forResource: "sampleTestMP3", withExtension: "mp3") else {
            fatalError()
        }

        let audioConverter = AudioConverter.init(inputURL: fileURL)
        XCTAssertTrue(audioConverter.convertAAC(sample: .m11k, bitRate: .m192k))
    }
    
    func testConvertAAC_SampleRate22050_BitRate192k() throws {
        let testBundle = Bundle(for: type(of: self))
        guard let fileURL = testBundle.url(forResource: "sampleTestMP3", withExtension: "mp3") else {
            fatalError()
        }

        let audioConverter = AudioConverter.init(inputURL: fileURL)
        XCTAssertTrue(audioConverter.convertAAC(sample: .m22k, bitRate: .m192k))
    }
    
    func testConvertAAC_SampleRate44100_BitRate192k() throws {
        let testBundle = Bundle(for: type(of: self))
        guard let fileURL = testBundle.url(forResource: "sampleTestMP3", withExtension: "mp3") else {
            fatalError()
        }

        let audioConverter = AudioConverter.init(inputURL: fileURL)
        XCTAssertTrue(audioConverter.convertAAC(sample: .m44k, bitRate: .m192k))
    }
    
    func testConvertAAC_SampleRate8000_BitRate320k() throws {
        let testBundle = Bundle(for: type(of: self))
        guard let fileURL = testBundle.url(forResource: "sampleTestMP3", withExtension: "mp3") else {
            fatalError()
        }

        let audioConverter = AudioConverter.init(inputURL: fileURL)
        XCTAssertTrue(audioConverter.convertAAC(sample: .m08k, bitRate: .m320k))
    }
    
    func testConvertAAC_SampleRate11025_BitRate320k() throws {
        let testBundle = Bundle(for: type(of: self))
        guard let fileURL = testBundle.url(forResource: "sampleTestMP3", withExtension: "mp3") else {
            fatalError()
        }

        let audioConverter = AudioConverter.init(inputURL: fileURL)
        XCTAssertTrue(audioConverter.convertAAC(sample: .m11k, bitRate: .m320k))
    }
    
    func testConvertAAC_SampleRate22050_BitRate320k() throws {
        let testBundle = Bundle(for: type(of: self))
        guard let fileURL = testBundle.url(forResource: "sampleTestMP3", withExtension: "mp3") else {
            fatalError()
        }

        let audioConverter = AudioConverter.init(inputURL: fileURL)
        XCTAssertTrue(audioConverter.convertAAC(sample: .m22k, bitRate: .m320k))
    }
    
    func testConvertAAC_SampleRate44100_BitRate320k() throws {
        let testBundle = Bundle(for: type(of: self))
        guard let fileURL = testBundle.url(forResource: "sampleTestMP3", withExtension: "mp3") else {
            fatalError()
        }

        let audioConverter = AudioConverter.init(inputURL: fileURL)
        XCTAssertTrue(audioConverter.convertAAC(sample: .m44k, bitRate: .m320k))
    }
    
    //MARK: - Test convert to flac
    func testConvertFLAC_SampleRate8000_BitDepth16() throws {
        let testBundle = Bundle(for: type(of: self))
        guard let fileURL = testBundle.url(forResource: "sampleTestMP3", withExtension: "mp3") else {
            fatalError()
        }
        let output = FileHelper().outputDirectoryURL.appendingPathComponent("testFlac.flac")
        let audioConverter = AudioConverter.init(inputURL: fileURL)
        XCTAssertTrue(audioConverter.convertFLAC(sampleRate: .m08k, bitDepth: .m16, output: output))
    }
    
    func testConvertFLAC_SampleRate11025_BitDepth16() throws {
        let testBundle = Bundle(for: type(of: self))
        guard let fileURL = testBundle.url(forResource: "sampleTestMP3", withExtension: "mp3") else {
            fatalError()
        }
        let output = FileHelper().outputDirectoryURL.appendingPathComponent("testFlac.flac")
        let audioConverter = AudioConverter.init(inputURL: fileURL)
        XCTAssertTrue(audioConverter.convertFLAC(sampleRate: .m11k, bitDepth: .m16, output: output))
    }
    
    func testConvertFLAC_SampleRate22050_BitDepth16() throws {
        let testBundle = Bundle(for: type(of: self))
        guard let fileURL = testBundle.url(forResource: "sampleTestMP3", withExtension: "mp3") else {
            fatalError()
        }
        let output = FileHelper().outputDirectoryURL.appendingPathComponent("testFlac.flac")
        let audioConverter = AudioConverter.init(inputURL: fileURL)
        XCTAssertTrue(audioConverter.convertFLAC(sampleRate: .m22k, bitDepth: .m16, output: output))
    }
    
    func testConvertFLAC_SampleRate44100_BitDepth16() throws {
        let testBundle = Bundle(for: type(of: self))
        guard let fileURL = testBundle.url(forResource: "sampleTestMP3", withExtension: "mp3") else {
            fatalError()
        }
        let output = FileHelper().outputDirectoryURL.appendingPathComponent("testFlac.flac")
        let audioConverter = AudioConverter.init(inputURL: fileURL)
        XCTAssertTrue(audioConverter.convertFLAC(sampleRate: .m44k, bitDepth: .m16, output: output))
    }
    
    func testConvertFLAC_SampleRate8000_BitDepth32() throws {
        let testBundle = Bundle(for: type(of: self))
        guard let fileURL = testBundle.url(forResource: "sampleTestMP3", withExtension: "mp3") else {
            fatalError()
        }
        
        let output = FileHelper().outputDirectoryURL.appendingPathComponent("testFlac.flac")
        let audioConverter = AudioConverter.init(inputURL: fileURL)
        XCTAssertTrue(audioConverter.convertFLAC(sampleRate: .m08k, bitDepth: .m32, output: output))
    }
    
    func testConvertFLAC_SampleRate11025_BitDepth32() throws {
        let testBundle = Bundle(for: type(of: self))
        guard let fileURL = testBundle.url(forResource: "sampleTestMP3", withExtension: "mp3") else {
            fatalError()
        }
        let output = FileHelper().outputDirectoryURL.appendingPathComponent("testFlac.flac")
        let audioConverter = AudioConverter.init(inputURL: fileURL)
        XCTAssertTrue(audioConverter.convertFLAC(sampleRate: .m11k, bitDepth: .m32, output: output))    }
    
    func testConvertFLAC_SampleRate22050_BitDepth32() throws {
        let testBundle = Bundle(for: type(of: self))
        guard let fileURL = testBundle.url(forResource: "sampleTestMP3", withExtension: "mp3") else {
            fatalError()
        }
        let output = FileHelper().outputDirectoryURL.appendingPathComponent("testFlac.flac")
        let audioConverter = AudioConverter.init(inputURL: fileURL)
        XCTAssertTrue(audioConverter.convertFLAC(sampleRate: .m22k, bitDepth: .m32, output: output))
    }
    
    func testConvertFLAC_SampleRate44100_BitDepth32() throws {
        let testBundle = Bundle(for: type(of: self))
        guard let fileURL = testBundle.url(forResource: "sampleTestMP3", withExtension: "mp3") else {
            fatalError()
        }
        let output = FileHelper().outputDirectoryURL.appendingPathComponent("testFlac.flac")
        let audioConverter = AudioConverter.init(inputURL: fileURL)
        XCTAssertTrue(audioConverter.convertFLAC(sampleRate: .m44k, bitDepth: .m32, output: output))
    }
    
    //MARK: - Test convert to caf
    func testConvertCAF_SampleRate8000_BitDepth16() throws {
        let testBundle = Bundle(for: type(of: self))
        guard let fileURL = testBundle.url(forResource: "sampleTestMP3", withExtension: "mp3") else {
            fatalError()
        }
        let output = FileHelper().outputDirectoryURL.appendingPathComponent("testCaf.caf")
        let audioConverter = AudioConverter.init(inputURL: fileURL)
        XCTAssertTrue(audioConverter.convertCAF(sampleRate: .m08k, bitDepth: .m16, output: output))
    }
    
    func testConvertCAF_SampleRate11025_BitDepth16() throws {
        let testBundle = Bundle(for: type(of: self))
        guard let fileURL = testBundle.url(forResource: "sampleTestMP3", withExtension: "mp3") else {
            fatalError()
        }
        let output = FileHelper().outputDirectoryURL.appendingPathComponent("testCaf.caf")
        let audioConverter = AudioConverter.init(inputURL: fileURL)
        XCTAssertTrue(audioConverter.convertCAF(sampleRate: .m11k, bitDepth: .m16, output: output))
    }
    
    func testConvertCAF_SampleRate22050_BitDepth16() throws {
        let testBundle = Bundle(for: type(of: self))
        guard let fileURL = testBundle.url(forResource: "sampleTestMP3", withExtension: "mp3") else {
            fatalError()
        }
        let output = FileHelper().outputDirectoryURL.appendingPathComponent("testCaf.caf")
        let audioConverter = AudioConverter.init(inputURL: fileURL)
        XCTAssertTrue(audioConverter.convertCAF(sampleRate: .m22k, bitDepth: .m16, output: output))
    }
    
    func testConvertCAF_SampleRate44100_BitDepth16() throws {
        let testBundle = Bundle(for: type(of: self))
        guard let fileURL = testBundle.url(forResource: "sampleTestMP3", withExtension: "mp3") else {
            fatalError()
        }
        let output = FileHelper().outputDirectoryURL.appendingPathComponent("testCaf.caf")
        let audioConverter = AudioConverter.init(inputURL: fileURL)
        XCTAssertTrue(audioConverter.convertCAF(sampleRate: .m44k, bitDepth: .m16, output: output))
    }
    
    func testConvertCAF_SampleRate8000_BitDepth32() throws {
        let testBundle = Bundle(for: type(of: self))
        guard let fileURL = testBundle.url(forResource: "sampleTestMP3", withExtension: "mp3") else {
            fatalError()
        }
        let output = FileHelper().outputDirectoryURL.appendingPathComponent("testCaf.caf")
        let audioConverter = AudioConverter.init(inputURL: fileURL)
        XCTAssertTrue(audioConverter.convertCAF(sampleRate: .m08k, bitDepth: .m32, output: output))
    }
    
    func testConvertCAF_SampleRate11025_BitDepth32() throws {
        let testBundle = Bundle(for: type(of: self))
        guard let fileURL = testBundle.url(forResource: "sampleTestMP3", withExtension: "mp3") else {
            fatalError()
        }
        let output = FileHelper().outputDirectoryURL.appendingPathComponent("testCaf.caf")
        let audioConverter = AudioConverter.init(inputURL: fileURL)
        XCTAssertTrue(audioConverter.convertCAF(sampleRate: .m11k, bitDepth: .m32, output: output))
    }
    
    func testConvertCAF_SampleRate22050_BitDepth32() throws {
        let testBundle = Bundle(for: type(of: self))
        guard let fileURL = testBundle.url(forResource: "sampleTestMP3", withExtension: "mp3") else {
            fatalError()
        }
        let output = FileHelper().outputDirectoryURL.appendingPathComponent("testCaf.caf")
        let audioConverter = AudioConverter.init(inputURL: fileURL)
        XCTAssertTrue(audioConverter.convertCAF(sampleRate: .m22k, bitDepth: .m32, output: output))
    }
    
    func testConvertCAF_SampleRate44100_BitDepth32() throws {
        let testBundle = Bundle(for: type(of: self))
        guard let fileURL = testBundle.url(forResource: "sampleTestMP3", withExtension: "mp3") else {
            fatalError()
        }
        let output = FileHelper().outputDirectoryURL.appendingPathComponent("testCaf.caf")
        let audioConverter = AudioConverter.init(inputURL: fileURL)
        XCTAssertTrue(audioConverter.convertCAF(sampleRate: .m44k, bitDepth: .m32, output: output))
    }
    
    //MARK: - Test convert to mp3
    func testConvertMP3_SampleRate8000_BitRate192k() throws {
        let testBundle = Bundle(for: type(of: self))
        guard let fileURL = testBundle.url(forResource: "sampleTestMP3", withExtension: "mp3") else {
            fatalError()
        }
        let output = FileHelper().outputDirectoryURL.appendingPathComponent("testMP3.mp3")
        let audioConverter = AudioConverter.init(inputURL: fileURL)
        XCTAssertTrue(audioConverter.convertMP3(output: output, sample: .m08k, bitRate: .m192k))
    }
    
    func testConverttMP3_SampleRate11025_BitRate192k() throws {
        let testBundle = Bundle(for: type(of: self))
        guard let fileURL = testBundle.url(forResource: "sampleTestMP3", withExtension: "mp3") else {
            fatalError()
        }
        let output = FileHelper().outputDirectoryURL.appendingPathComponent("testMP3.mp3")
        let audioConverter = AudioConverter.init(inputURL: fileURL)
        XCTAssertTrue(audioConverter.convertMP3(output: output, sample: .m11k, bitRate: .m192k))
    }
    
    func testConverttMP3_SampleRate22050_BitRate192k() throws {
        let testBundle = Bundle(for: type(of: self))
        guard let fileURL = testBundle.url(forResource: "sampleTestMP3", withExtension: "mp3") else {
            fatalError()
        }
        let output = FileHelper().outputDirectoryURL.appendingPathComponent("testMP3.mp3")
        let audioConverter = AudioConverter.init(inputURL: fileURL)
        XCTAssertTrue(audioConverter.convertMP3(output: output, sample: .m22k, bitRate: .m192k))
    }
    
    func testConverttMP3_SampleRate44100_BitRate192k() throws {
        let testBundle = Bundle(for: type(of: self))
        guard let fileURL = testBundle.url(forResource: "sampleTestMP3", withExtension: "mp3") else {
            fatalError()
        }
        let output = FileHelper().outputDirectoryURL.appendingPathComponent("testMP3.mp3")
        let audioConverter = AudioConverter.init(inputURL: fileURL)
        XCTAssertTrue(audioConverter.convertMP3(output: output, sample: .m44k, bitRate: .m192k))
    }
    
    func testConverttMP3_SampleRate8000_BitRate320k() throws {
        let testBundle = Bundle(for: type(of: self))
        guard let fileURL = testBundle.url(forResource: "sampleTestMP3", withExtension: "mp3") else {
            fatalError()
        }
        let output = FileHelper().outputDirectoryURL.appendingPathComponent("testMP3.mp3")
        let audioConverter = AudioConverter.init(inputURL: fileURL)
        XCTAssertTrue(audioConverter.convertMP3(output: output, sample: .m08k, bitRate: .m320k))
    }
    
    func testConverttMP3_SampleRate11025_BitRate320k() throws {
        let testBundle = Bundle(for: type(of: self))
        guard let fileURL = testBundle.url(forResource: "sampleTestMP3", withExtension: "mp3") else {
            fatalError()
        }
        let output = FileHelper().outputDirectoryURL.appendingPathComponent("testMP3.mp3")
        let audioConverter = AudioConverter.init(inputURL: fileURL)
        XCTAssertTrue(audioConverter.convertMP3(output: output, sample: .m11k, bitRate: .m320k))
    }
    
    func testConverttMP3_SampleRate22050_BitRate320k() throws {
        let testBundle = Bundle(for: type(of: self))
        guard let fileURL = testBundle.url(forResource: "sampleTestMP3", withExtension: "mp3") else {
            fatalError()
        }
        let output = FileHelper().outputDirectoryURL.appendingPathComponent("testMP3.mp3")
        let audioConverter = AudioConverter.init(inputURL: fileURL)
        XCTAssertTrue(audioConverter.convertMP3(output: output, sample: .m22k, bitRate: .m320k))
    }
    
    func testConverttMP3_SampleRate44100_BitRate320k() throws {
        let testBundle = Bundle(for: type(of: self))
        guard let fileURL = testBundle.url(forResource: "sampleTestMP3", withExtension: "mp3") else {
            fatalError()
        }
        let output = FileHelper().outputDirectoryURL.appendingPathComponent("testMP3.mp3")
        let audioConverter = AudioConverter.init(inputURL: fileURL)
        XCTAssertTrue(audioConverter.convertMP3(output: output, sample: .m44k, bitRate: .m320k))
    }
}
