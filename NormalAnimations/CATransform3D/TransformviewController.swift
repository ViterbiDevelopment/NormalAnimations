//
//  TransformviewController.swift
//  NormalAnimations
//
//  Created by 掌上先机 on 17/1/6.
//  Copyright © 2017年 wangchao. All rights reserved.
//

import UIKit

class TransformviewController: UIViewController {
    
    
    var popView:UIView!
    
    var maskView:UIView!
    
    let screenW = UIScreen.main.bounds.width
    
    let screenH = UIScreen.main.bounds.height

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "CATransform3D"
        
        view.backgroundColor = UIColor.white
        
        
        configureBtn()
        
        maskView = UIView.init(frame: CGRect(x: 0, y: 0, width: screenW, height: screenH))
        maskView.alpha = 0
        maskView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
       
        navigationController?.view.addSubview(maskView)
        
        popView = UIView.init(frame: CGRect(x: 0, y: screenH, width: screenW, height: 300))
        popView.backgroundColor = UIColor.white
        
        // popView向前平移
        let popTransLate = CATransform3DIdentity
        popView.layer.transform = CATransform3DTranslate(popTransLate, 0, 0, 85)
        
        UIApplication.shared.keyWindow?.addSubview(popView)
    
        let closeBtn = UIButton.init(type: .system)
        
        closeBtn.frame = CGRect(x: 0, y: 0, width: 60, height: 60)
        
        closeBtn.addTarget(self, action: #selector(TransformviewController.closeBtn), for: .touchUpInside)

        closeBtn.setTitle("关闭", for: .normal)
        
        popView.addSubview(closeBtn)
    
       
    }
    
    func configureBtn()  {
        
        let click = UIButton.init(type: .system)
        click.bounds = CGRect(x: 0, y: 0, width: 100, height: 100)
        
        click.center = CGPoint(x: self.view.center.x, y: 180)
        
        click.backgroundColor = UIColor.red
        
        click.addTarget(self, action: #selector(TransformviewController.btnClick), for: .touchUpInside)
        click.setTitle("点我", for: .normal)
        
        view.addSubview(click)
        
    }
    
    func btnClick()  {
        
        
        
        
        UIView.animate(withDuration: 0.6, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: {
            self.maskView.alpha = 0.5
            
            self.popView.frame = CGRect(x: 0, y: self.screenH - 300, width: self.screenW, height: 300)

            
        }, completion: nil)
        
        
        UIView.animate(withDuration: 0.35, animations: {
            
            self.navigationController?.view.layer.transform = self.transform1()
            
            
            
        }) { (finish) in
            
           
            UIView.animate(withDuration: 0.3, animations: {
                
                
                self.navigationController?.view.layer.transform = self.transform2()
                

                
            })
        }
      
        
        
    }
    
    
    func closeBtn() {
        
        
        
        UIView.animate(withDuration: 0.6, delay: 0, options: UIViewAnimationOptions.curveEaseIn, animations: {
            
            self.maskView.alpha = 0
            
            self.popView.frame = CGRect.init(x: 0, y: self.screenH, width: self.screenW, height: 300)
            
        }, completion: nil)
        

        
       
        UIView.animate(withDuration: 0.25, animations: {
            
            
            self.navigationController?.view.layer.transform = self.transform1()
            
           
        }) { (finish) in
            
                        
            UIView.animate(withDuration: 0.4, animations: {
              
                
                self.navigationController?.view.layer.transform = CATransform3DIdentity
                
            })
            
            
        }
        
        
    }
    
    func transform1()->CATransform3D  {
        
        var form1 = CATransform3DIdentity
        
        form1.m34 = -1/900
       
        form1 = CATransform3DRotate(form1, CGFloat(12*Double.pi / 180), 1, 0, 0)
        
        //这个要平移，不然会切掉弹出来的视图
      //  form1 = CATransform3DTranslate(form1, 0, 0, -85)

        return form1
    }
    
    func transform2() ->CATransform3D {
        
        var form2 = CATransform3DIdentity
        
        form2.m34 = transform1().m34
        
        form2 = CATransform3DTranslate(form2, 0, -10, 0)
        
        form2 = CATransform3DScale(form2, 0.9, 0.9, 1)
        
        return form2
        
        
    }
    
    deinit {
        
        print("deinit")
    }

}
