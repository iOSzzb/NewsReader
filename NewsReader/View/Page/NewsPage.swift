//
//  NewsPage.swift
//  NewsReader
//
//  Created by Harold on 15/8/10.
//  Copyright © 2015年 GetStarted. All rights reserved.
//

import UIKit

let newsPageSBId = "NewsPage"

class NewsPage: BaseNavPage ,ColumnBarDelegate ,UICollectionViewDelegate,UICollectionViewDataSource{

    @IBOutlet weak var _barBackView:UIView!
    var _barWidget:ColumnBarWidget?
    @IBOutlet weak var _newsCollectionView:UICollectionView!
    @IBOutlet weak var layout:UICollectionViewFlowLayout!
    private let reuseIdentifier = "Cell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setNavBarItem("NavigationBell.png", selector: nil, isRight: false)
        self.setNavBarItem("NavigationSquare.png", selector: "doRight:", isRight: true)
        self.setNavigationTitleImage("NavBarIcon.png")
        
        self.setStatusBarStyle(UIStatusBarStyle.LightContent)
        
        self.addBarWidget()
        
        self._newsCollectionView.registerClass(ZHNewsCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.setCollectionView()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }

    
    func setCollectionView() {
        
        layout.minimumInteritemSpacing = 0.0
        layout.minimumLineSpacing = 0.0
        layout.itemSize = CGSizeMake(UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height - (self.navigationController?.navigationBar.bounds.height)! - _barBackView.bounds.height - (self.tabBarController?.tabBar.frame.height)! - 20)
        layout.scrollDirection = UICollectionViewScrollDirection.Horizontal
//        layout.itemSize = CGSizeMake(200, 500)
        self._newsCollectionView.pagingEnabled = true
        self._newsCollectionView.backgroundColor = UIColor.grayColor()
        
    }
    
    func addBarWidget() {
        
        _barWidget = UIStoryboard(name: SBName, bundle: nil).instantiateViewControllerWithIdentifier(columnBarWidgetSBId) as? ColumnBarWidget
        _barWidget?.delegate = self
        _barWidget?.view.frame = _barBackView.bounds
        _barBackView.addSubview((_barWidget?.view)!)
        _barBackView.sendSubviewToBack((_barWidget?.view)!)
        
    }
    
    // MARK: ColumnBarDelegate
    
    func didSelect(pageIndex: Int) {
        
        _newsCollectionView.scrollToItemAtIndexPath(NSIndexPath(forRow: pageIndex, inSection: 0), atScrollPosition: UICollectionViewScrollPosition.None, animated: false)
        
    }
    
    // MARK: ZHOperation Delegate
    
    func operationSuccess() {
        self._newsCollectionView.reloadData()
    }
    
    // MARK: collectionViewDataSource
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if _barWidget == nil {
            return 0
        }
        return (_barWidget?.dataList.count)!
    }
    
    
    //MARK: collectionViewDelegate
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! ZHNewsCollectionViewCell
        print(indexPath.row)
        cell.owner = self
        cell.setCellData((_barWidget?.dataList.objectAtIndex(indexPath.row))! as! ColumnInfo)
        
//        let preLoadIndexPath = NSIndexPath(forRow: indexPath.row+1, inSection: indexPath.section)
//        print(preLoadIndexPath.row)
//        let preLoadCell = collectionView.cellForItemAtIndexPath(preLoadIndexPath) as! ZHNewsCollectionViewCell
//        preLoadCell.setCellData((_barWidget?.dataList.objectAtIndex(preLoadIndexPath.row))! as! ColumnInfo)
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        print("will display \(indexPath.row)")
    }
    
    // MARK: scrollView delegate
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        
        let index = self._newsCollectionView.indexPathsForVisibleItems()
        _barWidget?.setPageIndex(index[0].row)
    }
    
    // MARK: Right button aciton
    
    func doRight(sender:UIButton) {
        
        let weatherPage = UIStoryboard(name: SBName, bundle: nil).instantiateViewControllerWithIdentifier(weatherPageSBId)
        weatherPage.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(weatherPage, animated: true)
    }
}
