//
//  ZHGetContent.swift
//  NewsReader
//
//  Created by Harold on 15/8/17.
//  Copyright © 2015年 GetStarted. All rights reserved.
//

import Foundation

class ZHGetContent: ZHOperation {
    
    override func parseData(data: NSData) {
        if data.length <= 0 {
            self.parseSuccess(NSDictionary(), jsonstring: NSString())
            return
        }
        
        let jsonString = NSString(data: data, encoding: NSUTF8StringEncoding) as! String
        let dict:NSMutableDictionary = FxJsonUtility.jsonValueFromString(jsonString) as! NSMutableDictionary
        var dictResult:NSDictionary?
        if let articleID = _opInfo.objectForKey("aid") as? NSString {
            dictResult = dict.objectForKey(articleID) as? NSDictionary
        }
        
        if let result = dictResult {
            self.parseSuccess(result, jsonstring: jsonString)
        }else{
            self.parseFail(jsonString)
        }
        _receiveData = nil
        
    }
    
    override func parseSuccess(dict: NSDictionary, jsonstring: NSString) {
        
        let info = ContentInfo(infoFromDict: dict)
        _delegate.opSuccess(info)
    }
}