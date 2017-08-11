//
//  SCXMusicModel.swift
//  SwiftQQMusic
//
//  Created by 孙承秀 on 2017/3/11.
//  Copyright © 2017年 孙承秀. All rights reserved.
//

import UIKit

class SCXMusicModel: NSObject {
    /** 歌曲名称 */
    var name: String?
    /** 歌曲文件名称 */
    var filename: String?
    /** 歌词文件名称 */
    var lrcname: String?
    /** 歌手名称 */
    var singer: String?
    /** 歌手头像名称 */
    var singerIcon: String?
    /** 专辑头像图片 */
    var icon: String?
    /** 歌曲链接地址 */
    var musicUrl: String?
    // 音乐模型，包括音乐播放时长，总时长，进度等
    var musicModel : SCXPlayModel?
    
    
    override init() {
        super.init()
    }
    
    init(dic : [String : AnyObject]) {
        super.init()
        setValuesForKeys(dic)
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    
}
