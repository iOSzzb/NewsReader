//
//  BaseWidget.swift
//  NewsReader
//
//  Created by Harold on 15/8/11.
//  Copyright © 2015年 GetStarted. All rights reserved.
//

import Foundation

class BaseWidget: ZHBaseViewController {
    var dataList:NSMutableArray!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.reloadData()
    }
    
    func updateUI() {
    }
    
    func reloadData() {
        
        if !self.isReloadLocalData() {
            self.requestServer()
        }else{
            self.requestServerOp()
            self.updateUI()
        }
    }
    
    func isReloadLocalData() -> Bool {
        
        let isReload = self.dataList?.count > 0
        if isReload {
            self.updateUI()
        }
        return isReload
    }
    
    func requestServer() {
        self.requestServerOp()
    }
    
    func requestServerOp() {
        
    }
}