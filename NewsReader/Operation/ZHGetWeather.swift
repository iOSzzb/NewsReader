//
//  ZHGetWeather.swift
//  NewsReader
//
//  Created by Harold on 15/8/20.
//  Copyright © 2015年 GetStarted. All rights reserved.
//

import Foundation

class ZHGetWeather: ZHOperation {
    
    override func parseData(data: NSData) {
        
        if data.length <= 0 {
            self.parseSuccess(NSDictionary(), jsonstring: NSString())
            return
        }
        
        let jsonString = NSString(data: data, encoding: NSUTF8StringEncoding) as! String
        let dict:NSMutableDictionary = FxJsonUtility.jsonValueFromString(jsonString) as! NSMutableDictionary
        let success = dict.objectForKey("success") as! String
        let result = dict.objectForKey("result") as? NSDictionary
        if success == "1" {
            self.parseSuccess(result!, jsonstring: jsonString)
        }else{
            self.parseFail(jsonString)
        }
        _receiveData = nil
        
    }
    
    override func parseSuccess(dict: NSDictionary, jsonstring: NSString) {
        
        let info = WeatherInfo(infoFromDict: dict)
        _delegate.opSuccess(info)
    }
}