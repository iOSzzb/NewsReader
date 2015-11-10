//
//  NewsInfo.swift
//  NewsReader
//
//  Created by Harold on 15/8/12.
//  Copyright © 2015年 GetStarted. All rights reserved.
//

import Foundation

class NewsInfo: BaseInfo {
    
    var desc:String
    var iconUrl:String
    var contentUrl:String?
    override init(infoFromDict dict: NSDictionary) {
        
        self.desc = dict.objectForKey("digest") as! String
        self.iconUrl = dict.objectForKey("imgsrc") as! String
        self.contentUrl = dict.objectForKey("url") as? String
        
        super.init()
        
        self.ID = dict.objectForKey("docid") as! NSString
//        self.name = dict.objectForKey("name") as! NSString
        self.name = dict.objectForKey("title") as! NSString
        
    }
    
    override class func arrayFormDict(dict:NSDictionary)->NSArray{
        
        
        let array = dict.objectForKey(NewsData) as? NSArray
        return self.arrayFromArray(array!)
    }
    
    override class func arrayFromArray(array:NSArray) -> NSArray {
        
        let infos = NSMutableArray()
        for dict in array{
            infos.addObject(NewsInfo(infoFromDict:dict as! NSDictionary ))
        }
        return infos
    }
    
    class func getArrayFormDictByID(dict:NSDictionary,id:String) -> NSArray {
        
        let array = dict.objectForKey(id) as! NSArray
        return self.arrayFromArray(array)
    }

}