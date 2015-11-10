//
//  ZHUserDefault.swift
//  NewsReader
//
//  Created by Harold on 15/8/10.
//  Copyright © 2015年 GetStarted. All rights reserved.
//

import Foundation

class ZHUserDefault: NSObject {
    class func getUserDefaultValue(key:String) -> AnyObject?{
        
        let userDef = NSUserDefaults.standardUserDefaults()
        return userDef.objectForKey(key)
    }
    
    class func setUserDefaultValue(value:AnyObject,forKey key:String){
        let userDef = NSUserDefaults.standardUserDefaults()
        userDef.setObject(value, forKey: key)
        userDef.synchronize()
    }
}