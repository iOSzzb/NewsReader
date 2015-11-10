//
//  DetailPage.swift
//  NewsReader
//
//  Created by Harold on 15/8/17.
//  Copyright © 2015年 GetStarted. All rights reserved.
//

import Foundation
import UIKit

let detailPageSBId = "DetailPage"

class DetailPage: BaseNavPage ,UIWebViewDelegate{
    
    @IBOutlet weak var webView:UIWebView!
    var newsInfo:NewsInfo!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.barBackgroundImage = "NavBarWhite"
        self.loadHtml()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavBarItem("NavigationBackBlack.png", selector: "doBack:", isRight:false )
        self.navigationController?.navigationBar.tintColor = UIColor.blackColor()
        self.setStatusBarStyle(UIStatusBarStyle.Default)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        _operation?.cancelOp()
        _operation = nil
        self.clearAllNotice()
    }
    
    func loadHtml() {
        
        self.pleaseWait()
        
        self.executeContentOp()
    }
    
    func executeContentOp() {
        
        let url = NSString(format: DetailURLFmt, newsInfo.ID)
        let dictInfo = ["url":url,"aid":newsInfo.ID]
        _operation = ZHGetContent(initwithdelegate: self, opInfo: dictInfo)
        _operation?.executeOp()
    }
    
    override func opSuccess(data: AnyObject) {
        
        _operation = nil
        
        let urlString = NSBundle.mainBundle().pathForResource("content_template2", ofType: "html")
        let htmlString = self.htmlConvert(data as! ContentInfo)
        webView.loadHTMLString(htmlString, baseURL: NSURL(string: urlString!))
    }
    
    
    func htmlConvert(info:ContentInfo) -> String {
        
        let file = NSBundle.mainBundle().pathForResource("content_template2", ofType: "html")
        var html:String = ""
        do {
            html =  try NSString(contentsOfFile: file!, encoding: NSUTF8StringEncoding) as String
        }
        catch {
            print(error)
        }
        if let body = info.body {
            html = html.stringByReplacingOccurrencesOfString(HtmlBody, withString: body)
        }
        
        if let title = info.title {
            html = html.stringByReplacingOccurrencesOfString(HtmlTitle, withString: title)
        }
        
        if let source = info.source {
            html = html.stringByReplacingOccurrencesOfString(HtmlSource, withString: source)
        }
        
        if let ptime = info.ptime {
            html = html.stringByReplacingOccurrencesOfString(HtmlPTime, withString: ptime)
        }
        
        if let digest = info.digest {
            html = html.stringByReplacingOccurrencesOfString(HtmlDigest, withString: digest)
        }
        
        if let sourceurl = info.sourceurl {
            html = html.stringByReplacingOccurrencesOfString(HtmlSourceURL, withString: sourceurl)
        }
        
        if let ec = info.ec {
            html = html.stringByReplacingOccurrencesOfString(HtmlEc, withString: ec)
        }
        
        if info.images?.count > 0 {
            
            if let imags = info.images {
                
                for imageInfo in imags {
                    let info = imageInfo as! ContentImageInfo
                    let img = NSString(format: HtmlImage, info.src!)
                    html = html.stringByReplacingOccurrencesOfString(info.ref!, withString: img as String)
                }
            }
        }
        
        return html
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        self.clearAllNotice()
    }
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        return true
    }
    
}