//
//  ZHButtonHelper.swift
//  NewsReader
//
//  Created by Harold on 15/8/11.
//  Copyright © 2015年 GetStarted. All rights reserved.
//

import Foundation
import UIKit
class ZHButtonHelper: NSObject {
    var button:UIButton!
    var normalColor:UIColor!
    var selectedColor:UIColor!
    
    func setButton(btn:UIButton,normalColor nColor:UIColor,seletedColor sColor:UIColor) {
        
        self.button = btn
        self.normalColor = nColor
        self.selectedColor = sColor
        
//        self.button.setTitleColor(nColor, forState: UIControlState.Normal)
//        self.button.setTitleColor(sColor, forState: UIControlState.Highlighted)
        
        self.setSelected(false)
        self.setSelected(true)
    }
    
    func setSelected(selected:Bool) {
        
        let color = selected ? self.selectedColor:self.normalColor
        self.button.setTitleColor(color, forState: UIControlState.Normal)
        self.button.setTitleColor(color, forState: UIControlState.Highlighted)
    }
}