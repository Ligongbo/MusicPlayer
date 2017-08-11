//
//  SCXDetailViewController.swift
//  SwiftQQMusic
//
//  Created by 孙承秀 on 2017/3/11.
//  Copyright © 2017年 孙承秀. All rights reserved.
//

import UIKit
import MediaPlayer
class SCXDetailViewController: UIViewController {
    static let shareInstance = SCXDetailViewController()
    
    var isPlay = true
    
    var SCX_topView : SCXTopView = SCXTopView()
    
    var SCX_MidVIew : SCXMidView = SCXMidView()
    
    var SCX_BottomView : SCXBottomView = SCXBottomView()
    
    var SCX_Music_Model : SCXMusicModel?
    
    /// 监听播放状态定时器
    var timer : Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.clear
        
        SCX_setUpBackView()
        
        SCX_setUpTopMidAndBottomView()
        
        SCX_configBackCommond()
        
        // 监听播放完成通知，自动播放下一首
        NotificationCenter.default.addObserver(self, selector: #selector(SCX_PlayerDidFinish), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 添加定时器，监听时刻改变的label
        timer = Timer(timeInterval: 1, target: self, selector: #selector(SCX_moniorPlaytime), userInfo: nil, repeats: true)
        RunLoop.current.add(timer!, forMode: .commonModes)
        // 更新一下界面
        SCX_updateDetailView(model: SCX_Music_Model!, rotationType: .begin)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer?.invalidate()
        timer = nil
        GlobalView.shareGlobalView.showGlobalView()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue : SCX_PlayFinishNotificationKey), object: nil)
    }
    
}

// MARK: - 设置界面
extension SCXDetailViewController {
    
    
    /// 设置背景图片
    fileprivate func SCX_setUpBackView()  {
        let imageView : UIImageView = UIImageView(frame: view.bounds)
        let image : UIImage = UIImage(named: "dzq@2x.jpg")!
        imageView.image = image
        imageView.isUserInteractionEnabled = true
        let blur : UIBlurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurView : UIVisualEffectView = UIVisualEffectView(effect: blur)
        blurView.frame = view.frame;
        blurView.alpha = 1
        imageView .addSubview(blurView)
        view.isUserInteractionEnabled = true
        //view.addSubview(imageView)
        view = imageView
        
        
    }
    
    /// 设置上中下试图
    fileprivate func SCX_setUpTopMidAndBottomView()  {
        SCX_setTopView()
        
        SCX_setMidView()
        
        SCX_setBottomView()
    }
    
    /// 创建头部试图
    fileprivate func SCX_setTopView()  {
        let backButton = UIButton.init(type: UIButtonType.custom)
        backButton.frame = CGRect(x: 8, y: 16, width: 50, height: 30)
        backButton.addTarget(self, action: #selector(backButtonClicked(_:)), for: .touchUpInside)
        backButton.setTitle("返回", for: .normal)
        view.addSubview(backButton)
        
        let topView = SCXTopView(frame: CGRect(x: 0, y: 66, width: SCX_ScreenWidth , height: SCX_ScreenHeight / 5))
        SCX_topView = topView
        SCX_UpdateTopView(model: SCX_Music_Model!)
        view.addSubview(topView)
    }
    
    /// 更新头部试图
    func SCX_UpdateTopView(model :SCXMusicModel)  {
        SCX_topView.SCX_updateTopView(model: model)
    }
    
    fileprivate func SCX_setMidView()  {
        let midView = SCXMidView(frame: CGRect(x: 0, y: ScreenHeight / 5, width: ScreenWidth, height: ScreenHeight / 5 * 3))
        SCX_MidVIew = midView
        //SCX_UpdateMidView(model: SCX_Music_Model!)
        view.addSubview(midView)
    }
    
    fileprivate func SCX_setBottomView()  {
        let bottomView  = SCXBottomView(frame: CGRect(x: 0, y: ScreenHeight / 5 * 4, width: ScreenWidth, height: ScreenHeight / 5))
        bottomView.delegate = self
        SCX_BottomView = bottomView
        self.view.addSubview(bottomView)
    }
    
    /// 更新底部试图
    func SCX_UpdateBottomView(model : SCXMusicModel , play : Bool)  {
        SCX_BottomView.SCX_UpdateBottomView(model: model, play: play)
    }
    
    func backButtonClicked(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }

    
}

// MARK: - 手势事件
extension SCXDetailViewController :UIGestureRecognizerDelegate {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
}

// MARK: - bottomView代理方法,更新model了
extension SCXDetailViewController :SCXBottomViewDelegate{
    func SCX_ModelChange(play: Bool, rotationType: SCXRotationType) {
        let model = SCXMusicMidTool.shareInstance.SCX_updatePlayModel()
        SCX_Music_Model = model
        isPlay = play
        SCX_updateDetailView(model: model, rotationType: rotationType)
    }
}
extension SCXDetailViewController{
    /// 实时更新本界面，很重要的方法
    func SCX_updateDetailView(model : SCXMusicModel, rotationType : SCXRotationType )  {
        SCX_UpdateTopView(model: model)
        SCX_UpdateBottomView(model: model , play: isPlay)
    }
}

// MARK: - 添加定时器时刻监听播放进度
extension SCXDetailViewController{
    /// 时刻监听播放进度
    func SCX_moniorPlaytime()  {
        let model = SCXMusicMidTool.shareInstance.SCX_updatePlayModel()
        SCX_UpdateBottomView(model: model, play: SCX_BottomView.SCX_Bottom_PalyBtn.isSelected)
    }
    
