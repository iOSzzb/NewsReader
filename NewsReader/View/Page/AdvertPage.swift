//
//  AdvertPage.swift
//  NewsReader
//
//  Created by Harold on 15/8/7.
//  Copyright © 2015年 GetStarted. All rights reserved.
//

import UIKit
import Foundation
let AdvertPageSBId = "AdvertPage"
class AdvertPage: BasePage {
    
    @IBOutlet weak var _imageView:UIImageView!
    
    class func canShowAdverPage() -> Bool {
        let dateString = ZHUserDefault.getUserDefaultValue(AdvertKey) as! String
        let date = ZHDate.dateFromStringYMDHMS(dateString)
        let interval = NSDate().timeIntervalSinceDate(date)
        //超过AdvertCheckTime 才显示广告
        if interval < AdvertCheckTime {
            return false
        }
        return true
    }
    
    class func showAdvertPage(){
        
        ZHUserDefault.setUserDefaultValue(ZHDate.stringFromDateYMDHMS(NSDate()), forKey: AdvertKey)
        let controller = UIStoryboard(name: SBName, bundle: nil).instantiateViewControllerWithIdentifier(AdvertPageSBId)
        let window = AppDelegate.appDelegate().window
        if (window?.rootViewController != nil) {
            let frame = window?.rootViewController?.view.bounds
            controller.view.frame = frame!
            window?.rootViewController?.view.addSubview(controller.view)
        }else{
            window?.rootViewController = controller
            window?.makeKeyAndVisible()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getAdvertImage()
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.sharedApplication().setStatusBarHidden(true, withAnimation: UIStatusBarAnimation.None)
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.sharedApplication().setStatusBarHidden(false, withAnimation: UIStatusBarAnimation.None)
    }
    
    func getAdvertImage(){
        // 本地已存在，取本地图片
        if self.checkLanchExist() {
            return
        }
        self.getAdvertOp()
    }
    
    func getAdvertOp(){
        
        let size = UIScreen.mainScreen().bounds.size
        let url = NSString(format: AdvertURL, Int(size.width),Int(size.height))
        let dictInfo:NSDictionary = ["url":url]
        _operation = ZHOperation(initwithdelegate: self, opInfo: dictInfo)
        _operation?.executeOp()
    }
    
    func getLaunchImageOp(url:NSString){
        
        let dictInfo:NSDictionary = ["url":url]
        
        _operation = ZHGetImage(initwithdelegate:self,opInfo:dictInfo)
        _operation?.executeOp()
    }
    
    func checkLanchExist()->Bool{
        let fileName = ZHDate.stringFromDateYMD(NSDate())
        let filePath = ZHGlobal.getCacheImage(fileName)
        
        if ZHFileUtility.isFieleExist(filePath) {
            _imageView.image = UIImage(contentsOfFile: filePath)
            self.delayHideAdvert()
            return true
        }
        return false
    }
    
    func delayHideAdvert(){
        NSTimer.scheduledTimerWithTimeInterval(AdverDelayTime, target: self, selector: "hideLanch", userInfo: nil, repeats: false)
    }
    
    func hideLanch(){
        if self.view.superview != AppDelegate.appDelegate().window {
            self.view.removeFromSuperview()
        }else{
            AppDelegate.appDelegate().showHomePage()
        }
    }
    
    func setLaunchImage(data:NSData){
        
        let fileName = ZHDate.stringFromDateYMD(NSDate())
        let image = UIImage(data: data)
        
        if image != nil {
            _imageView.image = image
            data.writeToFile(ZHGlobal.getCacheImage(fileName), atomically: true)
        }
    }
    
    //MARK ZHOperationDelegate
    override func opSuccess(data: AnyObject) {
        let dictData = (data as? NSDictionary)?.objectForKey(NetData)
        let url = dictData?.objectForKey("imageurl") as! String
        self.getLaunchImageOp(url)
    }
    
    func opSuccessEx(data: AnyObject, opInfo: NSDictionary) {
        self.setLaunchImage(data as! NSData)
        self.delayHideAdvert()
    }
    
    override func opFail(errorMessage: NSString) {
        super.opFail(errorMessage)
        AppDelegate.appDelegate().showHomePage()
    }
    

}
