//
//  ContentImageInfo.swift
//  NewsReader
//
//  Created by Harold on 15/8/17.
//  Copyright © 2015年 GetStarted. All rights reserved.
//

import Foundation

class ContentImageInfo: BaseInfo {
    
    var ref:String?
    var pixel:String?
    var alt:String?
    var src:String?
    
    override init(infoFromDict dict: NSDictionary) {
        ref = dict.objectForKey("ref") as? String
        pixel = dict.objectForKey("pixel") as? String
        alt = dict.objectForKey("alt") as? String
        src = dict.objectForKey("src") as? String
        
        super.init()
    }
    
//    override class func arrayFormDict(dict:NSDictionary)->NSArray{
//        
//        let array = dict.objectForKey(NewsData) as? NSArray
//        return self.arrayFromArray(array!)
//    }
    
    override class func arrayFromArray(array:NSArray) -> NSArray {
        
        let infos = NSMutableArray()
        for dict in array{
            infos.addObject(ContentImageInfo(infoFromDict:dict as! NSDictionary ))
        }
        return infos
    }

}