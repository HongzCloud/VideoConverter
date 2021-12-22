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
    
    func testCcreateFileURL() throws {
        let fileHelper = FileHelper()

        XCTAssertEqual(fileHelper.createFileURL("testCreateOutputFileURL.wav", in: .didConverted), URL(fileURLWithPath: Directory.didConverted.rawValue.path + "/testCreateOutputFileURL.wav"))
    }

}
