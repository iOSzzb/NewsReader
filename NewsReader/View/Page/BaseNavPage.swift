//
//  BaseNavPage.swift
//  NewsReader
//
//  Created by Harold on 15/8/10.
//  Copyright © 2015年 GetStarted. All rights reserved.
//

import UIKit

class BaseNavPage: BasePage {
    
    var barBackgroundImage:String?
    let NavBarHeight = 44
    let NavBarHeight7 = 64

    override func viewDidLoad() {
        super.viewDidLoad()
        self.barBackgroundImage = "NavigationBar"

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigationBackground()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setNavigationTitleImage(imageName:String) {
        
        let image = UIImage(named: imageName)
        let imageView = UIImageView(image: image)
        self.navigationItem.titleView = imageView
    }

    
    func setNavigationBackground() {
        
        let imageName = self.barBackgroundImage?.stringByAppendingFormat("%d.png", ZHGlobal.isSystemLowerIOS7() ? NavBarHeight:NavBarHeight7)
        let image  = UIImage(named: imageName!)
        self.navigationController?.navigationBar.setBackgroundImage(image, forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
//        print(self.navigationController?.navigationBar.backgroundImageForBarMetrics(UIBarMetrics.Default)?.description)
        print(self.navigationController?.navigationBar.barPosition)
        
        let attributes = [NSForegroundColorAttributeName:UIColor.whiteColor(),NSFontAttributeName:UIFont.systemFontOfSize(18)]
        self.navigationController?.navigationBar.titleTextAttributes = attributes
    }
    
    func setNavBarItem(title:String,selector:Selector,isRight:Bool){
        
        var item : UIBarButtonItem
        if title.hasSuffix("png") {
            item = UIBarButtonItem(image: UIImage(named: title), style: UIBarButtonItemStyle.Plain, target: self, action: selector)
        }else{
            item = UIBarButtonItem(title: title, style: UIBarButtonItemStyle.Plain, target: self, action: selector)
        }
        
        if isRight {
            self.navigationItem.rightBarButtonItem = item
        }else{
            self.navigationItem.leftBarButtonItem = item
        }
    }
    
    @IBAction func doBack(sender:AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
}
