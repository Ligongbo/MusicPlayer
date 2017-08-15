//
//  RecordViewController.swift
//  Test
//
//  Created by LiGongbo on 2017/8/10.
//  Copyright © 2017年 LiGongbo. All rights reserved.
//

import UIKit
import MediaPlayer
typealias sendOutBtnClick = (_ voiceUrl: URL) -> Void
class RecordViewController: UIViewController {
    @IBOutlet var timeLabel: UILabel!
    
    @IBOutlet var recorderBtn: UIButton!
    var sendURLAction: sendOutBtnClick?
    var player: AVAudioPlayer!

    var asset: AVURLAsset!
    var recorder: AVAudioRecorder!
    
    var timer: Timer?
    //录音存放的路径
    var recordUrl: URL!
    
    //---------------------set方法---------------------
    // MARK: - 语音播放的地址
    var contentURL: URL!{
        didSet{
            if self.player != nil && self.player.isPlaying {
                stop()
            }
            DispatchQueue.global(qos: .default).async(execute: {() -> Void in
                self.asset = AVURLAsset(url: self.contentURL, options: [AVURLAssetPreferPreciseDurationAndTimingKey: true])
                let duration: CMTime = self.asset.duration
                let seconds: Int = Int(CMTimeGetSeconds(duration))
                if seconds > 60 {
                    print("A voice audio should't last longer than 60 seconds")
                    self.contentURL = nil
                    self.asset = nil
                    return
                }
                do {
                    let data = try Data(contentsOf: self.contentURL)
                    self.player = try AVAudioPlayer(data: data)
                    self.player.delegate = self
                }catch {
                    print("出现异常:%@",error)
                    return
                }
                self.player.prepareToPlay()
                DispatchQueue.main.async(execute: {() -> Void in
                })
            })
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
    }
    
    @IBAction func recordBtn(_ sender: UIButton) {
        recorderBtn.isSelected = !recorderBtn.isSelected
        if recorderBtn.isSelected {
            recordAudio()
        }else{
            endRecord()
        }
    }
    
    @IBAction func playVoiceBtnClicked(_ sender: UIButton) {
        if player!.isPlaying {
            stop()
        }else {
            play()
        }
    }
}

/**
 *  播放
 */
extension RecordViewController:AVAudioPlayerDelegate {
    func pause() {
        if player != nil &&  player.isPlaying {
            player.pause()
        }
    }
    
    func stop() {
        if player != nil && player.isPlaying {
            player.stop()
            player.currentTime = 0
        }
    }

    func play() {
        if !(self.contentURL != nil) {
            print("没有设置URL")
            return
        }
        
        if !player.isPlaying{
            player.play()
        }
    }
}

/**
 * 录音
 */
extension RecordViewController {
    fileprivate func initData() {
    }
    
    fileprivate func initUI() {
        setRecordingAbout()
    }
    
    // MARK: - 以下是录音相关
    func setRecordingAbout(){
        //初始化录音器
        let session:AVAudioSession = AVAudioSession.sharedInstance()
        //设置录音类型
        try! session.setCategory(AVAudioSessionCategoryPlayback)
        //首先要判断是否允许访问麦克风
        var isAllowed = false
        session.requestRecordPermission { (allowed) in
            if !allowed{
                let alertView = UIAlertView(title: "无法访问您的麦克风" , message: "请到设置 -> 隐私 -> 麦克风 ，打开访问权限", delegate: nil, cancelButtonTitle: "取消", otherButtonTitles: "好的")
                alertView.show()
                isAllowed = false
            }else{
                isAllowed = true
            }
        }
        if isAllowed == false{
            return //如果没有访问权限 返回
        }
        
        let recorderSeetingsDic = [
            AVFormatIDKey: NSNumber(value: kAudioFormatLinearPCM),//
            AVSampleRateKey : 11025.0, //录音器每秒采集的录音样本数
            //AVEncoderBitRateKey : 320000,
            AVNumberOfChannelsKey: 2, //录音的声道数，立体声为双声道
            AVLinearPCMBitDepthKey : 16,
            AVEncoderAudioQualityKey : AVAudioQuality.max.rawValue
            ] as [String : Any]
        
        //语音地址
        self.recordUrl = URL(string: NSTemporaryDirectory() + ("\(getTheTimestamp()).caf"))
        
        recorder = try! AVAudioRecorder(url: self.recordUrl, settings: recorderSeetingsDic)
        if recorder == nil {
            return
        }
        
        //开启仪表计数功能
        recorder?.isMeteringEnabled = true
    }


    fileprivate func recordAudio() {
        let session:AVAudioSession = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        //            self.callView.isHidden = false
        recorder!.prepareToRecord()//准备录音
        recorder!.record()//开始录音
        //启动定时器，定时更新录音音量
        self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self,
                                          selector: #selector(changeImage),
                                          userInfo: nil, repeats: true)
        
    }
    
    /**
     * 结束录音
     */
    fileprivate func endRecord() {
        //        self.callView.isHidden = true
        recorder?.stop()
        //recorder = nil
        timer?.invalidate()
        timer = nil
        endPress()
    }
    
    // MARK: - 结束录音
    fileprivate func endPress(){
        let session:AVAudioSession = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayback)
        let url = URL(fileURLWithPath: self.recordUrl.absoluteString)
        self.contentURL = url
    }
    
    // MARK: - 改变现实的图片
    func changeImage() {
    }
    
    // MARK: - 获取时间戳
    fileprivate func getTheTimestamp() -> String {
        let dat = Date(timeIntervalSinceNow: 0)
        let a: TimeInterval = dat.timeIntervalSince1970
        //  *1000 是精确到毫秒，不乘就是精确到秒
        let timeString = String(format: "%.0f", a)
        //转为字符型
        return timeString
    }
    
}
