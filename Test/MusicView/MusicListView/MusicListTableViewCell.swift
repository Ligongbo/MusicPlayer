//
//  MusicListTableViewCell.swift
//  Test
//
//  Created by LiGongbo on 2017/8/8.
//  Copyright © 2017年 LiGongbo. All rights reserved.
//

import UIKit

class MusicListTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func update(model:SCXMusicModel){
        self.textLabel?.text = model.name
    }
    
    class func loadCell(_ tableView:UITableView)-> MusicListTableViewCell{
        let cellId:String = "MusicListTableViewCellId"
        var cell:MusicListTableViewCell? = tableView.dequeueReusableCell(withIdentifier: cellId) as? MusicListTableViewCell
        if (cell == nil || !cell!.isKind(of: MusicListTableViewCell.self)){
            cell = MusicListTableViewCell()
        }
        cell!.backgroundColor = UIColor.clear
        cell!.selectionStyle = .none
        cell!.textLabel?.textAlignment = .center
        cell?.textLabel?.textColor = UIColor.white
        cell!.textLabel?.font = UIFont.systemFont(ofSize: 12)
        return cell!
        
    }
    
}
