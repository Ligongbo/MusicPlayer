//
//  UIView+LH.swift
//  HandleSchool
//
//  Created by 李琪 on 16/4/28.
//  Copyright © 2016年 Huihai. All rights reserved.
//

extension UIView {
    
    
    class func setCornerWithView(_ view:UIView, cornerRadius:CGFloat){
        view.layer.cornerRadius = cornerRadius
        view.layer.masksToBounds = true
        view.clipsToBounds = true
    }
    
    func setCornerWithRadius(_ cornerRadius:CGFloat){
        UIView.setCornerWithView(self, cornerRadius: cornerRadius)
    }
    
    class func loadViewWithName(_ name:String) -> AnyObject?{
        let nibs = Bundle.main.loadNibNamed(name, owner: self, options: nil)
        if nibs != nil && nibs!.count > 0{
            return nibs![0] as AnyObject?
        }
        return nil
    }

    func removeAllSubviews(){
        for view in self.subviews{
            view.removeFromSuperview()
        }
    }

    func drawInView(_ superView:UIView){
        drawInView(superView, leftMargin: 0, topMargin: 0, rightMargin: 0, bottomMargin: 0)
    }
    
    func drawInView(_ superView:UIView, needToAddSubView:Bool){
        drawInView(superView, leftMargin: 0, topMargin: 0, rightMargin: 0, bottomMargin: 0, needToAddSubView: needToAddSubView)
    }
    
    func drawInView(_ superView:UIView, leftMargin:CGFloat?, topMargin:CGFloat?, rightMargin:CGFloat?, bottomMargin:CGFloat?){
        drawInView(superView, leftMargin: leftMargin, topMargin: topMargin, rightMargin: rightMargin, bottomMargin: bottomMargin, needToAddSubView: true)
    }
    
    func drawInView(_ superView:UIView, leftMargin:CGFloat?, topMargin:CGFloat?, rightMargin:CGFloat?, bottomMargin:CGFloat?, needToAddSubView:Bool){
        if needToAddSubView{
            superView.addSubview(self)
        }
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        if leftMargin != nil{
            superView.addConstraint(NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: superView, attribute: .leading, multiplier: 1, constant: leftMargin!))
        }
        
        if topMargin != nil{
            superView.addConstraint(NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: superView, attribute: .top, multiplier: 1, constant: topMargin!))
        }
        
        if rightMargin != nil{
            superView.addConstraint(NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: superView, attribute: .trailing, multiplier: 1, constant: -rightMargin!))
        }
        
        if bottomMargin != nil{
            superView.addConstraint(NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: superView, attribute: .bottom, multiplier: 1, constant: -bottomMargin!))
        }
    }


}
