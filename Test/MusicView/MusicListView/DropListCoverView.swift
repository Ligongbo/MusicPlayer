//
//  DropListCoverView.swift
//  MiddleSchool2_teacher
//
//  Created by 李琪 on 2017/5/16.
//  Copyright © 2017年 李琪. All rights reserved.
//

import UIKit

class DropListCoverView: UIView {
    var musicListView:MusicListView?
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        let touch:UITouch =  (touches as NSSet).anyObject()! as! UITouch
        let view = touch.view
        
        if (view is MusicListView && musicListView?.touchToHide == true){
            //        if (view!.isMember(of: HSPopupSelectMenuOverlayView()) && popupMenu?.touchToHide == true){
            self.musicListView!.dismiss()
        }
    }
}
