//
//  Logger.swift
//  BootstrapShared
//
//  Created by Klaus Lanzarini on 22/07/2019.
//  Copyright © 2019 Klaus Lanzarini. All rights reserved.
//

import Foundation
import os.log

public enum LogLevel: UInt8 {
    case error = 1
    case warning = 2
    case severe = 3
    case debug = 4
    case info = 5
    case verbose = 6
    
    var tag: String {
        switch self {
        case .error:
            return "‼️"
        case .warning:
            return "⚠️"
        case .severe:
            return "🔥"
        case .debug:
            return "💬"
        case .info:
            return "ℹ️"
        case .verbose:
            return "🔬"
        }
    }
}

public enum LogMode {
    case full
    case long
    case short
    case custom(String)
}

public struct Logger {
    public static var level: LogLevel = .verbose
    public static var categories: [String] = []
    public static var defaultMode: LogMode = .long
    public static var defaultCategory = "Log"
    public static var excludedCategories: [String] = []
    
    public static func log(level: LogLevel,
                           mode: LogMode = defaultMode,
                           category: String = defaultCategory,
                           text: String = String.empty,
                           params: [String: CustomDebugStringConvertible] = [:],
                           filename: String = #file,
                           function: String = #function,
                           line: Int = #line) {
        guard level.rawValue <= Logger.level.rawValue else { return }
        
        if !categories.isEmpty {
            if (categories.contains { $0 == category }) == false {
                return
            }
        }
        
        if !excludedCategories.isEmpty {
            if (excludedCategories.contains { $0.uppercased() == category.uppercased() }) {
                return
            }
        }
        
        let url = URL(fileURLWithPath: filename)
        
        var parameters = String.empty
        params.forEach { tupla in
            parameters += "\n\t |--> \(tupla.key) = \(tupla.value.debugDescription)"
        }
        
        if !parameters.isEmpty {
            parameters += "\n"
        }
        
        let pattern: String
        
        switch mode {
        case .full:
            pattern = "[%datetime] [%level] [%category] (%file.%function:%line) %text %params"
        case .long:
            pattern = "[%level] [%category] (%file.%function:%line) %text %params"
        case .short:
            pattern = "[%level] [%category] %text %params"
        case .custom(let customPattern):
            pattern = customPattern
        }
        
        var message = pattern.replacingOccurrences(of: "%datetime", with: Date().description, options: .literal, range: nil)
        message = message.replacingOccurrences(of: "%level", with: level.tag, options: .literal, range: nil)
        message = message.replacingOccurrences(of: "%category", with: category.uppercased(), options: .literal, range: nil)
        message = message.replacingOccurrences(of: "%file", with: url.lastPathComponent, options: .literal, range: nil)
        message = message.replacingOccurrences(of: "%function", with: function, options: .literal, range: nil)
        message = message.replacingOccurrences(of: "%line", with: "\(line)", options: .literal, range: nil)
        message = message.replacingOccurrences(of: "%text", with: text, options: .literal, range: nil)
        message = message.replacingOccurrences(of: "%params", with: parameters, options: .literal, range: nil)
        
        if #available(iOS 10.0, *) {
            // To do: use categories and identify calling framework
            os_log("%@", message)
        } else {
            print(message)
        }
    }
    
    public func debug(mode: LogMode = defaultMode,
                      category: String = defaultCategory,
                      text: String = String.empty,
                      params: [String: CustomDebugStringConvertible] = [:],
                      filename: String = #file,
                      function: String = #function,
                      line: Int = #line) {
        Logger.log(level: .debug, mode: mode, category: category, text: text, params: params)
    }
}
