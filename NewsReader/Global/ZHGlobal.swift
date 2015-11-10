//
//  ZHGlobal.swift
//  NewsReader
//
//  Created by Harold on 15/8/9.
//  Copyright © 2015年 GetStarted. All rights reserved.
//

import Foundation
import UIKit

class ZHGlobal: NSObject {
    class func global() {
        
    }
    
    
    //MARK 判断系统版本
    class func isSystemLowerIOS8() -> Bool {
        let device = UIDevice.currentDevice()
        let sysVersion = Float(device.systemVersion)
        
        if sysVersion! - 8.0 < -0.001 {
            return true
        }
        return false
    }
    
    class func isSystemLowerIOS7() -> Bool {
        
        let device = UIDevice.currentDevice()
        let sysVersion = Float(device.systemVersion)
        
        if sysVersion! - 7.0 < -0.001 {
            return true
        }
        return false
    }
    
    class func getRootPath() -> String {
        
        let path = NSHomeDirectory().stringByAppendingPathComponent(RootPath)
        ZHFileUtility.createPath(path)

        return path
    }
    
    class func getCacheImage(fileName:String) -> String {
        var path = "\(ZHGlobal.getRootPath())/\(CacheImagePath)"
        
        ZHFileUtility.createPath(path)
        path = "\(path)/\(fileName).jpg"
        return path
    }
    
    class func getUserDBFile() -> String {
        
        let path = ZHGlobal.getRootPath()
        return path.stringByAppendingPathComponent(NewsDBFile)
    }
    
    // 设置不从iCloud、iTunes备份
    class func setNotBackUp(filePath:String) -> Bool {
        
        let fileURL = NSURL.fileURLWithPath(filePath)
        let attrValue = NSNumber(bool: true)
        
        do {
            try fileURL.setResourceValue(attrValue, forKey: NSURLIsExcludedFromBackupKey)
        }catch{
            print(error)
            return false
        }
        
        return true
    }
    
    
    
}
