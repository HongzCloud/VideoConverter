//
//  Log.swift
//  VideoConverter
//
//  Created by 오킹 on 2021/12/15.
//

import Foundation
import os.log

extension OSLog {
    static let subsystem = Bundle.main.bundleIdentifier!
    static let debug = OSLog(subsystem: subsystem, category: "Debug")
    static let info = OSLog(subsystem: subsystem, category: "Info")
    static let error = OSLog(subsystem: subsystem, category: "Error")
}

struct Log {
    // TODO
    enum Level {
        case debug
        case info
        case error
        case custom(categoryName: String)
        
        fileprivate var categoryName: String {
            switch self {
            case .debug:
                return "Debug"
            case .info:
                return "Info"
            case .error:
                return "Error"
            case .custom(let categoryName):
                return categoryName
            }
        }
        
        fileprivate var osLog: OSLog {
            switch self {
            case .debug:
                return OSLog.debug
            case .info:
                return OSLog.info
            case .error:
                return OSLog.error
            case .custom:
                return OSLog.debug
            }
        }
        
        fileprivate var osLogType: OSLogType {
            switch self {
            case .debug:
                return .debug
            case .info:
                return .info
            case .error:
                return .error
            case .custom:
                return .debug
            }
        }
    }
    
    static private func log(_ message: Any, _ arguments: [Any], level: Level) {
            #if LOG
            if #available(iOS 14.0, *) {
                let extraMessage: String = arguments.map({ String(describing: $0) }).joined(separator: " ")
                let logger = Logger(subsystem: OSLog.subsystem, category: level.categoryName)
                let logMessage = "\(message) \(extraMessage)"
                switch level {
                case .debug,
                     .custom:
                    logger.debug("\(logMessage, privacy: .public)")
                case .info:
                    logger.info("\(logMessage, privacy: .public)")
                case .error:
                    logger.error("\(logMessage, privacy: .public)")
                }
            } else {
                let extraMessage: String = arguments.map({ String(describing: $0) }).joined(separator: " ")
                os_log("%{public}@", log: level.osLog, type: level.osLogType, "\(message) \(extraMessage)")
            }
            #endif
        }
}

// MARK: - utils

extension Log {
    static func debug(_ message: Any, _ arguments: Any...) {
        log(message, arguments, level: .debug)
    }

    static func info(_ message: Any, _ arguments: Any...) {
        log(message, arguments, level: .info)
    }

    static func error(_ message: Any, _ arguments: Any...) {
        log(message, arguments, level: .error)
    }

    static func custom(category: String, _ message: Any, _ arguments: Any...) {
        log(message, arguments, level: .custom(categoryName: category))
    }
}