    /// 实时监听歌词
    func SCX_moniorPlayLrc()  {
        // 实时监听远程事件，控制锁屏界面, 只有在后台的时候才监听
        if UIApplication.shared.applicationState == .background {
            SCXMusicMidTool.shareInstance.SCX_MusicBackgroundConfig()
        }
    }
}

extension SCXDetailViewController{
    /// 播放完成
    func SCX_PlayerDidFinish()  {
        SCXMusicMidTool.shareInstance.SCX_NextMusic()
        let model = SCXMusicMidTool.shareInstance.SCX_updatePlayModel()
        SCX_Music_Model = model
        isPlay = true
        SCX_updateDetailView(model: model, rotationType: .begin)
    }
}

// MARK: - 实时监控远程事件,处理歌曲的播放暂停
extension SCXDetailViewController{
    /*  不包含任何子事件类型
     UIEventSubtypeNone                              = 0,
      摇晃事件（从iOS3.0开始支持此事件）
     UIEventSubtypeMotionShake                       = 1,
     远程控制子事件类型（从iOS4.0开始支持远程控制事件）
     播放事件【操作：停止状态下，按耳机线控中间按钮一下】
     UIEventSubtypeRemoteControlPlay                 = 100,
     暂停事件
     UIEventSubtypeRemoteControlPause                = 101,
     停止事件
     UIEventSubtypeRemoteControlStop                 = 102,
     播放或暂停切换【操作：播放或暂停状态下，按耳机线控中间按钮一下】
     UIEventSubtypeRemoteControlTogglePlayPause      = 103,
     下一曲【操作：按耳机线控中间按钮两下】
     UIEventSubtypeRemoteControlNextTrack            = 104,
     上一曲【操作：按耳机线控中间按钮三下】
     UIEventSubtypeRemoteControlPreviousTrack        = 105,
     快退开始【操作：按耳机线控中间按钮三下不要松开】
     UIEventSubtypeRemoteControlBeginSeekingBackward = 106,
     快退停止【操作：按耳机线控中间按钮三下到了快退的位置松开】
     UIEventSubtypeRemoteControlEndSeekingBackward   = 107,
     快进开始【操作：按耳机线控中间按钮两下不要松开】
     UIEventSubtypeRemoteControlBeginSeekingForward  = 108,
     快进停止【操作：按耳机线控中间按钮两下到了快进的位置松开】
     UIEventSubtypeRemoteControlEndSeekingForward    = 109,
     */
    
