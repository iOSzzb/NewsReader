//
//  NewsMoreCell.swift
//  NewsReader
//
//  Created by Harold on 15/8/19.
//  Copyright © 2015年 GetStarted. All rights reserved.
//

import UIKit

class NewsMoreCell: UITableViewCell {

    @IBOutlet var indicator:UIActivityIndicatorView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func indicatorAnimate(){
        self.indicator.startAnimating()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
