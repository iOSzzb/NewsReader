//
//  ZHGetImage.swift
//  NewsReader
//
//  Created by Harold on 15/8/10.
//  Copyright © 2015年 GetStarted. All rights reserved.
//

import Foundation
class ZHGetImage: ZHOperation {
    
    override func parseData(data: NSData) {
        _delegate.opSuccessEx!(data, opInfo: _opInfo)
    }
}