    override func remoteControlReceived(with event: UIEvent?) {
        let type = event?.subtype
        var play : Bool = true
        var animationBegin : Bool = true
        switch type! {
        case .remoteControlPlay:
            print("播放")
            SCXMusicMidTool.shareInstance.SCX_PlayMusic(model: SCX_Music_Model!)
            SCXMusicMidTool.shareInstance.SCX_MusicBackgroundConfig()
            play = true
            animationBegin = true
        case .remoteControlPause:
            print("暂停")
            SCXMusicMidTool.shareInstance.SCX_PauseMusic()
            play = false
            animationBegin = false
        case .remoteControlNextTrack:
            play = true
            animationBegin = true
        case .remoteControlPreviousTrack:
            print("上一首")
            SCXMusicMidTool.shareInstance.SCX_PreMusic()
            let model = SCXMusicMidTool.shareInstance.SCX_updatePlayModel()
            SCX_Music_Model = model
            isPlay = true
            SCX_updateDetailView(model: model, rotationType: .begin)
            play = true
            animationBegin = true
        // 处理耳机线控
        case .remoteControlTogglePlayPause:
            if SCXPlayTool.shareInstance.player?.rate == 1 {
                print("暂停")
                SCXMusicMidTool.shareInstance.SCX_PauseMusic()
                play = false
                animationBegin = false
            }
            else{
                print("播放")
                SCXMusicMidTool.shareInstance.SCX_PlayMusic(model: SCX_Music_Model!)
                SCXMusicMidTool.shareInstance.SCX_MusicBackgroundConfig()
                play = true
                animationBegin = true
            }
        case .remoteControlBeginSeekingForward:
            SCXPlayTool.shareInstance.musicCurrentTime += 3
            let seconds : Int64 = Int64(SCXPlayTool.shareInstance.musicCurrentTime)
            let targetTime:CMTime = CMTimeMake(seconds, 1)
            SCXPlayTool.shareInstance.SCX_SeekToTime(time: targetTime)
            print("快进开始")
        case .remoteControlBeginSeekingBackward:
            SCXPlayTool.shareInstance.musicCurrentTime += 3
            let seconds : Int64 = Int64(SCXPlayTool.shareInstance.musicCurrentTime)
            let targetTime:CMTime = CMTimeMake(seconds, 1)
            SCXPlayTool.shareInstance.SCX_SeekToTime(time: targetTime)
            print("快退开始")
        case .remoteControlEndSeekingBackward:
            print("快退结束")
        case .remoteControlEndSeekingForward:
            print("快进结束")
        default:
            print("nono")
        }
        let model = SCXMusicMidTool.shareInstance.SCX_updatePlayModel()
        SCX_Music_Model = model
        
        isPlay = play
        if animationBegin {
            SCX_updateDetailView(model: model, rotationType: .resume)
        }
        else{
            SCX_updateDetailView(model: model, rotationType: .pause)
        }
    }
    
}
extension SCXDetailViewController{
    
    /// 锁屏界面上的按钮设置  上滑出菜单
    func SCX_configBackCommond()  {
        let command = MPRemoteCommandCenter.shared()
        command.likeCommand.isEnabled = true
        command.likeCommand.addTarget(self, action: #selector(SCX_like))
        command.likeCommand.localizedTitle = "喜欢"
        command.likeCommand.isActive = true
        
        command.dislikeCommand.isEnabled = true
        command.dislikeCommand.addTarget(self, action: #selector(SCX_Unlike))
        command.dislikeCommand.localizedTitle = "不喜欢"
        command.dislikeCommand.isActive = true
        command.playCommand.isEnabled = true
        
        //播放
        let playCommond : MPRemoteCommand = command.playCommand
        playCommond.isEnabled = true
        playCommond.addTarget(self, action: #selector(play))
        
        //暂停
        let pauseCommond : MPRemoteCommand = command.pauseCommand
        pauseCommond.isEnabled = true
        pauseCommond.addTarget(self, action: #selector(pause))
        
        //下一首
        let nextCommond : MPRemoteCommand = command.nextTrackCommand
        nextCommond.isEnabled = true
        nextCommond.addTarget(self, action: #selector(nextMusic))
    }
    
    /// 这个方法只是个中间方法，如果不写的话按钮不显示
    func play()  {
        SCXMusicMidTool.shareInstance.SCX_PlayCurrentMusic()
        if SCX_Music_Model != nil {
            SCXDetailViewController.shareInstance.isPlay = true
            SCXDetailViewController.shareInstance.SCX_updateDetailView(model: SCX_Music_Model!, rotationType: .begin)
        }
    }
    
    func pause() {
        SCXMusicMidTool.shareInstance.SCX_PauseMusic()
        if SCX_Music_Model != nil {
            SCXDetailViewController.shareInstance.isPlay = false
            SCXDetailViewController.shareInstance.SCX_updateDetailView(model: SCX_Music_Model!, rotationType: .pause)
        }
    }
    
    func nextMusic() {
        print("下一首")
        SCXMusicMidTool.shareInstance.SCX_NextMusic()
        let model = SCXMusicMidTool.shareInstance.SCX_updatePlayModel()
        SCX_Music_Model = model
        isPlay = true
        SCX_updateDetailView(model: model, rotationType: .begin)
    }
    
    func SCX_like() {
//        print("喜欢,先用暂停代理")
//        SCXMusicMidTool.shareInstance.SCX_PauseMusic()
//        let model = SCXMusicMidTool.shareInstance.SCX_updatePlayModel()
//        SCX_Music_Model = model
//        isPlay = false
//        SCX_updateDetailView(model: model, rotationType: .pause)
    }
    func SCX_Unlike()  {
//        print("不喜欢,先用上一曲代替")
//        SCXMusicMidTool.shareInstance.SCX_PreMusic()
//        let model = SCXMusicMidTool.shareInstance.SCX_updatePlayModel()
//        SCX_Music_Model = model
//        isPlay = true
//        SCX_updateDetailView(model: model, rotationType: .begin)
    }
    
}





