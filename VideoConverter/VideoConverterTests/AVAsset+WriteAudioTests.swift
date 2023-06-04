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
    func testConvertWav_sampleRate22050_bitRate192k_bitDepth16() throws {
        let executeExpectation = XCTestExpectation(description: "in closure")

        let testBundle = Bundle(for: type(of: self))
        guard let inputURL = testBundle.url(forResource: "sampleVideoMOV", withExtension: "MOV") else {
            fatalError()
        }
        let outputURL = FileHelper.shared.outputDirectoryURL.appendingPathComponent("testOutputWAV.wav")

        let asset = AVAsset(url: inputURL)
        
        asset.writeAudio(output: outputURL,
                         format: .wav,
                         sampleRate: .m22k,
                         bitRate: .m192k,
                         bitDepth: .m16,
                         completion: { isComplete in
        
            XCTAssertTrue(isComplete)
            
            executeExpectation.fulfill()
        })
    
        wait(for: [executeExpectation], timeout: 5)
    }
}
