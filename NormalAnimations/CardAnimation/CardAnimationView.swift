//
//  CardView.swift
//  cardAnimation
//
//  Created by Viterbi on 2018/6/11.
//  Copyright © 2018年 Viterbi. All rights reserved.
//

import UIKit

extension UIView{
  var card_x : CGFloat{
    get{
      return self.frame.origin.x
    }
    set(newVal)
    {
      var tmpFrame : CGRect = frame
      tmpFrame.origin.x     = newVal
      frame                 = tmpFrame
    }
  }
  var card_y : CGFloat{
    
    get{
      return self.frame.origin.y
    }
    set(newVal){
      var tmpFrame : CGRect = frame
      tmpFrame.origin.y     = newVal
      frame                 = tmpFrame
    }
  }
  var card_height : CGFloat {
    get {
      return frame.size.height
    }
    
    set(newVal) {
      var tmpFrame : CGRect = frame
      tmpFrame.size.height  = newVal
      frame                 = tmpFrame
    }
  }
  
  // width
  var card_width : CGFloat {
    
    get {
      return frame.size.width
    }
    set(newVal) {
      var tmpFrame : CGRect = frame
      tmpFrame.size.width   = newVal
      frame                 = tmpFrame
    }
  }
  var card_CenterX:CGFloat{
    
    get{
      return self.center.x
    }set(newValue){
      var tempCenter : CGPoint = self.center
      tempCenter.x             = newValue
      self.center              = tempCenter
    }
    
  }
  var card_CenterY:CGFloat{
    
    get{
      return self.center.y
    }
    set(newValue){
      var tempCenter:CGPoint = self.center
      tempCenter.y           = newValue
      self.center            = tempCenter
    }
  }
  
}


protocol CardAnimationViewDelegate:class {
  
  // 动画结束
  func CardAnimationViewFinish(with SubviewsArray:[UIView],currentSub:UIView)
  
  //动画开始
  func CardAnimationShouldWill(with SubviewArray:[UIView])
  
  
}

class CardAnimationView: UIView {

  var isNeedRemove:Bool = false
  var transformArray:[UIView]!
  
  var cardAnimationDistance:Int = 50 //每个卡片 等比例距离
  var cardAnimationScale:Double = 0.05 //每个卡片的 等比例缩小系数
  
  var isAnimation:Bool = false //是否正在动画
  
  weak var delegate:CardAnimationViewDelegate?
  
  var upGes:UISwipeGestureRecognizer?
  var downGes:UISwipeGestureRecognizer?
  
