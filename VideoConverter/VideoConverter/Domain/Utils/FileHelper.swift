//
//  FileHelper.swift
//  VideoConverter
//
//  Created by 오킹 on 2021/10/22.
//

import Foundation

final class FileHelper {
    
    private let outputDirectoryURL = Directory.didConverted.rawValue
    private let inputDirectoryURL = Directory.willConvert.rawValue
    private var tempURL = Directory.temporary.rawValue
    
    static let shared: FileHelper = FileHelper()
    
    func createInputOutputDirectory() -> Bool {
       
        do {
            let isInputDir = try? inputDirectoryURL.resourceValues(forKeys: [.isDirectoryKey]).isDirectory ?? false
            let isOutputDir = try? outputDirectoryURL.resourceValues(forKeys: [.isDirectoryKey]).isDirectory ?? false
            
            if isInputDir == nil || !isInputDir! {
                try FileManager.default.createDirectory(at: inputDirectoryURL, withIntermediateDirectories: false, attributes: nil)
            }
            
            if isOutputDir == nil || !isOutputDir! {
                try FileManager.default.createDirectory(at: outputDirectoryURL, withIntermediateDirectories: false, attributes: nil)
            }
            
        } catch {
            return false
        }
        
        return true
    }
    
    func createFileURL(_ name: String, in directoryType: Directory) -> URL {
        if directoryType == .temporary {
            self.tempURL.removeAllCachedResourceValues()
        }
        
        var fileInfo = name.split(separator: ".")
        let directoryURL = directoryType.rawValue
        var num = 0
        
        func isExistFile(atPath: String) -> Bool {

            if FileManager.default.fileExists(atPath: atPath) {
                return true
            } else { return false }
        }

        while isExistFile(atPath: directoryURL.appendingPathComponent(fileInfo[0] + "." + fileInfo.last!).path) {
            num += 1
            fileInfo[0] = name.split(separator: ".")[0] + "_\(num)"
        }
        
        return directoryURL.appendingPathComponent(fileInfo[0] + "." + fileInfo.last!)
    }
    
   
    func urls(for directory: Directory, skipsHiddenFiles: Bool = true ) -> [URL]? {
        let documentsURL = directory == .willConvert ? self.inputDirectoryURL : self.outputDirectoryURL
        let fileURLs = try? FileManager.default.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil, options: skipsHiddenFiles ? .skipsHiddenFiles : [] )
        return fileURLs
    }
}

enum Directory {
    case willConvert
    case didConverted
    case temporary
    
    var rawValue: URL {
    switch self {
    case .willConvert:
        return try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent("willConvert")
    case .didConverted:
        return try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent("didConverted")
    case .temporary:
        return FileManager.default.temporaryDirectory
    }
    }
}
