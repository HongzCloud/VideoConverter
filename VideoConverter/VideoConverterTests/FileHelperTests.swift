//
//  FileHelperTests.swift
//  VideoConverterTests
//
//  Created by 오킹 on 2021/10/23.
//

import XCTest

class FileHelperTests: XCTestCase {
    
    func testCreateInputOutputDirectory() throws {
        let fileHelper = FileHelper()
        XCTAssertTrue(fileHelper.createInputOutputDirectory())
    }
    
    func testCreateOutputFileURL() throws {
        let fileHelper = FileHelper()
        let url = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        XCTAssertEqual(fileHelper.createOutputFileURL("testCreateOutputFileURL.wav"), URL(fileURLWithPath: fileHelper.outputDirectoryURL.path + "/testCreateOutputFileURL.wav"))
    }

}
