//
//  SCXPlayTool.swift
//  SwiftQQMusic
//
//  Created by 孙承秀 on 2017/3/11.
//  Copyright © 2017年 孙承秀. All rights reserved.
//

import UIKit
import AVFoundation
class SCXPlayTool: NSObject , AVAudioPlayerDelegate {
    static let shareInstance = SCXPlayTool()

    //播放器相关
    var playerItem:AVPlayerItem?
    var player: AVPlayer? {
        didSet{
            let session = AVAudioSession.sharedInstance()
            do{
                try session.setCategory(AVAudioSessionCategoryPlayback)
                try session.setActive(true)
            }
            catch{
                print(error);
                return
            }
        }
    }

    /**
     * 总时长
     */
    var musicAllTime : Float64 = 0.0
    
    /**
     * 已播放时长
     */
    var musicCurrentTime :Float64 = 0.0
    
    /**
     * 正在播放的url
     */
    var playingName = ""
    
    /// 播放
    func SCX_PlayMusic(name : String)  {
        if playingName == name {
            player!.play()
            return
        }
        playingName = name
        playMusic()
        observePlayingItem()
        configBreakObserver()
        player!.play()
    }
    
    /// 暂停
    func SCX_PauseMusic()  {
        player!.pause()
    }
    
    /**
     继续
     */
    public func goOn() {
        player?.rate = 1
    }
    /**
     暂停 - 可继续
     */
    public func pause() {
        player?.rate = 0
    }
    
    /// 定位到某个时间
    func SCX_SeekToTime(time : CMTime)  {
        player!.seek(to: time)
        //如果当前时暂停状态，则自动播放
        if player!.rate == 0
        {
            player?.play()
        }
    }
    
}


// MARK: - private funcs
extension SCXPlayTool {
    /**
     播放当前音乐
     */
    fileprivate func playMusic() {
        let currentUrl = URL(string: playingName)
        guard let currentURL = currentUrl else {return}
        //  结束上一首
        endPlay()
        playerItem = AVPlayerItem(url: currentURL)
        player = AVPlayer(playerItem: playerItem!)
    }
    
    /**
     * 监听变化
     */
    fileprivate func observePlayingItem() {
        let duration : CMTime = playerItem!.asset.duration
        musicAllTime = CMTimeGetSeconds(duration)
        
        //播放过程中动态改变进度条值和时间标签
        player!.addPeriodicTimeObserver(forInterval: CMTimeMakeWithSeconds(1, 1),
                                        queue: DispatchQueue.main) { (CMTime) -> Void in
                                            if self.player!.currentItem?.status == .readyToPlay && self.player?.rate != 0{
                                                //更新进度条进度值
                                                self.musicCurrentTime = CMTimeGetSeconds(self.player!.currentTime())
                                            }
        }
    }
    
    /**
     * 停止播放
     */
    fileprivate func endPlay() {
        player?.rate = 0
        player?.replaceCurrentItem(with: nil)
        
        musicAllTime = 0
        musicCurrentTime = 0
        player = nil
    }

}
extension SCXPlayTool {

    //  监听打断
    fileprivate func configBreakObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleInterruption), name: NSNotification.Name.AVAudioSessionInterruption, object: AVAudioSession.sharedInstance())
        NotificationCenter.default.addObserver(self, selector: #selector(handleRouteChange), name: NSNotification.Name.AVAudioSessionRouteChange, object: AVAudioSession.sharedInstance())
    }
    
    //  来电打断
    @objc fileprivate func handleInterruption(_ noti: Notification) {
        guard noti.name == NSNotification.Name.AVAudioSessionInterruption else { return }
        guard let info = noti.userInfo, let typenumber = (info[AVAudioSessionInterruptionTypeKey] as AnyObject).uintValue, let type = AVAudioSessionInterruptionType(rawValue: typenumber) else { return }
        switch type {
        case .began:
            pause()
        case .ended:
            goOn()
        }
    }
    
    //拔出耳机等设备变更操作
    @objc fileprivate func handleRouteChange(_ noti: Notification) {
        func analysisInputAndOutputPorts(_ noti: Notification) {
            guard let info = noti.userInfo, let previousRoute = info[AVAudioSessionRouteChangePreviousRouteKey] as? AVAudioSessionRouteDescription else { return }
            let inputs = previousRoute.inputs
            let outputs = previousRoute.outputs
            print(inputs)
            print(outputs)
        }
        
        guard noti.name == NSNotification.Name.AVAudioSessionRouteChange else { return }
        guard let info = noti.userInfo, let typenumber = (info[AVAudioSessionRouteChangeReasonKey] as AnyObject).uintValue, let type = AVAudioSessionRouteChangeReason(rawValue: typenumber) else { return }
        switch type {
        case .unknown:
            break
        case .newDeviceAvailable:
            break
        case .oldDeviceUnavailable:
            break
        case .categoryChange:
            break
        case .override:
            break
        case .wakeFromSleep:
            break
        case .noSuitableRouteForCategory:
            break
        case .routeConfigurationChange:
            break
        }
    }
}

