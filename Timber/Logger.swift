//
//  Logger.swift
//  Timber
//
//  Created by Scott Petit on 9/7/14.
//  Copyright (c) 2014 Scott Petit. All rights reserved.
//

import Foundation

public protocol Logger {
    var messageFormatter: MessageFormatterType { get }
    func logMessage(message: LogMessage)
}

public enum LogLevel: Int {
    case None = 0
    case Error
    case Warn
    case Info
    case Debug
    case Verbose
    
    func toString() -> String {
        switch self {
        case .None:
            return "None"
        case .Error:
            return "ERROR"
        case .Warn:
            return "WARNING"
        case .Info:
            return "Info"
        case .Debug:
            return "Debug"
        case .Verbose:
            return "Verbose"
        }
    }
}