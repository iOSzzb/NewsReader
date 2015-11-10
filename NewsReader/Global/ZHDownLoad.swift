//
//  ZHDownLoad.swift
//  NewsReader
//
//  Created by Harold on 15/8/14.
//  Copyright © 2015年 GetStarted. All rights reserved.
//

import Foundation
import UIKit

class ZHDownload:NSObject {
    
    var dictIcons:NSMutableDictionary
    var iconQueue:NSOperationQueue
    
    
    //单利模式实例化ZHDownload
    class func download() -> ZHDownload {
        
        struct Instance {
            
            static var s_download:ZHDownload?
            static var onceToken:dispatch_once_t = 0
        }
        
        dispatch_once(&Instance.onceToken) { () -> Void in
            
            Instance.s_download = ZHDownload()
        }
        
        return Instance.s_download!
        
    }
    
    override init() {
        
        dictIcons = NSMutableDictionary()
        iconQueue = NSOperationQueue()
        iconQueue.maxConcurrentOperationCount = 4
        
        super.init()
        
    }
    
    func cancelDownload(){
        iconQueue.cancelAllOperations()
    }
    
    func setNewsIcon(newsInfo:NewsInfo,imageView:UIImageView) {
        
        var file = NewsIconPrex + (newsInfo.ID as String)
        var image:UIImage
        
        file = ZHGlobal.getCacheImage(file)
        
        if ZHFileUtility.isFieleExist(file) {
            
            image = UIImage(contentsOfFile: file)!
            imageView.image = image
        }
        else {
            imageView.image = UIImage(named: "NewsDefault.png")
            self.downloadNewsIcon(newsInfo)
        }
    }
    
    func downloadNewsIcon(info:NewsInfo){
        
        let op = NSBlockOperation { () -> Void in
            self.downNewsIconThread(info)
        }
        
        iconQueue.addOperation(op)
    }
    
    func downNewsIconThread(info:NewsInfo) {
        
        var file = NewsIconPrex + (info.ID as String)
        let url = NSURL(string: info.iconUrl)
        
        file = ZHGlobal.getCacheImage(file)
        if let iconUrl = url {
            let data = NSData(contentsOfURL: iconUrl)
            var image:UIImage?
            if data != nil {
                image = UIImage(data: data!)
            }else {
                image = UIImage(named: "NewsDefault.png")
            }
            
            let dictInfo = NSMutableDictionary()
            dictInfo.setObject(info, forKey: "info")
            dictInfo.setObject(image!, forKey: "data")
            data?.writeToFile(file, atomically: true)
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.notifyNewsIconDownLoad(dictInfo)
            })
        }
    }
    
    func notifyNewsIconDownLoad(dict:NSDictionary) {
        
        NSNotificationCenter.defaultCenter().postNotificationName(NotifyNewsIcon, object: dict)
    }
}


