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
    
    var sendURLAction: sendOutBtnClick?
    var recorder: AVAudioRecorder!
    var timer: Timer?
    //录音存放的路径
    var recordUrl: URL!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func recordBtn(_ sender: UIButton) {
        recordAudio()
    }
}

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
        self.sendURLAction!(self.recordUrl)
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
