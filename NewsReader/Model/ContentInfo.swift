//
//  ContentInfo.swift
//  NewsReader
//
//  Created by Harold on 15/8/17.
//  Copyright © 2015年 GetStarted. All rights reserved.
//

import Foundation

class ContentInfo: BaseInfo {
    
    var title:String?
    var source:String?
    var ptime:String?
    var digest:String?
    var body:String?
    var ec:String?
    var sourceurl:String?
    var images:NSArray?
    
    override init(infoFromDict dict: NSDictionary) {
        
        title = dict.objectForKey("title") as? String
        source = dict.objectForKey("source") as? String
        ptime = dict.objectForKey("ptime") as? String
        digest = dict.objectForKey("digest") as? String
        body = dict.objectForKey("body") as? String
        ec = dict.objectForKey("ec") as? String
        sourceurl = dict.objectForKey("source_url") as? String
        if let imageArray = dict.objectForKey("img") as? NSArray {
          images = ContentImageInfo.arrayFromArray(imageArray)
        }
        
        super.init()

    }
    
    
}