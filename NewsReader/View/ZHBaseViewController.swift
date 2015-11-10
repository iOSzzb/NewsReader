//
//  ZHBaseViewController.swift
//  NewsReader
//
//  Created by Harold on 15/8/7.
//  Copyright © 2015年 GetStarted. All rights reserved.
//

import UIKit

class ZHBaseViewController: UIViewController ,ZHOperationDelegate{
    
    var _operation:ZHOperation?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    
    func opFail(errorMessage: NSString) {

        self.clearAllNotice()
        self.noticeOnlyText(errorMessage as String)
        NSTimer.scheduledTimerWithTimeInterval(3, target: self, selector: "clearAllNotice", userInfo: nil, repeats: false)
    }
    
    func opSuccess(data: AnyObject) {
        self.clearAllNotice()
    }
    
    func setStatusBarStyle(style:UIStatusBarStyle) {
        
        UIApplication.sharedApplication().setStatusBarStyle(style, animated: true)
    }
    
}
