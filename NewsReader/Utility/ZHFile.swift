//
//  ZHFile.swift
//  NewsReader
//
//  Created by Harold on 15/8/7.
//  Copyright © 2015年 GetStarted. All rights reserved.
//

import Foundation

class ZHFileUtility: NSObject {
    class func isFieleExist(filePath:NSString) -> Bool{
        let fm = NSFileManager.defaultManager()
        return fm.fileExistsAtPath(filePath as String)
    }
    
    class func createPath(filePath:NSString) -> Bool{
        if ZHFileUtility.isFieleExist(filePath) {
            return true
        }
        
        let fm = NSFileManager.defaultManager()
        //swift2.0中新的错误处理机制。
        do{
        try fm.createDirectoryAtPath(filePath as String, withIntermediateDirectories: true, attributes: nil)
        } catch {
            print("创建文件出现错误\(error)")
            return false
        }
        return true
    }
    
    class func renameFile(filePath:NSString ,toFile:NSString) -> Bool{
        let fm = NSFileManager.defaultManager()
        if ZHFileUtility.isFieleExist(toFile) {
            do{
                try fm.removeItemAtPath(filePath as String)
            }catch{
                print(error)
            }
        }
        do{
            try fm.moveItemAtPath(filePath as String, toPath: toFile as String)
        }catch{
            print(error)
            return false
        }
        return true
    }
    
    class func deleteFile(filePath:NSString) -> Bool{
        if !ZHFileUtility.isFieleExist(filePath){
            return true
        }
        let fm = NSFileManager.defaultManager()
        do{
            try fm.removeItemAtPath(filePath as String)
        }catch{
            print("删除文件失败\(error)")
            return false
        }
        return true
    }
    
    class func copyFromPath(fromPath:NSString,toPath:NSString,isReplace:Bool) -> Bool {
        let fm = NSFileManager.defaultManager()
        if ZHFileUtility.isFieleExist(toPath) && isReplace {
            ZHFileUtility.deleteFile(toPath)
        }
        do{
            try fm.copyItemAtPath(fromPath as String, toPath: toPath as String)
        }catch{
            print("拷贝文件失败\(error)")
            return false
        }
        return true
    }
    
    class func copyContentsFromPath(fromPath:NSString ,toPath:NSString ,isReplace:Bool) -> Bool{
        let fm = NSFileManager.defaultManager()
        var contents = NSArray()
        do {
            contents = try fm.contentsOfDirectoryAtPath(fromPath as String)
        }catch{
            print("获取文件内容失败 \(error)")
        }
        
        var toFiletPath = NSString()
        var fromFilePath = NSString()
        for path in contents{
            toFiletPath = toPath.stringByAppendingPathComponent(path as! String)
            fromFilePath = fromPath.stringByAppendingPathComponent(path as! String)
            if ZHFileUtility.isFieleExist(toFiletPath) && isReplace {
                ZHFileUtility.deleteFile(toFiletPath)
            }
            do{
                try fm.copyItemAtPath(fromFilePath as String, toPath: toFiletPath as String)
            }catch{
                print("拷贝内容失败\(error)")
                return false
            }
        }
        return true
    }
    
    class func moveFromPath(fromePath:NSString,toPath:NSString,isReplace:Bool) -> Bool {
        let fm = NSFileManager.defaultManager()
        if ZHFileUtility.isFieleExist(toPath) && isReplace {
            ZHFileUtility.deleteFile(toPath)
        }
        do{
            try fm.moveItemAtPath(fromePath as String, toPath: toPath as String)
        }catch{
            print("移动文件失败\(error)")
            return false
        }
        return true
    }
    
    class func moveContentsFromePath(fromPath:NSString,toPath:NSString,isReplace:Bool) -> Bool{
        
        let fm = NSFileManager.defaultManager()
        var contents = NSArray()
        
        do{
            try contents = fm.contentsOfDirectoryAtPath(fromPath as String)
        }catch{
            print("获取内容失败\(error)")
        }
        
        var toFilePath = NSString()
        var fromFilePath = NSString()
        
        for path in contents {
            
            toFilePath = toPath.stringByAppendingPathComponent(path as! String)
            fromFilePath = fromPath.stringByAppendingPathComponent(path as! String)
            
            if ZHFileUtility.isFieleExist(toFilePath) && isReplace {
                ZHFileUtility.deleteFile(toFilePath)
            }
            
            do{
                try fm.moveItemAtPath(fromFilePath as String, toPath: toFilePath as String)
            }catch{
                print("移动文件内容失败\(error)")
                return false
            }
        }
        return true
    }
    
    class func calcuteFileSize(filePath:NSString) -> Double{
        var fSize:Double = 0.0
        let fm = NSFileManager.defaultManager()
        var dirContents = NSArray()
        do{
            try dirContents = fm.contentsOfDirectoryAtPath(filePath as String)
        }catch{
            var dirAttr = NSDictionary()
            do{
                dirAttr = try fm.attributesOfItemAtPath(filePath as String)
                
            }catch{
                print("What's wrong ,you tell me ")
            }
            fSize += (dirAttr.objectForKey(NSFileSize)?.doubleValue)!
        }
        for dirName in dirContents {
            fSize += ZHFileUtility.calcuteFileSize(filePath.stringByAppendingPathComponent(dirName as! String))
        }
        return fSize
        
    }
}