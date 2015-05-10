//
//  Utils.swift
//  MediaDownload
//
//  Created by David Bennet on 2/11/15.
//  Copyright (c) 2015 David Bennet. All rights reserved.
//

import UIKit

var MAX_DOWNLOADS_COUNT: Int = 10

class Utils: NSObject {
    
    class func screenWidth() ->CGFloat  {
        return UIScreen.mainScreen().bounds.size.width
    }
    
    class func screenHeight() ->CGFloat {
        return UIScreen.mainScreen().bounds.size.height
    }
    
    class func downloadedFileURL() ->NSURL {
        let directoryURL = NSFileManager.defaultManager()
            .URLsForDirectory(.DocumentDirectory,
                inDomains: .UserDomainMask)[0]
            as? NSURL
        
        let downloadedFileURL = directoryURL?.URLByAppendingPathComponent("temp.mp4")
        
        return downloadedFileURL!
    }
    
    class func downloadDirectoryURL() ->NSURL {
        let directoryURL = NSFileManager.defaultManager()
            .URLsForDirectory(.DocumentDirectory,
                inDomains: .UserDomainMask)[0]
            as? NSURL
        let downloadDirectoryURL = directoryURL?.URLByAppendingPathComponent("MediaDownload")
        
        let fileManager = NSFileManager.defaultManager()
        if !fileManager.fileExistsAtPath((downloadDirectoryURL?.path)!) {
            fileManager.createDirectoryAtURL(downloadDirectoryURL!, withIntermediateDirectories: false, attributes: nil, error: nil)
        }
        
        return downloadDirectoryURL!
    }
    
    class func downloadFileURL(medium: MediumObject) ->NSURL {
        let downloadDirectoryURL = self.downloadDirectoryURL()
        let fileURL = downloadDirectoryURL.URLByAppendingPathComponent(NSString(format: "%d.%@", medium.fullPath.hash, medium.isVideo ? "mp4" : "jpg"))
        return fileURL
    }
    
    class func showMessage(msg: NSString, title: NSString) {
        let alertView = UIAlertView(title: title, message: msg, delegate: nil, cancelButtonTitle: "OK")
        alertView.show()
    }
    
    class func removeAllDownloadedFiles() {
        NSFileManager.defaultManager().removeItemAtURL(self.downloadDirectoryURL(), error: nil)
    }
    
    class func removeOldestFileIfNeeded() {
        let downloadDirectoryURL = self.downloadDirectoryURL()
        var directoryContents: NSArray
        directoryContents = NSFileManager.defaultManager().contentsOfDirectoryAtPath(downloadDirectoryURL.path!, error: nil)!
        
        NSLog("dcontents: %@ %d %d", directoryContents, directoryContents.count, MAX_DOWNLOADS_COUNT)
        
        // check if needed
        if directoryContents.count < MAX_DOWNLOADS_COUNT {
            return
        }
        
        // get oldest file
        var oldestFileURL: NSURL!
        for (var i = 0; i < directoryContents.count; i++) {
            let filename: NSString = directoryContents.objectAtIndex(i) as NSString
            let fileURL = downloadDirectoryURL.URLByAppendingPathComponent(filename)
            
            if oldestFileURL == nil {
                oldestFileURL = fileURL
                continue
            }
            
            if (self.getCreationDate(fileURL).compare(self.getCreationDate(oldestFileURL)) == NSComparisonResult.OrderedAscending) {
                oldestFileURL = fileURL
            }
        }
        
        // remove oldest file
        if (oldestFileURL != nil) {
            NSFileManager.defaultManager().removeItemAtURL(oldestFileURL, error: nil)
        }
    }
    
    class func getCreationDate(url: NSURL)-> NSDate {
        let fileManager = NSFileManager.defaultManager()
        var attrs:NSDictionary = fileManager.attributesOfItemAtPath(url.path!, error: nil)!
        let createDate: NSDate! = attrs.objectForKey(NSFileCreationDate) as NSDate
        return createDate
    }
}
