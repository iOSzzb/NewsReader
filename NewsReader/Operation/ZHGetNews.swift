//
//  ZHGetNew.swift
//  NewsReader
//
//  Created by Harold on 15/8/14.
//  Copyright © 2015年 GetStarted. All rights reserved.
//

import Foundation

class ZHGetNews: ZHOperation {
    
    override func parseData(data: NSData) {
        if data.length <= 0 {
            self.parseSuccess(NSDictionary(), jsonstring: NSString())
            return
        }
        
        let jsonString = NSString(data: data, encoding: NSUTF8StringEncoding) as! String
        let dict:NSMutableDictionary = FxJsonUtility.jsonValueFromString(jsonString) as! NSMutableDictionary

        if dict.count > 0 {
            self.parseSuccess(dict, jsonstring: jsonString)
        }else{
            self.parseFail(dict)
        }
        _receiveData = nil
        
    }
    
    override func parseSuccess(dict: NSDictionary, jsonstring: NSString) {
        let id = _opInfo.objectForKey("body") as! String
        let infos = NewsInfo.getArrayFormDictByID(dict, id: id)
        _delegate.opSuccess(infos)
        
        ZHDBManager.saveNews(["columnid":id,"json":jsonstring])
    }
}