//
//  ZHLandscapeTableView.swift
//  NewsReader
//
//  Created by Harold on 15/8/12.
//  Copyright © 2015年 GetStarted. All rights reserved.
//

import Foundation
import UIKit

protocol ZHLandscapeTableViewDataSource {
    
    func numberOfCellsInTableView(tableView:ZHLandscapeTableView) -> Int
    func cellInTabelView(tableView:ZHLandscapeTableView,atIndex index:Int) -> ZHLandscapeCell
}

@objc protocol ZHLandscapeTableViewDelegate:NSObjectProtocol {
    
    optional func tableView(tableView:ZHLandscapeTableView,didChangeAtIndex index:Int)
    optional func tableView(tableView:ZHLandscapeTableView,didSelectCellAtIndex index:Int)
    optional func tableViewWillBeginMoving(tableView:ZHLandscapeTableView)
    optional func tableViewDidEndMoving(tableView:ZHLandscapeTableView)
}

class ZHLandscapeTableView: UIView,UIScrollViewDelegate {
    
    //存储页面的滚动条容器
    var _scrollView:UIScrollView!
    //单元格之间的间隔
    var _gapBetweenCells:CGFloat!
    //预先健在的单元格数，在可见单元格的两边预先加载不可见的单元格的数目
    var _cellsToPreLoad:Int?
    //单元格总数
    var _cellCount:Int?
    //当前索引
    var _currentCellIndex:Int?
    //上次选择的单元格索引
    var _lastCellIndex:Int?
    //加载当前可见单元格左边的索引
    var _firstLoadedCellIndex:Int?
    //加载当前可见单元格右边的索引
    var _lastLoadedCellIndex:Int?
    //可见单元格控件的集合
    var _visibleCells:NSMutableSet?
    //可重用单元格控件的集合
    var _recycledCells:NSMutableSet?
    
    //是否正在旋转
    var _isRotationing:Bool?
    //页面容器是否正在滑动
    var _scrollViewIsMoving:Bool?
    //回收站是否可用，是否将不用的页面控件保存到_recycledCells集合中
    var _recyclingEnabled:Bool?
    
    var dataSource:ZHLandscapeTableViewDataSource
    var delegate:ZHLandscapeTableViewDelegate
    
    func addContentView() {
        _scrollView = UIScrollView(frame: self.frameForScrollView())
        
        _scrollView.autoresizingMask = [UIViewAutoresizing.FlexibleWidth,UIViewAutoresizing.FlexibleHeight]//这是swift2.0的改变，取代以前用“|”连接
        _scrollView.pagingEnabled = true
        _scrollView.backgroundColor = UIColor.whiteColor()
        _scrollView.showsVerticalScrollIndicator = false
        _scrollView.showsHorizontalScrollIndicator = false
        _scrollView.bounces = true
        _scrollView.delegate = self
        
        self.addSubview(_scrollView)
    }
    
    func internalInit() {
        
        _visibleCells = NSMutableSet()
        _recycledCells = NSMutableSet()
        
        _currentCellIndex = -1
        _lastCellIndex = 0
        _gapBetweenCells = 20.0
        _cellsToPreLoad = 1
        _recyclingEnabled = true
        _firstLoadedCellIndex = 1
        _lastLoadedCellIndex = 1
        
        self.clipsToBounds = true
        self.addContentView()
    }
    
//    required init(coder aDecoder: NSCoder) {
//        if self == super.init(coder: aDecoder) {
//            self.internalInit()
//        }
//        return self
//    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.internalInit()
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        if _isRotationing == true {
            return
        }
        
        let oldFrame = _scrollView.frame
        let newFrame = self.frameForScrollView()
        if !CGRectEqualToRect(oldFrame, newFrame) {
            _scrollView.frame = newFrame
        }
        
