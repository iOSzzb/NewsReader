//
//  ViewController.swift
//  NewsReader
//
//  Created by Harold on 15/8/6.
//  Copyright © 2015年 GetStarted. All rights reserved.
//

import UIKit

class ViewController: UIViewController,ZHOperationDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
//         Do any additional setup after loading the view, typically from a nib.
        let opInfo:NSDictionary = ["url":LoginURL,"body":"1"]
        let op = ZHOperation(initwithdelegate: self, opInfo: opInfo)
        op.executeOp()
//        self.pleaseWait()
//        NSTimer.scheduledTimerWithTimeInterval(3, target: self, selector: "xx", userInfo: nil, repeats: false)
        
//        print(ZHGlobal.getCacheImage("xx"))
        let size = UIScreen.mainScreen().bounds.size
        print(size)
        
        let url = NSString(format: AdvertURL, Int(size.width),Int(size.height))
        print(url)
    }
    
    func xx(){
        print("3s")
    }
    
    func test(isTrue:Bool) -> Bool {
        if isTrue {
            return true
        }
        return false
    }

    func opSuccess(data: AnyObject) {
        print("成功了\(data)")
        self.successNotice("成功")
    }
    func opFail(errorMessage: NSString) {
        print("失败了\(errorMessage)")
//        self.pleaseWait()
//        self.noticeError(errorMessage as String, autoClear: true, autoClearTime: 3)
        self.noticeOnlyText(errorMessage as String)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

