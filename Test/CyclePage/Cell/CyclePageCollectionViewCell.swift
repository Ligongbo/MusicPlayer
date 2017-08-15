//
//  CyclePageCollectionViewCell.swift
//  Test
//
//  Created by LiGongbo on 2017/8/14.
//  Copyright © 2017年 LiGongbo. All rights reserved.
//

import UIKit

class CyclePageCollectionViewCell: UICollectionViewCell {

    lazy var datas = [String]()
    @IBOutlet var tableView: UITableView!
    override func awakeFromNib() {
        super.awakeFromNib()
        initUI()
    }
    
    func updata(data:Array<String>) {
        self.datas = data
        self.tableView.reloadData()
    }

}

extension CyclePageCollectionViewCell {
    func initUI() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
    }
}

extension CyclePageCollectionViewCell: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas.count;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var  cell  = tableView.dequeueReusableCell(withIdentifier: "cellID")
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "cellID")
        }
        
        cell?.textLabel?.text = datas[indexPath.row];
        cell?.backgroundColor = UIColor.clear
        cell?.selectionStyle = .gray
        return cell!
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}
