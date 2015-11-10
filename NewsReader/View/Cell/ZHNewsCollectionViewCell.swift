//
//  ZHNewsCollectionViewCell.swift
//  NewsReader
//
//  Created by Harold on 15/8/13.
//  Copyright © 2015年 GetStarted. All rights reserved.
//

import UIKit

class ZHNewsCollectionViewCell: UICollectionViewCell {
    
    var newsWidget:NewsTableWidget?
    var owner:UIViewController?
    func setCellData(columnInfo:ColumnInfo)
    {
        if newsWidget == nil {
            self.newsWidget = UIStoryboard(name: SBName, bundle: nil).instantiateViewControllerWithIdentifier(newsTableWidgetSBid) as? NewsTableWidget
            self.newsWidget!.columnInfo = columnInfo
            if let ownerView = self.owner as? NewsPage {
                
                self.newsWidget!.view.frame = CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height - (ownerView.navigationController?.navigationBar.bounds.height)! - ownerView._barBackView.bounds.height - (ownerView.tabBarController?.tabBar.frame.height)! - 20)
            }
            
            self.newsWidget?.owner = self.owner
            
            self.addSubview(newsWidget!.view)
        } else {
            self.newsWidget!.columnInfo = columnInfo
            newsWidget?.reloadData()
        }
        
    }

}
