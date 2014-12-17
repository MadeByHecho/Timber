//
//  Timber.swift
//  Timber
//
//  Created by Scott Petit on 9/7/14.
//  Copyright (c) 2014 Scott Petit. All rights reserved.
//

import Foundation

//MARK: Global

public func LogError(message: String, file: String = __FILE__, function: String = __FUNCTION__, line: Int = __LINE__) {
    let logMessage = LogMessage(message: message, logLevel: .Error, timestamp: NSDate(), file: file, function: function, lineNumber: line)
    Timber.sharedTimber().log(logMessage)
}

public func LogWarn(message: String, file: String = __FILE__, function: String = __FUNCTION__, line: Int = __LINE__) {
    let logMessage = LogMessage(message: message, logLevel: .Warn, timestamp: NSDate(), file: file, function: function, lineNumber: line)
    Timber.sharedTimber().log(logMessage)
}

public func LogInfo(message: String, file: String = __FILE__, function: String = __FUNCTION__, line: Int = __LINE__) {
    let logMessage = LogMessage(message: message, logLevel: .Info, timestamp: NSDate(), file: file, function: function, lineNumber: line)
    Timber.sharedTimber().log(logMessage)
}

public func LogDebug(message: String, file: String = __FILE__, function: String = __FUNCTION__, line: Int = __LINE__) {
    let logMessage = LogMessage(message: message, logLevel: .Debug, timestamp: NSDate(), file: file, function: function, lineNumber: line)
    Timber.sharedTimber().log(logMessage)
}

public func LogVerbose(message: String, file: String = __FILE__, function: String = __FUNCTION__, line: Int = __LINE__) {
    let logMessage = LogMessage(message: message, logLevel: .Verbose, timestamp: NSDate(), file: file, function: function, lineNumber: line)
    Timber.sharedTimber().log(logMessage)
}

public func Log(message: String, file: String = __FILE__, function: String = __FUNCTION__, line: Int = __LINE__) {
    LogInfo(message, file: file, function: function, line: line)
}

public class Timber {
    
    private var loggers = [Logger]()
    private var logLevel = LogLevel.Verbose
    
    //MARK: Public
    
    public class func setLogLevel(level: LogLevel) {
        Timber.sharedTimber().logLevel = level
    }
    
    public class func addLogger(logger: Logger) {
        Timber.sharedTimber().addLogger(logger)
    }
    
    //MARK: Private
    
    private class func sharedTimber() -> Timber {
        if SharedTimber.instance == nil {
            dispatch_once(&SharedTimber.token) {
                SharedTimber.instance = Timber()
            }
        }
        
        return SharedTimber.instance!
    }
    
    private func addLogger(logger: Logger) {
        loggers.append(logger)
    }
    
    private func log(logMessage: LogMessage) {
        if logMessage.logLevel.rawValue > Timber.sharedTimber().logLevel.rawValue {
            return
        }
        
        for logger in self.loggers {
            logger.logMessage(logMessage)
        }
    }
}

private struct SharedTimber {
//    static var logLevel: LogLevel = .Verbose
    static var instance : Timber?
    static var token: dispatch_once_t = 0
}
