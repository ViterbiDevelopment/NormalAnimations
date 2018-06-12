//
//  CardViewAnimationController.swift
//  NormalAnimations
//
//  Created by Viterbi on 2018/6/12.
//  Copyright © 2018年 wangchao. All rights reserved.
//

import UIKit

class CardViewAnimationController: UIViewController {
    var transformArray:[UILabel]!
    var isNeedRemove:Bool = false
  
    var cardView:CardAnimationView?
    override func viewDidLoad() {
        super.viewDidLoad()
      
        view.backgroundColor = UIColor.groupTableViewBackground
      
        transformArray = []
      
        for i in 0..<7 {
          let lable = UILabel.init(frame: CGRect(x: 100, y: 100, width: 300, height: 300))
          
          lable.backgroundColor = UIColor(red: CGFloat(arc4random() % 255) / 255.0, green: CGFloat(arc4random() % 255) / 255.0, blue: CGFloat(arc4random() % 255) / 255.0, alpha: 1.0)
          lable.text = "\(i)"
          transformArray.append(lable)
        }
      
        let animation = CardAnimationView.init(frame: CGRect(x: 100, y: 100, width: 300, height: 400), transfromSubviews: transformArray)
        animation.backgroundColor = UIColor.red
        animation.delegate = self
      
        cardView = animation
      
        view.addSubview(animation)
      
        let nextBtn = getBtn(with: CGRect(x: 0, y: 100, width: 100, height: 100), title: "下一页")
        nextBtn.addTarget(self, action: #selector(nextClick), for: .touchUpInside)
          view.addSubview(nextBtn)
      
        let deleteCurrent = getBtn(with: CGRect(x: 0, y: 200, width: 100, height: 100), title: "删除当前页")
        deleteCurrent.addTarget(self, action: #selector(deleteCurrentClick), for: .touchUpInside)
        view.addSubview(deleteCurrent)
      
        let upBtn = getBtn(with: CGRect(x: 0, y: 300, width: 100, height: 100), title: "上一页")
        upBtn.addTarget(self, action: #selector(upBtnClick), for: .touchUpInside)
          view.addSubview(upBtn)
      
    }
  
    @objc func nextClick()  {
        cardView?.nextAnimation()
    }
    @objc func deleteCurrentClick()  {
      
        cardView?.deleteCurrentAnimation()
    }
  
    @objc func upBtnClick() {
      
        cardView?.previousAnimation()
    }
  
    func getBtn(with frame:CGRect,title:String) -> UIButton {
      
        let btn = UIButton.init(type: .system)
        btn.setTitle(title, for: .normal)
        btn.frame = frame
      
        return btn
      }
  
}
  extension CardViewAnimationController:CardAnimationViewDelegate{
    
      func CardAnimationShouldWill(with SubviewArray: [UIView]) {
        
        
      }
    
      func CardAnimationViewFinish(with SubviewsArray: [UIView], currentSub: UIView) {
        
        
      }
    
  }