  convenience init(frame: CGRect,transfromSubviews:[UIView]!) {
    self.init(frame: frame)
    
    transformArray = transfromSubviews.reversed()
    
    for i in 0..<transformArray.count {
      
      let j = transformArray.count - 1 - i;
      let transformSub = transformArray[i]
      transformSub.layer.anchorPoint = CGPoint(x: 0.5, y: 0)
      if j < 3{
        
        addSubview(transformSub)
        transformSub.alpha = CGFloat(1 - Double(j)*0.4)
        transformSub.frame = CGRect.init(x: (card_width - transformSub.card_width)/2.0,
                                          y: CGFloat(cardAnimationDistance*j),
                                            width: transformSub.card_width,
                                            height:transformSub.card_height)
//        transformSub.center
        transformSub.transform = CGAffineTransform.init(scaleX: CGFloat(1 - Double(j)*cardAnimationScale), y: CGFloat(1 - Double(j)*cardAnimationScale))
        
      }else{
        
        addSubview(transformSub)
        
        transformSub.alpha = 0.2
        transformSub.frame = CGRect.init(x: (card_width - transformSub.card_width)/2.0,
                                         y: CGFloat(cardAnimationDistance * 2),
                                         width: transformSub.card_width,
                                         height:transformSub.card_height)
        transformSub.transform = CGAffineTransform.init(scaleX: CGFloat(1 - cardAnimationScale * 2), y: CGFloat(1 - cardAnimationScale * 2))

      }
    }
    
    transformArray = transformArray.reversed()
    
    upGes = UISwipeGestureRecognizer.init(target: self, action: #selector(upGesSelector))
    upGes?.direction = .up
    addGestureRecognizer(upGes!)
    
    downGes = UISwipeGestureRecognizer.init(target: self, action: #selector(downGesSelector))
    downGes?.direction = .down
    addGestureRecognizer(downGes!)
    
    
  }
  
  @objc func downGesSelector(){
    
    previousAnimation()
    
  }
  
  @objc func upGesSelector() {
  
    nextAnimation()
    
  }
  
  @objc func nextAnimation() {
    
    if isAnimation {
      return
    }
    isAnimation = true
    
    var transformView:UIView?
    var nextTransformView:UIView?
    var nextLocation:Int = 0
    var currentLocation:Int = 0
    
    //寻找当前第一个alpha不为0的控件 也就是当前控件
    for i in 0..<transformArray.count {
      
      let lable = transformArray[i]
      if lable.alpha != 0{
        transformView = lable
        currentLocation = i
        if i != self.transformArray.count - 1{
          nextTransformView = transformArray[i + 1]
          nextLocation = i + 1
        }
        break
      }
      
    }
    
    if nextTransformView == nil {
      isAnimation = false
      return
    }
    
    delegate?.CardAnimationShouldWill(with: self.transformArray)
    // 当前控件向下移动五个像素
    UIView.animate(withDuration: 0.25, animations: {
      
      transformView?.card_y = (transformView?.card_y)! + 5
      
    }) { (flag) in
      
      
      // 然后向上移动 并且 3d变换
      UIView.animate(withDuration: 0.25 * 2, animations: {
        
        transformView?.card_y = (transformView?.card_y)! - 75
        var form1 = CATransform3DIdentity
        form1.m34 = -1/900
        form1 = CATransform3DRotate(form1, CGFloat(30*Double.pi / 180), 1, 0, 0)
        transformView!.layer.transform = form1
        transformView!.alpha = 0;
        
      }) { (flag) in
        
        if self.isNeedRemove{
          self.transformArray.remove(at: currentLocation)
          self.isNeedRemove = false
        }
        self.isAnimation = false
        self.delegate?.CardAnimationViewFinish(with: self.transformArray, currentSub: nextTransformView!)
      }
      
      // 下一控件 复原，下下个控件 变为0.6并且缩放
      UIView.animate(withDuration: 0.25 * 2, animations: {
        
        nextTransformView?.alpha = 1
        nextTransformView?.transform = CGAffineTransform.init(scaleX: 1, y: 1)
        nextTransformView?.card_y = (nextTransformView?.card_y)! - CGFloat(self.cardAnimationDistance)
        
        if nextLocation != self.transformArray.count - 1{
          
          let lable = self.transformArray[nextLocation + 1]
          lable.transform = CGAffineTransform.init(scaleX: 0.97, y: 0.97)
          lable.card_y = lable.card_y - CGFloat(self.cardAnimationDistance)
          lable.alpha = 0.6
          
        }
        
      }, completion: { (flag) in
        
        self.isAnimation = false
        
      })
    }
    
  }
  
  func previousAnimation() {
    
    if isAnimation {
      return
    }
    isAnimation = true
    var previous:UIView?
    var previousLocation:Int = 0
    var current:UIView?
    // 做完动画控价alpha肯定 为0.所以要寻找 第一个不为0的空间站 也就是当前控件
    for i in 0..<self.transformArray.count {
      
      let lable = self.transformArray[i]
      if lable.alpha != 0{
        current = lable
        if i != 0{
          previous = self.transformArray[i-1]
          previousLocation = i - 1
        }
        break
      }
      
    }
    
    if previous == nil {
      isAnimation = false
      return
    }
    
    delegate?.CardAnimationShouldWill(with: self.transformArray)
    // 上一个 动画的复原
    UIView.animate(withDuration: 2*0.25, animations: {
      
      var form1 = CATransform3DIdentity
      form1.m34 = -1/900
      form1 = CATransform3DRotate(form1, CGFloat(0*Double.pi / 180), 1, 0, 0)
      previous!.layer.transform = form1
      previous!.alpha = 1
      
      previous?.card_y = (previous?.card_y)! + 75
      
    }) { (flag) in
      
      UIView.animate(withDuration: 0.1, animations: {
        
        previous?.card_y = (previous?.card_y)! - 5
        
      }, completion: { (flag) in
        
        self.isAnimation = false
        self.delegate?.CardAnimationViewFinish(with: self.transformArray, currentSub: previous!)
      })
      
    }
    
    // 当前动画的 透明质变为 0.6
    UIView.animate(withDuration: 2*0.25, animations: {
      
      current?.alpha = 0.6
      
      current?.card_y = (current?.card_y)! + CGFloat(self.cardAnimationDistance)
      current?.transform = CGAffineTransform.init(scaleX: 0.97, y: 0.97)
      
      //// 下一个控件动画的 透明质变为 0.2
      if previousLocation + 2 >= self.transformArray.count{
        return
      }
      let lable = self.transformArray[previousLocation + 2]
      lable.alpha = 0.2
      lable.transform = CGAffineTransform.init(scaleX: 0.94, y: 0.94)
      lable.card_y = lable.card_y + CGFloat(self.cardAnimationDistance)
      
    }, completion: nil)
    

    
  }
  
  func deleteCurrentAnimation() {
    
    
    
    let isLast = self.transformArray.last!.alpha == 1
    
    // 如果是最后一个控件，并且控件个数大于2 ，将前一个控件复原到当前位置，然后把当前控件移除
    if isLast && self.transformArray.count > 1 {
      
      if isAnimation{
        return
      }
      isAnimation = true
      delegate?.CardAnimationShouldWill(with: self.transformArray)
      
      let pre = self.transformArray[self.transformArray.count - 2]
      var form1 = CATransform3DIdentity
      form1.m34 = -1/900
      form1 = CATransform3DRotate(form1, CGFloat(0*Double.pi / 180), 1, 0, 0)
      pre.layer.transform = form1
      pre.frame = self.transformArray.last!.frame
      
      UIView.animate(withDuration: 0.25, animations: {
        pre.alpha = 1
        self.transformArray.last!.alpha = 0
        
        self.delegate?.CardAnimationViewFinish(with: self.transformArray, currentSub: pre)
      }) { (flag) in
        
        self.transformArray.removeLast()
        self.isAnimation = false
      }
      
    }else{
      self.isNeedRemove = true
      self.nextAnimation()
    }
    
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  

}
