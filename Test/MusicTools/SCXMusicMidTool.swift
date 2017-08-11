//
//  SCXMusicMidTool.swift
//  SwiftQQMusic
//
//  Created by 孙承秀 on 2017/3/11.
//  Copyright © 2017年 孙承秀. All rights reserved.
//

import UIKit
import MediaPlayer
class SCXMusicMidTool: NSObject {
    // 单例
    static let shareInstance = SCXMusicMidTool()
    // 歌曲模型
    var models = [SCXMusicModel]()
    /// 当前歌词
    var currentLrc : String? = ""
    var artWorkItem : MPMediaItemArtwork?
    var currentIndex = -1{
        didSet{
            if currentIndex < 0  {
                currentIndex = models.count - 1
            }
            if currentIndex > models.count - 1 {
                currentIndex = 0
            }
        }
    }
    
    /// 播放音乐
    func SCX_PlayMusic(model : SCXMusicModel)  {
        let name = model.musicUrl
        guard name != nil else {
            return
        }
        currentIndex = models.index(of: model)!
        SCXPlayTool.shareInstance.SCX_PlayMusic(name: name!)
        SCXMusicMidTool.shareInstance.SCX_MusicBackgroundConfig()
    }
    
    /// 播放音乐
    func SCX_PlayCurrentMusic()  {
        
        let model = models[currentIndex]
        guard model.musicUrl != nil else {
            return
        }
        
        SCXPlayTool.shareInstance.SCX_PlayMusic(name: model.musicUrl!)
        SCXMusicMidTool.shareInstance.SCX_MusicBackgroundConfig()
    }
    
    /// 暂停音乐
    func SCX_PauseMusic()  {
        if currentIndex < 0 {
            return
        }
        
        let model = models[currentIndex]
        guard model.musicUrl != nil else {
            return
        }
        SCXPlayTool.shareInstance.SCX_PauseMusic()
    }
    
    /// 下一曲
    func SCX_NextMusic()  {
        currentIndex += 1
        let model =  models[currentIndex]
        SCXPlayTool.shareInstance.SCX_PlayMusic(name: model.musicUrl!)
        SCXMusicMidTool.shareInstance.SCX_MusicBackgroundConfig()
        GlobalView.shareGlobalView.GL_updateView(model: model)
    }
    
    /// 上一曲
    func SCX_PreMusic()  {
        currentIndex -= 1
        let model =  models[currentIndex]
        SCXPlayTool.shareInstance.SCX_PlayMusic(name: model.musicUrl!)
        GlobalView.shareGlobalView.GL_updateView(model: model)
        SCXMusicMidTool.shareInstance.SCX_MusicBackgroundConfig()
    }
    
    /// 将播放器seek到某个时间
    func SCX_SeekToTime(time : CMTime)  {
        SCXPlayTool.shareInstance.SCX_SeekToTime(time: time)
    }
    
    /// 获取音乐的播放进度
    func SCX_updatePlayModel() -> (SCXMusicModel) {
        // 容错，防止第一次进来的时候，没有播放歌曲，插入了耳机，那么没有index
        if currentIndex < 0 {
            return SCXMusicModel()
        }
        let model : SCXMusicModel = models[currentIndex]
        if model.musicModel == nil {
            model.musicModel = SCXPlayModel()
        }
        let musicModel = model.musicModel
        musicModel?.music_preTime = SCXPlayTool.shareInstance.musicCurrentTime
        musicModel?.music_totalTime = SCXPlayTool.shareInstance.musicAllTime
        return model
    }
    
    func SCX_MusicBackgroundConfig()  {
        // 获取锁屏中心
        let center = MPNowPlayingInfoCenter.default()
        // MPMediaItemPropertyAlbumTitle       专辑标题
        // MPMediaItemPropertyAlbumTrackCount  专辑歌曲数
        // MPMediaItemPropertyAlbumTrackNumber 专辑歌曲编号
        // MPMediaItemPropertyArtist           艺术家/歌手
        // MPMediaItemPropertyArtwork          封面图片 MPMediaItemArtwork类型
        // MPMediaItemPropertyComposer         作曲
        // MPMediaItemPropertyDiscCount        专辑数
        // MPMediaItemPropertyDiscNumber       专辑编号
        // MPMediaItemPropertyGenre            类型/流派
        // MPMediaItemPropertyPersistentID     唯一标识符
        // MPMediaItemPropertyPlaybackDuration 歌曲时长  NSNumber类型
        // MPMediaItemPropertyTitle            歌曲名称
        // MPNowPlayingInfoPropertyElapsedPlaybackTime
        let model = models[currentIndex]
        
        let albumTitle = model.name ?? ""
        let artist = model.singer ?? ""
        let elapsedPlaybackTime = SCXPlayTool.shareInstance.musicCurrentTime 
        let durtion = SCXPlayTool.shareInstance.musicAllTime 

        let infoDic :NSMutableDictionary  = [MPMediaItemPropertyAlbumTitle : albumTitle ,
                                             MPMediaItemPropertyArtist : artist ,
                                             
                                             MPNowPlayingInfoPropertyElapsedPlaybackTime : elapsedPlaybackTime ,
                                             MPMediaItemPropertyPlaybackDuration : durtion
                                             ]
        if artWorkItem != nil {
            infoDic.setValue(artWorkItem, forKey: MPMediaItemPropertyArtwork)
        }
        let playInfo = infoDic.copy()
        UIApplication.shared.beginReceivingRemoteControlEvents()
        center.nowPlayingInfo = playInfo as? [String : Any]
        // 开始接受远程事件
    
    }
}


