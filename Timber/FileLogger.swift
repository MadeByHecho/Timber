//
//  FileLogger.swift
//  Timber
//
//  Created by Scott Petit on 9/7/14.
//  Copyright (c) 2014 Scott Petit. All rights reserved.
//

import Foundation

public struct FileLogger: Logger {
    
    public init() {
        FileManager.purgeOldFiles()
        FileManager.purgeOldestFilesGreaterThanCount(5)
    }
    
    //MARK: Logger
    
    public var messageFormatter: MessageFormatterType = MessageFormatter()
    
    public func logMessage(message: LogMessage) {
        let currentData = FileManager.currentLogFileData()
        let mutableData = NSMutableData(data: currentData)
        
        var messageToLog = messageFormatter.formatLogMessage(message)
        messageToLog += "\n"
        
        if let dataToAppend = messageToLog.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false) {
            mutableData.appendData(dataToAppend)
        }
        
        if let filePath = FileManager.currentLogFilePath() {
            mutableData.writeToFile(filePath, atomically: false)
        }
    }
    
}

struct FileManager {
    
    static let userDefaultsKey = "com.Timber.currentLogFile"
    static let maximumLogFileSize = 1024 * 1024 // 1 mb
    static let maximumFileExsitenceInterval: NSTimeInterval = 60 * 60 * 24 * 180 // 180 days
    
    static func currentLogFilePath() -> String? {
        if let path: AnyObject = NSUserDefaults.standardUserDefaults().objectForKey(userDefaultsKey) {
            return path as? String
        } else {
            return createNewLogFilePath()
        }
    }
    
    static func shouldCreateNewLogFileForData(data: NSData) -> Bool {
        return data.length > maximumLogFileSize
    }
    
    static func createNewLogFilePath() -> String? {
        if let logsDirectory = defaultLogsDirectory() {
            let newLogFilePath = logsDirectory.stringByAppendingPathComponent(newLogFileName())
            NSUserDefaults.standardUserDefaults().setObject(newLogFilePath, forKey: userDefaultsKey)
            NSUserDefaults.standardUserDefaults().synchronize()
            
            return newLogFilePath
        }
        
        return nil
    }
    
    static func newLogFileName() -> String {
        let appName = applicationName()
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy'-'MM'-'dd'_'HH'-'mm'"
        dateFormatter.timeZone = NSTimeZone(forSecondsFromGMT: 0)
        let formattedDate = dateFormatter.stringFromDate(NSDate())
        
        let newLogFileName = "\(appName)_\(formattedDate).log"
        
        return newLogFileName
    }
    
    static func applicationName() -> String {
        let processName = NSProcessInfo.processInfo().processName
        if count(processName) > 0 {
            return processName
        } else {
            return "<UnnamedApp>"
        }
    }
    
    static func defaultLogsDirectory() -> String? {
        // Update how we get file URLs per Apple Technical Note https://developer.apple.com/library/ios/technotes/tn2406/_index.html
        let cachesDirectoryPathURL = NSFileManager.defaultManager().URLsForDirectory(.CachesDirectory, inDomains: .UserDomainMask).last as! NSURL
        
        if cachesDirectoryPathURL.fileURL {
            if let cachesDirectoryPath = cachesDirectoryPathURL.path {
                let logsDirectory = cachesDirectoryPath.stringByAppendingPathComponent("Timber")
                
                if !NSFileManager.defaultManager().fileExistsAtPath(logsDirectory) {
                    NSFileManager.defaultManager().createDirectoryAtPath(logsDirectory, withIntermediateDirectories: true, attributes: nil, error: nil)
                }
                
                return logsDirectory
            }
        }
        
        return nil
    }
    
    static func currentLogFileData() -> NSData {
        if let filePath = currentLogFilePath() {
            if let data = NSData(contentsOfFile: filePath) {
                if shouldCreateNewLogFileForData(data) {
                    createNewLogFilePath()
                }
                
                return data
            }
        }
        
        return NSData()
    }
    
    static func purgeOldFiles() {
        if let logsDirectory = defaultLogsDirectory() {
            TrashMan.takeOutFilesInDirectory(logsDirectory, withExtension: "log", notModifiedSince: NSDate(timeIntervalSinceNow: -maximumFileExsitenceInterval))
        }
    }
    
    static func purgeOldestFilesGreaterThanCount(count: Int) {
        if let logsDirectory = defaultLogsDirectory() {
            TrashMan.takeOutOldestFilesInDirectory(logsDirectory, greaterThanCount: count)
        }
    }
}

public struct TrashMan {
    
    public static func takeOutFilesInDirectory(directoryPath: String, notModifiedSince minimumModifiedDate: NSDate) {
        takeOutFilesInDirectory(directoryPath, withExtension: nil, notModifiedSince: minimumModifiedDate)
    }
    
    public static func takeOutFilesInDirectory(directoryPath: String, withExtension fileExtension: String?, notModifiedSince minimumModifiedDate: NSDate) {
        if let fileURL = NSURL(fileURLWithPath: directoryPath, isDirectory: true) {
            let fileManager = NSFileManager.defaultManager()
            let contents = fileManager.contentsOfDirectoryAtURL(fileURL, includingPropertiesForKeys: [NSURLAttributeModificationDateKey], options: .SkipsHiddenFiles, error: nil)
            
            if let files = contents as? [NSURL] {
                for file in files {
                    var fileDate: AnyObject?
                    
                    let haveDate = file.getResourceValue(&fileDate, forKey: NSURLAttributeModificationDateKey, error: nil)
                    if !haveDate {
                        continue
                    }
                    
                    if fileDate?.timeIntervalSince1970 >= minimumModifiedDate.timeIntervalSince1970 {
                        continue
                    }
                    
                    if fileExtension != nil {
                        if file.pathExtension != fileExtension! {
                            continue
                        }
                    }
                    
                    fileManager.removeItemAtURL(file, error: nil)
                }
            }
        }
    }
    
    public static func takeOutOldestFilesInDirectory(directoryPath: String, greaterThanCount count: Int) {
        if let directoryURL = NSURL(fileURLWithPath: directoryPath, isDirectory: true) {
            let contents = NSFileManager.defaultManager().contentsOfDirectoryAtURL(directoryURL, includingPropertiesForKeys: [NSURLCreationDateKey], options: .SkipsHiddenFiles, error: nil)
            
            if let files = contents as? [NSURL] {
                if count >= files.count {
                    return
                }
                
                let sortedFiles = files.sorted({ (firstFile: NSURL, secondFile: NSURL) -> Bool in
                    var firstFileObject: AnyObject?
                    
                    let haveFirstDate = firstFile.getResourceValue(&firstFileObject, forKey: NSURLCreationDateKey, error: nil)
                    if !haveFirstDate {
                        return false
                    }
                    
                    var secondFileObject: AnyObject?
                    
                    let haveSecondDate = secondFile.getResourceValue(&secondFileObject, forKey: NSURLCreationDateKey, error: nil)
                    if !haveSecondDate {
                        return true
                    }
                    
                    let firstFileDate = firstFileObject as! NSDate
                    let secondFileDate = secondFileObject as! NSDate
                    
                    let comparisonResult = firstFileDate.compare(secondFileDate)
                    return comparisonResult == NSComparisonResult.OrderedDescending
                })
                
                for (index, fileURL) in enumerate(sortedFiles) {
                    if index >= count {
                        NSFileManager.defaultManager().removeItemAtURL(fileURL, error: nil)
                    }
                }
            }
        }
    }
    
}
