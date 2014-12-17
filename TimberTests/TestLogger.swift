//
//  TestLogger.swift
//  Timber
//
//  Created by Scott Petit on 9/7/14.
//  Copyright (c) 2014 Scott Petit. All rights reserved.
//

import Foundation
import Timber

class TestLogger: Logger {
    
    var loggedMessageCount: Int = 0
    var lastLoggedMessage: String = ""
    
    var messageFormatter: MessageFormatterType = MessageFormatter()
    
    func logMessage(message: LogMessage) {
        lastLoggedMessage = message.message
        loggedMessageCount++
    }
}
