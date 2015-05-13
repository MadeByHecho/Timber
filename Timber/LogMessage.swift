//
//  LogMessage.swift
//  Timber
//
//  Created by Scott Petit on 9/7/14.
//  Copyright (c) 2014 Scott Petit. All rights reserved.
//

import Foundation

public struct LogMessage {
    
    public let message: String
    public let logLevel: LogLevel
    public let timestamp: NSDate
    public let file: String
    public let function: String
    public let lineNumber: Int
    
    init(message: String, logLevel: LogLevel, timestamp: NSDate, file: String, function: String, lineNumber: Int) {
        self.message = message
        self.logLevel = logLevel
        self.timestamp = timestamp
        self.file = file.lastPathComponent.stringByDeletingPathExtension
        self.function = function
        self.lineNumber = lineNumber
    }
}