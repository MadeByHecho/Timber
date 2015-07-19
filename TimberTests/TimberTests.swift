//
//  TimberTests.swift
//  TimberTests
//
//  Created by Scott Petit on 9/7/14.
//  Copyright (c) 2014 Scott Petit. All rights reserved.
//

import XCTest
@testable import Timber
import Miles

func wait() {
    waitForSeconds(1.0)
}

func waitForSeconds(seconds: NSTimeInterval) {
    NSRunLoop.currentRunLoop().runMode(NSDefaultRunLoopMode, beforeDate: NSDate(timeIntervalSinceNow: seconds))
}

class TimberTests: XCTestCase {
    
    let testLogger = TestLogger()
    let errorMessage = "this is an error"
    let warnMessage = "this is a warning"
    let infoMessage = "this is info"
    let debugMessage = "this is debug"
    let verboseMessage = "this is verbose"
    
    func testLogLevelNoneDoesntLogAnything() {
        Timber.setLogLevel(.None)
        Timber.addLogger(testLogger)
        
        Log("Hello")
        
        LogError(errorMessage)
        LogWarn(warnMessage)
        LogInfo(infoMessage)
        LogDebug(debugMessage)
        LogVerbose(verboseMessage)
        
        testLogger.loggedMessageCount.shouldEqual(0)
    }
    
    func testLogLevelErrorOnlyLogsError() {
        Timber.setLogLevel(.Error)
        Timber.addLogger(testLogger)
        
        LogError(errorMessage)
        LogWarn(warnMessage)
        LogInfo(infoMessage)
        LogDebug(debugMessage)
        LogVerbose(verboseMessage)
        
        testLogger.loggedMessageCount.shouldEqual(1)
        testLogger.lastLoggedMessage.shouldEqual(errorMessage)
    }
    
    func testLogLevelWarnOnlyLogsErrorAndWarn() {
        Timber.setLogLevel(.Warn)
        Timber.addLogger(testLogger)
        
        LogError(errorMessage)
        LogWarn(warnMessage)
        LogInfo(infoMessage)
        LogDebug(debugMessage)
        LogVerbose(verboseMessage)
        
        testLogger.loggedMessageCount.shouldEqual(2)
        testLogger.lastLoggedMessage.shouldEqual(warnMessage)
    }
    
    func testLogLevelInfoOnlyLogsErrorWarnAndInfo() {
        Timber.setLogLevel(.Info)
        Timber.addLogger(testLogger)
        
        LogError(errorMessage)
        LogWarn(warnMessage)
        LogInfo(infoMessage)
        LogDebug(debugMessage)
        LogVerbose(verboseMessage)
        
        testLogger.loggedMessageCount.shouldEqual(3)
        testLogger.lastLoggedMessage.shouldEqual(infoMessage)
    }
    
    func testLogLevelDebugOnlyLogsErrorWarnInfoAndDebug() {
        Timber.setLogLevel(.Debug)
        Timber.addLogger(testLogger)
        
        LogError(errorMessage)
        LogWarn(warnMessage)
        LogInfo(infoMessage)
        LogDebug(debugMessage)
        LogVerbose(verboseMessage)
        
        testLogger.loggedMessageCount.shouldEqual(4)
        testLogger.lastLoggedMessage.shouldEqual(debugMessage)
    }
    
    func testLogLevelVerboseOnlyLogsErrorWarnInfoDebugAndVerbose() {
        Timber.setLogLevel(.Verbose)
        Timber.addLogger(testLogger)
        
        LogError(errorMessage)
        LogWarn(warnMessage)
        LogInfo(infoMessage)
        LogDebug(debugMessage)
        LogVerbose(verboseMessage)
        
        testLogger.loggedMessageCount.shouldEqual(5)
        testLogger.lastLoggedMessage.shouldEqual(verboseMessage)
    }
    
}

class TrashManTests: XCTestCase {
    
    let trashManDirectory = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first?.stringByAppendingPathComponent("TrashMan")
    
    override func setUp() {
        super.setUp()
        
        if !NSFileManager.defaultManager().fileExistsAtPath(trashManDirectory!) {
            do {
                try NSFileManager.defaultManager().createDirectoryAtPath(trashManDirectory!, withIntermediateDirectories: true, attributes: nil)
            } catch _ {
            }
        }
    }
    
    override func tearDown() {
        do {
            try NSFileManager.defaultManager().removeItemAtPath(trashManDirectory!)
        } catch _ {
        }
        
        super.tearDown()
    }
    
    func testRemovingALLFiles() {
        let filePath = addTestFile()
        
        let fileExists = NSFileManager.defaultManager().fileExistsAtPath(filePath)
        TrashMan.takeOutFilesInDirectory(trashManDirectory!, notModifiedSince: NSDate())
        let fileExistsAfterTrashMan = NSFileManager.defaultManager().fileExistsAtPath(filePath)
        
        fileExists.shouldBeTrue()
        fileExistsAfterTrashMan.shouldBeFalse()
    }
    
    func testRemovingTXTFiles() {
        let filePath = addTestFile()
        
        let fileExists = NSFileManager.defaultManager().fileExistsAtPath(filePath)
        TrashMan.takeOutFilesInDirectory(trashManDirectory!, withExtension: "txt", notModifiedSince: NSDate())
        let fileExistsAfterTrashMan = NSFileManager.defaultManager().fileExistsAtPath(filePath)

        fileExists.shouldBeTrue()
        fileExistsAfterTrashMan.shouldBeFalse()
    }
    
    func testRemovingLOGFiles() {
        let filePath = addTestFile()
        
        let fileExists = NSFileManager.defaultManager().fileExistsAtPath(filePath)
        TrashMan.takeOutFilesInDirectory(trashManDirectory!, withExtension: "log", notModifiedSince: NSDate())
        let fileExistsAfterTrashMan = NSFileManager.defaultManager().fileExistsAtPath(filePath)
        
        fileExists.shouldBeTrue()
        fileExistsAfterTrashMan.shouldBeTrue()
    }
    
    func testRemovingFilesGreaterThanCount() {
        Timber.addLogger(XcodeLogger())
        
        let firstFilePath = addTestFileWithName("test1.txt")
        wait()
        wait()
        let secondFilePath = addTestFileWithName("test2.txt")
        wait()
        wait()
        let thirdFilePath = addTestFileWithName("test3.txt")
        
        TrashMan.takeOutOldestFilesInDirectory(trashManDirectory!, greaterThanCount: 2)
        
        let fileCount = try! NSFileManager.defaultManager().contentsOfDirectoryAtPath(trashManDirectory!).count
        let firstFileExists = NSFileManager.defaultManager().fileExistsAtPath(firstFilePath)
        let secondFileExists = NSFileManager.defaultManager().fileExistsAtPath(secondFilePath)
        let thirdFileExists = NSFileManager.defaultManager().fileExistsAtPath(thirdFilePath)
        
        fileCount.shouldEqual(2)
        firstFileExists.shouldBeFalse()
        secondFileExists.shouldBeTrue()
        thirdFileExists.shouldBeTrue()
    }
    
    func addTestFile() -> String {
        return addTestFileWithName("test.txt")
    }
    
    func addTestFileWithName(name: String) -> String {
        let filePath = trashManDirectory?.stringByAppendingPathComponent(name)
        do {
            try "file to write".writeToFile(filePath!, atomically: true, encoding: NSUTF8StringEncoding)
        } catch _ {
        }
        
        return filePath!
    }
    
}
