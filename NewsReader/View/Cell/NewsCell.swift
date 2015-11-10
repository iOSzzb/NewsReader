//
//  NewsCell.swift
//  NewsReader
//
//  Created by Harold on 15/8/14.
//  Copyright © 2015年 GetStarted. All rights reserved.
//

import UIKit

class NewsCell: UITableViewCell {
    
    @IBOutlet var descLabel:UILabel!
    @IBOutlet var titleLabel:UILabel!
    @IBOutlet var imageIcon:UIImageView!
    var cellInfo:NewsInfo?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    func initCell(){
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "downloadIcon:", name: NotifyNewsIcon, object: nil)
    }
    
    func setCellData(info:NewsInfo){
        
        self.cellInfo = info
        titleLabel.text = info.name as String
        descLabel.numberOfLines = 2
        descLabel.text = info.desc
        
        ZHDownload.download().setNewsIcon(info, imageView: imageIcon)
    }
    

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func downloadIcon(notificaton:NSNotification) {
        
        let dict = notificaton.object
        let info = dict?.objectForKey("info") as! NewsInfo
        
        if info.ID.isEqualToString(self.cellInfo?.ID as! String){
            
            let image = dict?.objectForKey("data") as! UIImage
            imageIcon.image = image
        }
    }

}
