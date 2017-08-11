//
//  FirstViewController.swift
//  Test
//
//  Created by LiGongbo on 2017/8/7.
//  Copyright © 2017年 LiGongbo. All rights reserved.
//

import UIKit
import MediaPlayer

class FirstViewController: UIViewController {
    @IBOutlet var tableView: UITableView!
    static let shareInstance = FirstViewController()

    var models = [SCXMusicModel]()
    var detailVc : SCXDetailViewController?
    lazy var SCX_PopAnimation = SCXPopAnimation { (isPresent) in
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        edgesForExtendedLayout = UIRectEdge(rawValue: 0)
        automaticallyAdjustsScrollViewInsets = true
        initUI()
        initData()
        SCX_monorEarphoneToggleControl()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        GlobalView.shareGlobalView.hideGlobalView()
    }
}

extension FirstViewController {
    fileprivate func initData(){
        detailVc = SCXDetailViewController.shareInstance
        let  models = SCXModelTool.SCX_getMusicModel()
        self.models = models
        SCXMusicMidTool.shareInstance.models = models;
        tableView.reloadData()
    }
    
    fileprivate func initUI() {
        
        initGlobalView()
        initTableView()
    }

    fileprivate func initGlobalView() {
        GlobalView.shareGlobalView.initGlobalView()
        GlobalView.shareGlobalView.hideGlobalView()
        GlobalView.shareGlobalView.presentrButtonClickedBlock = { (model) in
            SCXDetailViewController.shareInstance.SCX_Music_Model = model
            self.present(self.detailVc!, animated: true, completion: nil)
            GlobalView.shareGlobalView.hideGlobalView()
        }
    }
    
    fileprivate func initTableView() {
        let imageView = UIImageView(image: UIImage(named: "QQListBack.jpg"))
        
        tableView.backgroundView = imageView
        
        tableView.backgroundColor = UIColor.clear
        
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        
        tableView.delegate = self;
        
        tableView.dataSource = self;

    }
    
}

extension FirstViewController: UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var  cell  = tableView.dequeueReusableCell(withIdentifier: "cellID")
        
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "cellID")
        }
        
        cell?.textLabel?.text = models[indexPath.row].name;
        cell?.backgroundColor = UIColor.clear
        cell?.selectionStyle = .gray
        return cell!
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true )
        detailVc?.SCX_Music_Model = models[indexPath.row]
        detailVc?.modalPresentationStyle = .custom
        detailVc?.transitioningDelegate = SCX_PopAnimation
        SCXMusicMidTool.shareInstance.SCX_PlayMusic(model: models[indexPath.row])
        SCXMusicMidTool.shareInstance.SCX_MusicBackgroundConfig()
        GlobalView.shareGlobalView.playerButton.isSelected = true
        GlobalView.shareGlobalView.GL_updateView(model: models[indexPath.row])
        GlobalView.shareGlobalView.hideGlobalView()
        self.navigationController?.present(detailVc!, animated: true, completion: nil)
    }
}

// MARK: - 监听耳机线控事件
extension FirstViewController{
    
    func SCX_monorEarphoneToggleControl()  {
        do{
            try AVAudioSession.sharedInstance().setActive(true)
            // 监听
            NotificationCenter.default.addObserver(self, selector: #selector(SCX_HandleToggle(note:)), name: NSNotification.Name.AVAudioSessionRouteChange, object: nil)
        }catch{
            print(error)
        }
    }
    
    func SCX_HandleToggle(note : Notification)  {
        let userInfo = note.userInfo
        let key : AVAudioSessionRouteChangeReason = AVAudioSessionRouteChangeReason( rawValue: userInfo?[AVAudioSessionRouteChangeReasonKey] as! UInt)!
        let model = SCXMusicMidTool.shareInstance.SCX_updatePlayModel()
        //SCX_Music_Model = model
        
        switch key {
        case AVAudioSessionRouteChangeReason.newDeviceAvailable:
            /// 必须在主线程中进行！！！！！！！！！！！！！！！！！坑死我了，基因为没有写主线程 ，所以一直崩溃，一直找原因没有找到，
            DispatchQueue.main.async {
                SCXMusicMidTool.shareInstance.SCX_PlayMusic(model: model)
                SCXMusicMidTool.shareInstance.SCX_MusicBackgroundConfig()
                self.detailVc?.isPlay = true
                self.detailVc?.SCX_updateDetailView(model: model, rotationType: .resume)
            }
        case AVAudioSessionRouteChangeReason.oldDeviceUnavailable:
            print("播出耳机了")
            DispatchQueue.main.async {
                SCXMusicMidTool.shareInstance.SCX_PauseMusic()
                self.detailVc?.isPlay = false
                self.detailVc?.SCX_updateDetailView(model: model, rotationType: .pause)
            }
        default:
            break
        }
    }
}
