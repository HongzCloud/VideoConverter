//
//  FileHelper.swift
//  VideoConverter
//
//  Created by 오킹 on 2021/10/22.
//

import Foundation

final class FileHelper {
    
    let outputDirectoryURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent("didConverted")
    let inputDirectoryURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent("willConvert")
    
    func createInputOutputDirectory() -> Bool {
       
        do {
            let isInputDir = (try inputDirectoryURL.resourceValues(forKeys: [.isDirectoryKey])).isDirectory ?? false
            let isOutputDir = (try outputDirectoryURL.resourceValues(forKeys: [.isDirectoryKey])).isDirectory ?? false
            
            if !isInputDir {
                try FileManager.default.createDirectory(at: inputDirectoryURL, withIntermediateDirectories: false, attributes: nil)
            }
            
            if !isOutputDir {
                try FileManager.default.createDirectory(at: outputDirectoryURL, withIntermediateDirectories: false, attributes: nil)
            }
            
        } catch {
            return false
        }
        
        return true
    }
    
     func createOutputFileURL(_ name: String) -> URL {
        var fileInfo = name.split(separator: ".")
        var outputFileURL = outputDirectoryURL.appendingPathComponent(fileInfo.joined(separator: "."))
        var num = 0
        
        func isExistFile(atPath: String) -> Bool {

            if FileManager.default.fileExists(atPath: outputFileURL.path) {
                return true
            } else { return false }
        }
        
        while isExistFile(atPath: outputFileURL.path) {
            num += 1
            fileInfo[0] = name.split(separator: ".")[0] + "_\(num)"
            outputFileURL = outputDirectoryURL.appendingPathComponent(fileInfo.joined(separator: "."))

        }
        
        return outputDirectoryURL.appendingPathComponent(fileInfo.joined(separator: "."))
    }
}
