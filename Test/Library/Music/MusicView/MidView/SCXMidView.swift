//
//  SCXMidView.swift
//  SwiftQQMusic
//
//  Created by 孙承秀 on 2017/3/12.
//  Copyright © 2017年 孙承秀. All rights reserved.
//

import UIKit

class SCXMidView: UIScrollView {
    
    var SCX_IconName : String?
    
    var SCX_MusicModel : SCXMusicModel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.delegate = self
        
        showsHorizontalScrollIndicator = false
        
        isPagingEnabled = true
        
        contentSize = CGSize(width: ScreenWidth * 2, height: 0)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
       
        
    }
}


extension SCXMidView : UIScrollViewDelegate{

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
      
        
    }

}


