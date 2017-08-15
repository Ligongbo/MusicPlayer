//
//  MusicListView.swift
//  Test
//
//  Created by LiGongbo on 2017/8/8.
//  Copyright © 2017年 LiGongbo. All rights reserved.
//

import UIKit
typealias MusicListViewSelectBlock = ( _ info:SCXMusicModel, _ index:Int) -> Void

class MusicListView: UIView {

    var selectedIndex:Int = -1
    var touchToHide = true
    var list:Array<SCXMusicModel> = [SCXMusicModel]()
    var overlayView:DropListCoverView!
    var tableView:UITableView!
    var didSelectBlock:MusicListViewSelectBlock?
    var blackCoverView:UIView?
    var tableViewFrame = CGRect(x: 0, y: 0, width: ScreenWidth, height: 0)
    var tableViewOriginY:CGFloat = 0
    var buttonView:UIView?
    
    override init(frame: CGRect) {
        super.init(frame: UIApplication.shared.keyWindow!.bounds)
        self.backgroundColor = UIColor.clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func show(){
        
        let view = UIApplication.shared.keyWindow!
        overlayView = DropListCoverView(frame: view.bounds)
        overlayView!.musicListView = self
        overlayView!.addSubview(self)
        
        let titleFrame = buttonView!.convert(buttonView!.bounds, to: view)
        let tableViewHeight = CGFloat(44 * list.count) >= titleFrame.origin.y - 100 ? tableViewOriginY - 100 : CGFloat(44 * list.count)

        tableViewOriginY =  titleFrame.origin.y - tableViewHeight
        tableViewFrame = CGRect(x: 0, y: tableViewOriginY, width: ScreenWidth, height: 0)
        
        blackCoverView = UIView(frame: CGRect(x: 0, y: tableViewOriginY, width: ScreenWidth, height: ScreenHeight - tableViewOriginY))
        blackCoverView?.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        self.addSubview(blackCoverView!)
        let tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismiss))
        blackCoverView?.addGestureRecognizer(tap)
        
        tableView = UITableView(frame: tableViewFrame, style: .plain)
        tableView.backgroundColor = UIColor.clear
        tableView.dataSource = self
        tableView.delegate = self
        tableView.reloadData()
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none

        registTableViewCell("MusicListTableViewCell")
        
        self.addSubview(tableView)
        
        view.addSubview(overlayView!)
        
        UIView.animate(withDuration: 0.3) {
            self.tableView.frame = CGRect(x: 0, y: self.tableViewOriginY, width: ScreenWidth, height: tableViewHeight)
        }
    }
    
    fileprivate func registTableViewCell(_ cellNibName:String){
        let cellNib: UINib = UINib(nibName: cellNibName, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: cellNibName + "Id")
    }
    
    func show(selectView:UIView, completionBlock:MusicListViewSelectBlock?){
        self.buttonView = selectView
        self.didSelectBlock = completionBlock
        show()
    }
    
    func dismiss(){
        UIView.animate(withDuration: 0.3, animations: {
            self.tableView.frame = CGRect(x: 0, y: self.tableViewOriginY, width: ScreenWidth, height: 0)
        }) { (isOK) in
            if isOK{
                self.removeFromSuperview()
                if self.overlayView != nil{
                    self.overlayView!.removeFromSuperview()
                }
            }
        }
        
    }
}

extension MusicListView: UITableViewDataSource, UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = MusicListTableViewCell.loadCell(tableView)
        cell.update(model:list[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        didSelectBlock?(list[indexPath.row],indexPath.row)
        dismiss()
    }
}


