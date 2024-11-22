//
//  Log.swift
//  Storit
//
//  Created by iOS Nasmedia on 11/6/24.
//

import Foundation
import os.log

extension OSLog {
    static let subsystem = Bundle.main.bundleIdentifier ?? ""
    static let network = OSLog(subsystem: subsystem, category: "Network")
    static let debug = OSLog(subsystem: subsystem, category: "Debug")
    static let info = OSLog(subsystem: subsystem, category: "Info")
    static let error = OSLog(subsystem: subsystem, category: "Error")
}

struct Log {

    static var displayLog = true
    
    enum Level {
        /// 디버깅 로그
        case debug
        /// 문제 해결 정보
        case info
        /// 네트워크 로그
        case network
        /// 오류 로그
        case error
        case custom(category: String)
        
        fileprivate var category: String {
            switch self {
            case .debug:
                return "🐛 Debug"
            case .info:
                return "📍 Info"
            case .network:
                return "☁️ Network"
            case .error:
                return "⚠️ ERROR"
            case .custom(let category):
                return "🟢 \(category)"
            }
        }
        
        fileprivate var osLog: OSLog {
            switch self {
            case .debug:
                return OSLog.debug
            case .info:
                return OSLog.info
            case .network:
                return OSLog.network
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
            case .network:
                return .default
            case .error:
                return .error
            case .custom:
                return .debug
            }
        }
    }
    
    static func log(_ message: Any, _ arguments: [Any], level: Level) {
        
        let extraMessage: String = arguments.map({ String(describing: $0) }).joined(separator: " \n")
        
        let logMessage = "\(message) \n \(extraMessage) \t\t"
        
        if displayLog {
            if #available(iOS 14.0, *) {
                let logger = Logger(subsystem: OSLog.subsystem, category: level.category)
                
                switch level {
                    case .debug, .custom:
                        logger.debug("\(level.category)\n \(logMessage)")
                    case .info:
                        logger.info("\(level.category)\n \(logMessage)")
                    case .network:
                        logger.log("\(level.category) \(logMessage)")
                    case .error:
                        logger.error("\(level.category)\n \(logMessage)")
                }
            } else {
                os_log("%{public}@", log: level.osLog, type: level.osLogType, "\(message) \(extraMessage)")
            }
        }
    }
}

extension Log {

    static func debug(_ message: Any, _ arguments: Any...) {
        log(message, arguments, level: .debug)
    }

    static func info(_ message: Any, _ arguments: Any...) {
        log(message, arguments, level: .info)
    }

    static func network(_ message: Any, _ arguments: Any...) {
        log(message, arguments, level: .network)
    }

    static func error(_ message: Any, _ arguments: Any...) {
        log(message, arguments, level: .error)
    }

    static func custom(category: String, _ message: Any, _ arguments: Any...) {
        log(message, arguments, level: .custom(category: category))
    }
}
