//
//  ZHDate.swift
//  NewsReader
//
//  Created by Harold on 15/8/8.
//  Copyright © 2015年 GetStarted. All rights reserved.
//

import Foundation

let YMDFormat = "YYYY-MM-dd"
let YMDEHMFormat = "YYYY-MM-dd EEE HH:mm"
let YMDHMSFormat = "YYYY-MM-dd HH:mm:ss"

class ZHDate: NSObject {
    class func adjustDateHuor(var srcDate:NSDate,var minHour:Int,var maxHour:Int,var fitHour:Int) -> NSDate{
        
//        if srcDae == nil {
//            return srcDae
//        }
        if minHour >= 24 || maxHour >= 24 || fitHour >= 24{
            minHour %= 24
            maxHour %= 24
            fitHour %= 24
        }
        
        let unitFlags = NSCalendarUnit.Hour
        let calendar = NSCalendar.currentCalendar()
        let componets = calendar.components(unitFlags, fromDate: srcDate)
        let hour = componets.hour
        
        if hour <= minHour {
            srcDate = srcDate.dateByAddingTimeInterval(Double((fitHour - hour)*60*60))
        }
        else if hour >= maxHour {
            srcDate = srcDate.dateByAddingTimeInterval(Double((24 + fitHour - hour)*60*60))
        }
        return srcDate
    }
    
    class func stringFromDate(date:NSDate,formatter:NSDateFormatter?,format:String) -> String{
        
        if formatter == nil {
            let _formatter = NSDateFormatter()
            _formatter.locale = NSLocale.currentLocale()
            _formatter.timeZone = NSTimeZone(name: "Asia/Shanghai")
            _formatter.dateStyle = NSDateFormatterStyle.MediumStyle
            _formatter.timeStyle = NSDateFormatterStyle.ShortStyle
            _formatter.dateFormat = format
            
            return _formatter.stringFromDate(date)
        }
        
        return (formatter?.stringFromDate(date))!
    }
    
    class func dateFromString(dateString:String,formatter:NSDateFormatter?,format:String) -> NSDate{
        
        if dateString.isEmpty {
            return NSDate()
        }
        if formatter == nil {
            let _formatter = NSDateFormatter()
            _formatter.locale = NSLocale.currentLocale()
            _formatter.timeZone = NSTimeZone(name: "Asia/Shanghai")
            _formatter.dateStyle = NSDateFormatterStyle.MediumStyle
            _formatter.timeStyle = NSDateFormatterStyle.ShortStyle
            _formatter.dateFormat = format
        }
        
        return (formatter?.dateFromString(dateString))!
    }
    
    class func stringFromDateYMD(date:NSDate) -> String {
        
        return ZHDate.stringFromDate(date, formatter: nil, format: YMDFormat)
    }
    
    class func dateFromStringYMD(dateString:String) -> NSDate {
        
        return ZHDate.dateFromString(dateString, formatter: nil, format: YMDFormat)
    }
    
    class func stringFromDateYMDEHM(date:NSDate) -> String{
        
        return ZHDate.stringFromDate(date, formatter: nil, format: YMDEHMFormat)
    }
    
    class func dateFromStringYMDEHM(dateString:String) -> NSDate {
        
        return ZHDate.dateFromString(dateString, formatter: nil, format: YMDEHMFormat)
    }
    
    class func stringFromDateYMDHMS(date:NSDate) -> String {
        
        return ZHDate.stringFromDate(date, formatter: nil, format: YMDHMSFormat)
    }
    
    class func dateFromStringYMDHMS(dateString:String) -> NSDate {
        
        return ZHDate.dateFromString(dateString, formatter: nil, format: YMDHMSFormat)
    }
    
    class func getYear(date:NSDate) -> String {
        
        let calendar = NSCalendar.currentCalendar()
        let comps = calendar.components(NSCalendarUnit.Year, fromDate: date)
        let year = String(comps.year)
        
        return year
    }
    
    class func getMonth(date:NSDate) -> String {
        
        let calendar = NSCalendar.currentCalendar()
        let comps = calendar.components(NSCalendarUnit.Month, fromDate: date)
        let month = String(comps.month)
        
        return month
    }
    
    class func getDay(date:NSDate) -> String {
        
        let calendar = NSCalendar.currentCalendar()
        let comps = calendar.components(NSCalendarUnit.Day, fromDate: date)
        let day = String(comps.day)
        
        return day
    }


}
