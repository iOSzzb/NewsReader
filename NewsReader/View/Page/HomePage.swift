//
//  HomePage.swift
//  NewsReader
//
//  Created by Harold on 15/8/10.
//  Copyright © 2015年 GetStarted. All rights reserved.
//

import UIKit

class HomePage: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        addTabControllers()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func addTabControllers(){
        self.tabBar.tintColor = UIColor.redColor()
        self.viewControllers = PageInfo.pageControllers() as? [UIViewController]
    }
    
}
