//
//  ColumnBarWidget.swift
//  NewsReader
//
//  Created by Harold on 15/8/11.
//  Copyright © 2015年 GetStarted. All rights reserved.
//

import Foundation
import UIKit

protocol ColumnBarDelegate{
    
    func didSelect(pageIndex:Int)
    func operationSuccess()
}

let columnBarWidgetSBId = "ColumnBarWidget"

class ColumnBarWidget: BaseWidget  {
    @IBOutlet weak var _scrollView:UIScrollView!
    var _pageIndex:Int!
    var delegate:ColumnBarDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataList = NSMutableArray()
        self.getColumnInfoFromPlist()
        self.updateUI()
//        self.requestServer()
    }
    
    override func isReloadLocalData() -> Bool {
//        let datas = 
        return super.isReloadLocalData()
    }
    
    override func requestServer() {
        self.requestServerOp()
    }
    
    override func requestServerOp() {
        let dictInfo = ["url":ColumnURL,"body":"1"]
        
        _operation = ZHGetColumn(initwithdelegate: self, opInfo: dictInfo)
        _operation?.executeOp()
    }
    
    override func opSuccess(data: AnyObject) {
        super.opSuccess(data)
        self.dataList = data as! NSMutableArray
        self.updateUI()
        self.delegate.operationSuccess()
    }
    
    
    override func updateUI() {
        
        self.addColumnBar()
        self._pageIndex = 0
        self.setPageIndex(self._pageIndex)
    }
    
    func addColumnBar() {
        
        for view in _scrollView.subviews {
            view.removeFromSuperview()
        }
        
        var index = 0
        var origin_x:CGFloat = 0.0
        let insets:CGFloat = 18.0
        let buttonInsets = UIEdgeInsetsMake(0.0, insets, 0.0, insets)
        var titleSize = CGSizeZero
        var button:UIButton
        var info:ColumnInfo
        
        _scrollView.contentInset = buttonInsets
        
        for index = 0; index < self.dataList.count; index++ {
            
            info = self.dataList.objectAtIndex(index) as! ColumnInfo
            
            button = UIButton(type: UIButtonType.Custom)
            button.tag = index+1
            button.addTarget(self, action: "buttonClicked:", forControlEvents: UIControlEvents.TouchUpInside)
            button.setTitle(info.name as String, forState: UIControlState.Normal)
            button.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
            let attributes = [NSFontAttributeName:button.titleLabel!.font]
            titleSize = info.name.sizeWithAttributes(attributes)
            button.frame = CGRectMake(origin_x, 0.0, titleSize.width+20, 36)
            origin_x += titleSize.width + 3.0 + 20.0
            _scrollView.addSubview(button)
            
        }
        
        _scrollView.contentSize = CGSizeMake(origin_x, 36)
    }
    
    func buttonClicked(sender:UIButton) {
        
        //设置上一次按键的字体颜色
        let lastClickedBtn = _scrollView.viewWithTag(_pageIndex + 1) as! UIButton
        lastClickedBtn.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        lastClickedBtn.setTitleColor(UIColor.blackColor(), forState: UIControlState.Highlighted)
        
        _pageIndex = sender.tag - 1
        self.setColumnTabCenter(sender.frame)
        
        //设置当前按键的字体颜色
        sender.setTitleColor(UIColor.redColor(), forState: UIControlState.Normal)
        sender.setTitleColor(UIColor.redColor(), forState: UIControlState.Highlighted)
        
        self.delegate.didSelect(_pageIndex)
    }
    
    func setPageIndex(pageIndex:Int) {
        
        let sender = _scrollView.subviews[pageIndex] as! UIButton
        self.buttonClicked(sender)
        
    }
    
    func setColumnTabCenter(frame:CGRect) {
        
//        var xOffer = frame.origin.x - _scrollView.contentOffset.x - self.view.bounds.width/2
//        xOffer = _scrollView.contentOffset.x + xOffer + frame.size.width/2
        var xOffer = frame.origin.x - self.view.bounds.width/2 + frame.size.width/2
        
        if xOffer < 18 {
            xOffer = -18
        }else if xOffer + self.view.bounds.width > _scrollView.contentSize.width {
            xOffer = _scrollView.contentSize.width - self.view.bounds.width + 18
        }
        if xOffer <= 0 {
            xOffer = -18
        }
        _scrollView.setContentOffset(CGPointMake(xOffer, 0), animated: true)
    }
    
    func getColumnInfoFromPlist() {
        
        let configFile = NSBundle.mainBundle().pathForResource("ColumnBarInfo", ofType: "plist")
        if let file = configFile {
            let columnConfigs = NSArray(contentsOfFile: file)
            if let array = columnConfigs {
                let infos = ColumnInfo.arrayFromArray(array)
                self.dataList = NSMutableArray(array: infos)
            }
        }else {
            print("似乎没有配置ColumnBarInfo.plist")
        }
    
    }
}