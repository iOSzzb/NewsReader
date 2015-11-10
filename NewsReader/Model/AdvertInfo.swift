//
//  AdvertInfo.swift
//  NewsReader
//
//  Created by Harold on 15/8/7.
//  Copyright © 2015年 GetStarted. All rights reserved.
//

import Foundation
class AdvertInfo:BaseInfo {
    var imageUrl:NSString
    var linkUrl:NSString
    
    override init(infoFromDict dict: NSDictionary) {
        imageUrl = dict.objectForKey("imageurl") as! NSString
        linkUrl = dict.objectForKey("linkurl") as! NSString
        super.init(infoFromDict: dict)
    }
}