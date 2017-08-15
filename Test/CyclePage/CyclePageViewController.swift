//
//  CyclePageViewController.swift
//  Test
//
//  Created by LiGongbo on 2017/8/14.
//  Copyright © 2017年 LiGongbo. All rights reserved.
//

import UIKit

class CyclePageViewController: UIViewController {

    lazy var datas = [["hehe","haha","xixi"],["aa","bb"]]

    lazy var pagerView: TYCyclePagerView = {
        let pagerView = TYCyclePagerView()
        pagerView.isInfiniteLoop = true
        pagerView.autoScrollInterval = 0
        pagerView.frame = CGRect(x: 0, y: 0.01, width: self.view.frame.width, height: self.view.frame.height - 64)
        return pagerView
    }()
    
    lazy var pageControl: TYPageControl = {
        let pageControl = TYPageControl()
        pageControl.currentPageIndicatorSize = CGSize(width: 8, height: 8)
        pageControl.frame = CGRect(x: 0, y: self.view.frame.height - 26 - 64, width: self.pagerView.frame.width, height: 26)
        return pageControl
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        edgesForExtendedLayout = UIRectEdge(rawValue: 0)
        automaticallyAdjustsScrollViewInsets = true
        initUI()
        initData()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
//        pagerView.frame = CGRect(x: 0, y: 0.01, width: self.view.frame.width, height: self.view.frame.height - 64)
//        pageControl.frame = CGRect(x: 0, y: self.view.frame.height - 26 - 64, width: self.pagerView.frame.width, height: 26)
    }
}

extension CyclePageViewController {
    fileprivate func initData() {
        self.pageControl.numberOfPages = self.datas.count
        self.pagerView.reloadData()
    }
    
    fileprivate func initUI() {
        self.addPagerView()
        self.addPageControl()
    }

    func addPagerView() {
        self.pagerView.layer.borderWidth = 1;
        self.pagerView.dataSource = self
        self.pagerView.delegate = self
        self.pagerView.register(UINib(nibName: "CyclePageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CyclePageCollectionViewCellID")
        self.view.addSubview(self.pagerView)
    }
    
    func addPageControl() {
        self.pagerView.addSubview(self.pageControl)
    }

}

extension CyclePageViewController :TYCyclePagerViewDelegate, TYCyclePagerViewDataSource {
    // MARK: TYCyclePagerViewDataSource
    
    func numberOfItems(in pageView: TYCyclePagerView) -> Int {
        return self.datas.count
    }
    
    func pagerView(_ pagerView: TYCyclePagerView, cellForItemAt index: Int) -> UICollectionViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "CyclePageCollectionViewCellID", for: index) as! CyclePageCollectionViewCell
        cell.updata(data: self.datas[index])
        return cell
    }
    
    func layout(for pageView: TYCyclePagerView) -> TYCyclePagerViewLayout {
        let layout = TYCyclePagerViewLayout()
        layout.itemSize = CGSize(width: pagerView.frame.width, height: pagerView.frame.height)
        layout.itemSpacing = 15
        layout.itemHorizontalCenter = true
        return layout
    }
    
    func pagerView(_ pageView: TYCyclePagerView, didScrollFrom fromIndex: Int, to toIndex: Int) {
        self.pageControl.currentPage = toIndex;
    }

}

