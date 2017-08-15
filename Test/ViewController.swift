//
//  ViewController.swift
//  Test
//
//  Created by LiGongbo on 2017/6/14.
//  Copyright © 2017年 LiGongbo. All rights reserved.
//

import UIKit
import Alamofire
import SnapKit

//屏幕尺寸相关
let ScreenWidth:CGFloat = UIScreen.main.bounds.size.width;
let ScreenHeight:CGFloat = UIScreen.main.bounds.size.height

class ViewController: UIViewController {
    var floatView: FloatView!
    override func viewDidLoad() {
        super.viewDidLoad()
        initData()
        initUI()
    }
    
    @IBAction func CyclePageBtnClicked(_ sender: UIButton) {
        self.performSegue(withIdentifier: "showCyclePageViewController", sender: nil)
    }
    
    @IBAction func nextButtonClicked(_ sender: UIButton) {
        self.performSegue(withIdentifier: "showFirstViewController", sender: nil)
    }
}

extension ViewController{
    fileprivate func initData(){
    }

    fileprivate func initUI() {
        loadFloatView()
    }
    
    fileprivate func loadFloatView() {
        if floatView == nil {
            floatView = FloatView.init()
            floatView.frame = CGRect(x: ScreenWidth - 68, y: ScreenHeight - 126, width: 60, height: 60)
            floatView.setImageWithName("HSM_IM_PhoneCall")
            self.view.addSubview(floatView)
        }
        floatView.setTapActionWith { 
            self.performSegue(withIdentifier: "showRecordViewController", sender: nil)
        }
    }
}

