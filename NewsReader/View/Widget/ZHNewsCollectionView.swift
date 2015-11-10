//
//  ZHNewCollectionView.swift
//  NewsReader
//
//  Created by Harold on 15/8/13.
//  Copyright © 2015年 GetStarted. All rights reserved.
//

import UIKit

protocol ZHNewsColletionViewDelegate {
    func didMoveToPage(atPageIndex index:Int)
}

private let reuseIdentifier = "Cell"

class ZHNewsCollectionView: UICollectionViewController {
    
//    @IBOutlet var layout:UICollectionViewFlowLayout!
    
    var delegate:ZHNewsColletionViewDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.redColor()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.registerClass(ZHNewsCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
//        self.collectionView?.registerNib(UINib(nibName: "ZHNewsCollectionViewCell", bundle: NSBundle.mainBundle()), forCellWithReuseIdentifier: reuseIdentifier)
    
        self.collectionView?.backgroundColor = UIColor.grayColor()
        self.setUpCollectionView()
        self.collectionView?.pagingEnabled = true

        // Do any additional setup after loading the view.
    }
    
    func setUpCollectionView(){
        
//        self.layout = UICollectionViewFlowLayout()
//        self.layout.minimumInteritemSpacing = 0.0
//        self.layout.minimumLineSpacing = 0.0
//        self.layout.itemSize = self.view.bounds.size
//        self.layout.scrollDirection = UICollectionViewScrollDirection.Horizontal
//        self.collectionView?.setCollectionViewLayout(self.layout, animated: true)
        self.collectionView?.scrollEnabled = true
        self.collectionView?.showsHorizontalScrollIndicator = true
        self.collectionView?.showsVerticalScrollIndicator = true
    
        

    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 5
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! ZHNewsCollectionViewCell
//        if cell == nil {
//            let array = NSBundle.mainBundle().loadNibNamed("ZHNewsCollectionViewCell", owner: self, options: nil)
//            cell =  array[0] as? ZHNewsCollectionViewCell
//        }
        
        cell.pageIndex = indexPath.row
        
        if indexPath.row%2 == 1 {
            cell.backgroundColor = UIColor.greenColor()
        }else{
            cell.backgroundColor = UIColor.blueColor()
        }
        
        return cell
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
    */
    
    
    override func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        
        let index = self.collectionView?.indexPathsForVisibleItems()
        delegate?.didMoveToPage(atPageIndex: index![0].row)
    }
    

}
