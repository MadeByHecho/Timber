//
//  MessageFormatter.swift
//  Timber
//
//  Created by Scott Petit on 9/8/14.
//  Copyright (c) 2014 Scott Petit. All rights reserved.
//

import Foundation

public protocol MessageFormatterType {
    func formatLogMessage(logMessage: LogMessage) -> String
}

public struct MessageFormatter: MessageFormatterType {
    
    public init() {
    }
    
    public func formatLogMessage(logMessage: LogMessage) -> String {
        let calendarUnitFlags: NSCalendarUnit = .CalendarUnitYear | .CalendarUnitMonth | .CalendarUnitDay | .CalendarUnitHour | .CalendarUnitMinute | .CalendarUnitSecond
        var appName = FileManager.applicationName()
        
        let components = NSCalendar.autoupdatingCurrentCalendar().components(calendarUnitFlags, fromDate: logMessage.timestamp)
        
        var messageToLog = logMessage.logLevel.toString()
        let timestampString = NSString(format: "%04ld-%02ld-%02ld %02ld:%02ld:%02ld", components.year,
            components.month,
            components.day,
            components.hour,
            components.minute,
            components.second)
        messageToLog += " \(timestampString) \(appName) [\(logMessage.file) '\(logMessage.function)'] \(logMessage.message)"
        
        return messageToLog
    }
    
}