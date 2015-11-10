//
//  ZHGetColumn.swift
//  NewsReader
//
//  Created by Harold on 15/8/11.
//  Copyright © 2015年 GetStarted. All rights reserved.
//

import Foundation
class ZHGetColumn: ZHOperation {
    
    override func parseSuccess(dict: NSDictionary, jsonstring: NSString) {
        
        let infos = ColumnInfo.arrayFormDict(dict)
        _delegate.opSuccess(infos)
    }
}
