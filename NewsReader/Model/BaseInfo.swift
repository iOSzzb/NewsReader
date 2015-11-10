//
//  BaseInfo.swift
//  NewsReader
//
//  Created by Harold on 15/8/7.
//  Copyright © 2015年 GetStarted. All rights reserved.
//

import Foundation

class BaseInfo:NSObject{
    var ID:NSString
    var name:NSString
    
    override init(){
        self.ID = ""
        self.name = ""
    }
    
    init(infoFromDict dict:NSDictionary)
    {
        self.ID = dict.objectForKey("id") as! NSString
        self.name = dict.objectForKey("name") as! NSString
    }
    
    class func arrayFormDict(dict:NSDictionary)->NSArray{
        
        let array = dict.objectForKey(NetData) as? NSArray
        return self.arrayFromArray(array!)
    }
    
    class func arrayFromArray(array:NSArray) -> NSArray {
        
        let infos = NSMutableArray()
        for dict in array{
            infos.addObject(BaseInfo(infoFromDict:dict as! NSDictionary ))
        }
        return infos
    }
    
    func compare(bInfo:BaseInfo) -> NSComparisonResult{
        return self.ID.caseInsensitiveCompare(bInfo.ID as String)
    }
    
    func isEqualtoInfo(bInfo:BaseInfo) -> Bool{
        return self.ID.isEqualToString(bInfo.ID as String)
    }
    
}