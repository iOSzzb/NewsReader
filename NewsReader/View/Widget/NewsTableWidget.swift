//
//  NewsTableWidget.swift
//  NewsReader
//
//  Created by Harold on 15/8/14.
//  Copyright © 2015年 GetStarted. All rights reserved.
//

import Foundation
import UIKit
import CoreData

let newsTableWidgetSBid = "NewsTableWidget"

class NewsTableWidget: BaseWidget ,UITableViewDelegate,UITableViewDataSource{
    
    @IBOutlet weak var tableView:UITableView!
    
    var hasNextPage:Bool?
    var pageIndex:Int!
    var columnInfo:ColumnInfo?
    var cellIndentifier = "NewsCell"
    var moreCellIndentifier = "NewsMoreCell"
    var cellHeight:CGFloat = 80.0
    var owner:UIViewController?
    var refreshControl:UIRefreshControl?
    var refreshTime:NSDate?
    
    override func viewDidLoad() {
        pageIndex = 0
        hasNextPage = false
        self.dataList = NSMutableArray()
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(refreshControl!)
        
        super.viewDidLoad()
    }
    
    override func updateUI() {
        self.tableView.reloadData()
    }
    
    override func reloadData() {
        
        _operation?.cancelOp()
        _operation = nil
        pageIndex = 0
        
        self.dataList.removeAllObjects()
        self.tableView.reloadData()
        super.reloadData()
    }
    
    override func isReloadLocalData() -> Bool {
        let datas = ZHDBManager.fetchNews((self.columnInfo?.ID)! as String)
        if let news = datas {
            self.dataList.addObjectsFromArray(news as [AnyObject])
        }
        return super.isReloadLocalData()
    }
    
    override func requestServer() {
        super.requestServer()
        self.refreshControl?.beginRefreshing()
    }
    
    override func requestServerOp() {
        
        if self.columnInfo == nil {
            return
        }
        
        if let url = self.columnInfo?.url {
            let tenItemsUrl = url.stringByAppendingString("0-9.html")
            let dictInfo = ["url":tenItemsUrl,"body":self.columnInfo?.ID as! String]
            _operation = ZHGetNews(initwithdelegate: self, opInfo: dictInfo)
            _operation?.executeOp()
        }
        
    }
    
    func requestNextPageServerOP(){
        
        if self.columnInfo == nil {
            return
        }
        if let url = self.columnInfo?.url {
            let fromIndex = 10 * pageIndex
            let toIndex = fromIndex + 9
            let appendingString = "\(fromIndex)-\(toIndex).html"
            let nextPageUrl = url.stringByAppendingString(appendingString)
            let dictInfo = ["url":nextPageUrl,"body":self.columnInfo?.ID as! String]
            _operation = ZHGetNews(initwithdelegate: self, opInfo: dictInfo)
            _operation?.executeOp()
        }
    }
    
    func refresh(){
        self.requestServer()
    }
    
    override func opSuccess(data: AnyObject) {
        super.opSuccess(data)
        self.refreshTime = NSDate()
        
        if let time = refreshTime {
            let lastRefreshTime = ZHDate.stringFromDateYMDHMS(time).componentsSeparatedByString(" ")[1]
            self.refreshControl?.attributedTitle = NSAttributedString(string: "上次刷新时间为\(lastRefreshTime)")
        }else {
            self.refreshControl?.attributedTitle = NSAttributedString(string: "你还未刷新过!")
        }
        self.refreshControl?.endRefreshing()
        
        hasNextPage = true
        _operation = nil
        
        if pageIndex == 0 {
            self.dataList.removeAllObjects()
        }
        pageIndex = pageIndex + 1
        
        let array = data as! NSArray
        self.dataList.addObjectsFromArray(array as [AnyObject])
        self.tableView.reloadData()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return hasNextPage == true ? self.dataList.count+1:self.dataList.count
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return indexPath.row < self.dataList.count ? cellHeight:44
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var indentifier = ""
        var info:NewsInfo
//        var cell:UITableViewCell?
        if indexPath.row < self.dataList.count {
            indentifier = self.cellIndentifier
            info = self.dataList.objectAtIndex(indexPath.row) as! NewsInfo
            var cell = tableView.dequeueReusableCellWithIdentifier(indentifier) as? NewsCell
            if cell == nil {
                let objects = NSBundle.mainBundle().loadNibNamed(indentifier, owner: tableView, options: nil)
                cell = objects[0] as? NewsCell
                cell?.initCell()
            }
            
            cell?.setCellData(info)
            return cell!
        }
        else {
            indentifier = moreCellIndentifier
            self.requestNextPageServerOP()
            var cell = tableView.dequeueReusableCellWithIdentifier(indentifier) as? NewsMoreCell
            if cell == nil {
                let objects = NSBundle.mainBundle().loadNibNamed(indentifier, owner: tableView, options: nil)
                cell = objects[0] as? NewsMoreCell
            }
            cell?.indicatorAnimate()
            return cell!
        }
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let detailVC = UIStoryboard(name: SBName, bundle: nil).instantiateViewControllerWithIdentifier(detailPageSBId) as! DetailPage
        detailVC.newsInfo = self.dataList.objectAtIndex(indexPath.row) as! NewsInfo
        detailVC.hidesBottomBarWhenPushed = true
        self.owner?.navigationController?.pushViewController(detailVC, animated: true)
    }
}