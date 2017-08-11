//
//  GlobalView.swift
//  Test
//
//  Created by LiGongbo on 2017/8/7.
//  Copyright © 2017年 LiGongbo. All rights reserved.
//
import UIKit
class GlobalView: WMDragView {
    
    var isshowAnother = false
    var orangeView:WMDragView!
    var titleLabel:UILabel!
    var nameLabel:UILabel!
    var playerButton:UIButton!
    var playerListButton:UIButton!
    var presentrButtonClickedBlock:((_ model:SCXMusicModel) -> Void)?

    var musicModel:SCXMusicModel?
    // 单例
    static let shareGlobalView = GlobalView()
    
    func initGlobalView() {
        let appDelegate = (UIApplication.shared.delegate) as! AppDelegate
        self.isshowAnother = true
        self.frame = CGRect(x: 0, y: ScreenHeight - 44, width: ScreenWidth, height: 44)
        self.dragEnable = true
        self.backgroundColor = UIColor.darkGray
        initView()
        appDelegate.window?.addSubview(self)
    }
    
    func GL_updateView(model:SCXMusicModel) {
        self.musicModel = model
        titleLabel.text = model.name
        nameLabel.text = model.singer
    }
    
    func showGlobalView() {
        self.isHidden = false
    }
    
    func hideGlobalView() {
        self.isHidden = true
    }
    
    fileprivate func initView() {
        initTitleLabel()
        initNameLabel()
        initPlayerButton()
        initPlayerListButton()
    }
    
    fileprivate func initTitleLabel() {
        titleLabel = UILabel()
        titleLabel.text = "作品名称"
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textColor = UIColor.white
        self.contentViewForDrag.addSubview(titleLabel)
    }
    
    fileprivate func initNameLabel() {
        nameLabel = UILabel()
        nameLabel.text = "小胖"
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.textColor = UIColor.white
        self.contentViewForDrag.addSubview(nameLabel)
    }
    
    fileprivate func initPlayerButton() {
        playerButton = UIButton.init(type: UIButtonType.custom)
        playerButton.translatesAutoresizingMaskIntoConstraints = false
        playerButton.addTarget(self, action: #selector(playerButtonClicked(sender:)), for: .touchUpInside)
        playerButton.setImage(UIImage(named:"player_btn_play_highlight"), for: .highlighted)
        playerButton.setImage(UIImage(named:"player_btn_pause_highlight"), for: .selected)
        playerButton.setImage(UIImage(named:"player_btn_play_normal"), for: .normal)
        self.contentViewForDrag.addSubview(playerButton)
    }
    
    fileprivate func initPlayerListButton() {
        playerListButton = UIButton.init(type: UIButtonType.custom)
        playerListButton.translatesAutoresizingMaskIntoConstraints = false
        playerListButton.setImage(UIImage.init(named: "列表"), for: .normal)
        playerListButton.addTarget(self, action: #selector(playerListButtonClicked(sender:)), for: .touchUpInside)
        self.contentViewForDrag.addSubview(playerListButton)
    }
    
    @objc fileprivate func playerListButtonClicked(sender:UIButton?) {
        presentrButtonClickedBlock?(musicModel!)
    }
    
    @objc fileprivate func playerButtonClicked(sender:UIButton?) {
        playerButton.isSelected = !playerButton.isSelected
        if !playerButton.isSelected {
            SCXMusicMidTool.shareInstance.SCX_PauseMusic()
            if musicModel != nil {
                SCXDetailViewController.shareInstance.isPlay = false
                SCXDetailViewController.shareInstance.SCX_updateDetailView(model: musicModel!, rotationType: .pause)
            }
        }
        else{
            SCXMusicMidTool.shareInstance.SCX_PlayCurrentMusic()
            if musicModel != nil {
                SCXDetailViewController.shareInstance.isPlay = true
                SCXDetailViewController.shareInstance.SCX_updateDetailView(model: musicModel!, rotationType: .begin)
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //设置titleLabel的约束
        self.addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 16))
        
        //设置nameLabel的约束
        self.addConstraint(NSLayoutConstraint(item: nameLabel, attribute: .left, relatedBy: .equal, toItem: titleLabel, attribute: .right, multiplier: 1, constant: 8))
        self.addConstraint(NSLayoutConstraint(item: nameLabel, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
        
        //设置playerButton的约束  todo
        self.addConstraint(NSLayoutConstraint(item: playerButton, attribute: .right, relatedBy: .equal, toItem: playerListButton, attribute: .left, multiplier: 1, constant: -8))
        self.addConstraint(NSLayoutConstraint(item: playerButton, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: playerButton, attribute: .left, relatedBy: .greaterThanOrEqual, toItem: nameLabel, attribute: .right, multiplier: 1, constant: 8))
        playerButton.addConstraint(NSLayoutConstraint(item: playerButton, attribute: .height, relatedBy: .equal, toItem: playerButton, attribute: .height, multiplier: 0, constant: 20))
        playerButton.addConstraint(NSLayoutConstraint(item: playerButton, attribute: .width, relatedBy: .equal, toItem: playerButton, attribute: .width, multiplier: 0, constant: 20))
        
        
        //设置playerListButton的约束 todo
        self.addConstraint(NSLayoutConstraint(item: playerListButton, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: -8))
        self.addConstraint(NSLayoutConstraint(item: playerListButton, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
        playerListButton.addConstraint(NSLayoutConstraint(item: playerListButton, attribute: .height, relatedBy: .equal, toItem: playerListButton, attribute: .height, multiplier: 0, constant: 20))
        playerListButton.addConstraint(NSLayoutConstraint(item: playerListButton, attribute: .width, relatedBy: .equal, toItem: playerListButton, attribute: .width, multiplier: 0, constant: 20))
        
    }

}


