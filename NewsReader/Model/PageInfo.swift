//
//  PageInfo.swift
//  NewsReader
//
//  Created by Harold on 15/8/10.
//  Copyright © 2015年 GetStarted. All rights reserved.
//

import Foundation
import UIKit

class PageInfo: BaseInfo {
    
    var image:NSString
    var selectImage:NSString
    var unLoad:Bool?
    
    override init(infoFromDict dict: NSDictionary) {
        
        image = dict.objectForKey("Image") as! NSString
        selectImage = dict.objectForKey("SelectImage") as! NSString
        unLoad = dict.objectForKey("Unload") as? Bool
        
        super.init()
        
        ID = dict.objectForKey("ClassName") as! NSString
        name = dict.objectForKey("Title") as! NSString
        
    }
    
    class func pages() -> NSArray {
        
        let configFile = NSBundle.mainBundle().pathForResource("TabBarPages", ofType: "plist")
        let pageConfigs = NSArray(contentsOfFile: configFile!)
        let pages = NSMutableArray()
        if pageConfigs?.count <= 0 {
            print("似乎没有配置TabBarPages.plist")
        }
        
        if let configs = pageConfigs {

            for dict in configs {
                pages.addObject(PageInfo(infoFromDict: dict as! NSDictionary))
            }
        }
        
        return pages
    }
    
    class func pageControllers() -> NSArray {
        
        let controllers = NSMutableArray()
        let pages = PageInfo.pages()
        var pageController = UIViewController()
        var navPage = UINavigationController()
        
        for pageInfo in pages {
            
            if let unload = (pageInfo as! PageInfo).unLoad {
                if unload {
                    continue
                }
                
            }
            
            switch (pageInfo as! PageInfo).ID {
                case "NewsPage":
                pageController = UIStoryboard(name: SBName, bundle: nil).instantiateViewControllerWithIdentifier(newsPageSBId)
                case "ReaderPage":
                pageController = ReaderPage()
                case "VoicePage":
                pageController = VoicePage()
                case "MyPage":
                pageController = MyPage()
            default:
                pageController = UIViewController()
            }
            
            navPage = UINavigationController(rootViewController: pageController)
            pageController.title = (pageInfo as! PageInfo).name as String
            pageController.tabBarItem.image = UIImage(named: (pageInfo as! PageInfo).image as String)
            
            controllers.addObject(navPage)
        }
        return controllers
    }
}