        if oldFrame.size.width != 0 && _scrollView.frame.size.width != oldFrame.size.width {
            
        } else if oldFrame.size.height != _scrollView.frame.size.height {
            self.configureCells()
        }
    }
    
    
    
    func setGapBetweenCells(value:CGFloat) {
        _gapBetweenCells = value
        self.setNeedsLayout()//标记为需要需要刷新
    }
    
    func setPagesToPreload(value:Int) {
        _cellsToPreLoad = value
        self.configureCells()
    }
    
    func setCurrentCellIndex(newCellIndex:Int) {
        if _scrollView.frame.size.width > 0 && fabs(_scrollView.frame.origin.x - (-_gapBetweenCells/2)) < 1e-6 {
            _scrollView.contentOffset = CGPointMake(_scrollView.frame.size.width * CGFloat(newCellIndex), 0)
        }
        
        _currentCellIndex = newCellIndex
        _lastCellIndex = _currentCellIndex
    }
    
    func firstVisibleCellIndex() -> Int {
        let visibleBounds = _scrollView.bounds
        let fValue = floorf(Float(CGRectGetMinX(visibleBounds) / CGRectGetWidth(visibleBounds)))
        
        return Int(max(fValue, 0))
    }
    
    func lastVisibleCellIndex() -> Int {
        let visibleBounds = _scrollView.bounds
        let fValue = floorf(Float( (CGRectGetMaxX(visibleBounds) - 1) / CGRectGetWidth(visibleBounds)))
        
        return min(Int(fValue), _cellCount! - 1)
    }
    
    
    func reloadData() {
        _cellCount = dataSource.numberOfCellsInTableView(self)
        
        if let vCells = _visibleCells {
            
            for cell in vCells {
                self.recycleCell(cell as! ZHLandscapeCell)
            }
        }
        
        _visibleCells?.removeAllObjects()
        self.configureCells()
    }
    
    func cellForIndex(index:Int) -> ZHLandscapeCell? {
        
        if let vCells = _visibleCells {
            
            for cell in vCells {
                if cell.tag == index {
                    return cell as? ZHLandscapeCell
                }
            }
        }
        
        return nil
    }
    
    func dequeueReusableCell() -> ZHLandscapeCell? {
        
        let result = _recycledCells?.anyObject() as? ZHLandscapeCell
        if (result != nil) {
            _recycledCells?.removeObject(result!)
        }
        
        return result!
    }
    
    
    func configureCells() {
        
        if _scrollView.frame.size.width <= _gapBetweenCells + 1e-6 {
            return
        }
        if _cellCount == 0 && _currentCellIndex > 0 {
            return
        }
        if _isRotationing == true {
            return
        }
        
        let quickMode = (_scrollViewIsMoving == true && _cellsToPreLoad > 0 )
        
        let contentSize = CGSizeMake(_scrollView.frame.width * CGFloat(_cellCount!) + 2, _scrollView.frame.size.height)
        
        if !CGSizeEqualToSize(_scrollView.contentSize, contentSize) {
            
            _scrollView.contentSize = contentSize
            _scrollView.contentOffset = CGPointMake(_scrollView.frame.size.width * CGFloat(_currentCellIndex!), 0)
            
        }
        
        let visibleBounds = _scrollView.bounds
        var newCellIndex = min(Int(max(floor(CGRectGetMidX(visibleBounds) / CGRectGetWidth(visibleBounds)), 0)), _cellCount! - 1)
        newCellIndex = max(0, min(_cellCount!, newCellIndex))
        
        let firstVisibleCell = self.firstVisibleCellIndex()
        let lastVisibleCell = self.lastVisibleCellIndex()
        
        let firstCell = max(0, min(firstVisibleCell, newCellIndex))
        let lastCell = min(_cellCount!-1, max(lastVisibleCell, newCellIndex + _cellsToPreLoad!))
        
        var cellsToRemove = NSMutableSet()
        if let vCells = _visibleCells {
            for cell in vCells {
                if (cell as! ZHLandscapeCell).tag < firstCell || (cell as! ZHLandscapeCell).tag > lastCell {
                    self.recycleCell(cell as! ZHLandscapeCell)
                    cellsToRemove.addObject(cell)
                }
            }
        }
        _visibleCells?.minusSet(cellsToRemove as Set<NSObject>)
        
        for var index = firstCell; index <= lastCell; index++ {
            
            if self.cellForIndex(index) != nil {
                if quickMode && (index < firstVisibleCell || index > lastVisibleCell){
                    continue
                }
                let cell = dataSource.cellInTabelView(self, atIndex: index)
                self.configureCell(cell, forIndex: index)
                _scrollView.addSubview(cell)
                _visibleCells?.addObject(cell)
            }
        }
        
        var loadedCellsChanged = false
        if (quickMode) {
            
        } else {
            loadedCellsChanged = _firstLoadedCellIndex != firstCell || _lastLoadedCellIndex != lastCell
            if loadedCellsChanged {
                _firstLoadedCellIndex = firstCell
                _lastLoadedCellIndex = lastCell
            }
        }
        
        let cellIndexChanged = newCellIndex != _currentCellIndex
        if cellIndexChanged {
            
            _lastCellIndex = _currentCellIndex
            _currentCellIndex = newCellIndex
            
            if delegate.respondsToSelector("tableView:didChangeAtIndex") {
                delegate.tableView!(self, didChangeAtIndex: _currentCellIndex!)
            }
            
        }
        
    }
    
    func configureCell(cell:ZHLandscapeCell,forIndex index:Int) {
        
        cell.tag = index
        cell.frame = self.frameForCellAtIndex(index)
        
        cell.setNeedsDisplay()
    }
    
    func recycleCell(cell:ZHLandscapeCell) {
        
        if cell.respondsToSelector("prepareForReuse") {
            
            cell.perfom
        }
        
    }
    
    func frameForScrollView() ->CGRect {
        
    }
    
    func frameForCellAtIndex(index:Int) -> CGRect {
        
    }
    
}