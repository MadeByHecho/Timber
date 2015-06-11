//
//  XcodeLogger.swift
//  Timber
//
//  Created by Scott Petit on 9/7/14.
//  Copyright (c) 2014 Scott Petit. All rights reserved.
//

import Foundation

public struct XcodeLogger: Logger {
    
    public init() {
        
    }
    
    //MARK: Logger
    
    public var messageFormatter: MessageFormatterType = MessageFormatter()
    
    public func logMessage(message: LogMessage) {
        let messageToLog = messageFormatter.formatLogMessage(message)
        
        print(messageToLog)
    }
    
}