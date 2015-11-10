//
//  WeatherInfo.swift
//  NewsReader
//
//  Created by Harold on 15/8/20.
//  Copyright © 2015年 GetStarted. All rights reserved.
//

import Foundation

class WeatherInfo: BaseInfo {
    
    var day:String?
    var week:String?
    var cityName:String?
    var temperature:String?
    var currentTemp:String?
    var humidity:String?
    var wind:String?
    var windGrad:String?
    var iconUrl:String?
    override init(infoFromDict dict: NSDictionary) {
        
        cityName = dict.objectForKey("citynm") as? String
        day = dict.objectForKey("days") as? String
        week = dict.objectForKey("week") as? String
        temperature = dict.objectForKey("temperature") as? String
        currentTemp = dict.objectForKey("temperature_curr") as? String
        humidity = dict.objectForKey("humidity") as? String
        iconUrl = dict.objectForKey("weather_icon") as? String
        wind = dict.objectForKey("wind") as? String
        windGrad = dict.objectForKey("winp") as? String
        super.init()
        name = dict.objectForKey("weather") as! NSString
        
    }
}