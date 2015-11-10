//
//  ColumnInfo.swift
//  NewsReader
//
//  Created by Harold on 15/8/11.
//  Copyright © 2015年 GetStarted. All rights reserved.
//

import Foundation

class ColumnInfo: BaseInfo {
    
    var url:String?
    
    override init(infoFromDict dict: NSDictionary) {
        url = dict.objectForKey("url") as? String
        super.init(infoFromDict: dict)
    }
    
    override class func arrayFormDict(dict:NSDictionary)->NSArray{
        
        let array = dict.objectForKey(NetData) as? NSArray
        return self.arrayFromArray(array!)
    }
    
    override class func arrayFromArray(array:NSArray) -> NSArray {
        
        let infos = NSMutableArray()
        for dict in array{
            infos.addObject(ColumnInfo(infoFromDict:dict as! NSDictionary ))
        }
        return infos
    }
}