//
//  CardView.swift
//  cardAnimation
//
//  Created by Viterbi on 2018/6/11.
//  Copyright © 2018年 Viterbi. All rights reserved.
//

import UIKit

private extension UIView{
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
  
}


protocol CardAnimationViewDelegate:class {
  
  // 动画结束
  func CardAnimationViewFinish(with SubviewsArray:[UIView],currentSub:UIView)
  
  //动画开始
  func CardAnimationShouldWill(with SubviewArray:[UIView])
  
  
}

class CardAnimationView: UIView {
  
  enum AnimationSpeedRaw:Double {
    case slow = 0.25
    case fast = 0.15
  }
  
  
  var isNeedRemove:Bool = false
  var transformArray:[UIView]!
  
  var cardAnimationDistance:Int = 50 //每个卡片 等比例距离
  var cardAnimationScale:Double = 0.03 //每个卡片的 等比例缩小系数
  
  var isAnimation:Bool = false //是否正在动画
  var animationSpeed = AnimationSpeedRaw.slow
  
  var upGes:UISwipeGestureRecognizer?
  var downGes:UISwipeGestureRecognizer?
  
  weak var delegate:CardAnimationViewDelegate?
  
  convenience init(frame: CGRect,transfromSubviews:[UIView]!) {
    self.init(frame: frame)
    
    let distance = (frame.height - transfromSubviews.first!.card_height) * 0.5
    
    cardAnimationDistance = Int(CGFloat(cardAnimationScale) * transfromSubviews.first!.card_height + distance)
    
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
  
  func nextAnimation() {
    
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
    UIView.animate(withDuration: animationSpeed.rawValue, animations: {
      
      transformView?.card_y = (transformView?.card_y)! + 5
      
    }) { (flag) in
      
      
      // 然后向上移动 并且 3d变换
      UIView.animate(withDuration: self.animationSpeed.rawValue * 2, animations: {
        
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
      UIView.animate(withDuration: self.animationSpeed.rawValue * 2, animations: {
        
        nextTransformView?.alpha = 1
        nextTransformView?.transform = CGAffineTransform.init(scaleX: 1, y: 1)
        nextTransformView?.card_y = (nextTransformView?.card_y)! - CGFloat(self.cardAnimationDistance)
        
        if nextLocation != self.transformArray.count - 1{
          
          let lable = self.transformArray[nextLocation + 1]
          lable.transform = CGAffineTransform.init(scaleX: CGFloat(1-self.cardAnimationScale), y: CGFloat(1-self.cardAnimationScale))
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
    UIView.animate(withDuration: 2*animationSpeed.rawValue, animations: {
      
      var form1 = CATransform3DIdentity
      form1.m34 = -1/900
      form1 = CATransform3DRotate(form1, CGFloat(0*Double.pi / 180), 1, 0, 0)
      previous!.layer.transform = form1
      previous!.alpha = 1
      
      previous?.card_y = (previous?.card_y)! + 75
      
    }) { (flag) in
      
      UIView.animate(withDuration: self.animationSpeed.rawValue, animations: {
        
        previous?.card_y = (previous?.card_y)! - 5
        
      }, completion: { (flag) in
        
        self.isAnimation = false
        self.delegate?.CardAnimationViewFinish(with: self.transformArray, currentSub: previous!)
      })
      
    }
    
    // 当前动画的 透明质变为 0.6
    UIView.animate(withDuration: 2*animationSpeed.rawValue, animations: {
      
      current?.alpha = 0.6
      
      current?.card_y = (current?.card_y)! + CGFloat(self.cardAnimationDistance)
      current?.transform = CGAffineTransform.init(scaleX: CGFloat(1-self.cardAnimationScale), y: CGFloat(1-self.cardAnimationScale))
      
      //// 下一个控件动画的 透明质变为 0.2
      if previousLocation + 2 >= self.transformArray.count{
        return
      }
      let lable = self.transformArray[previousLocation + 2]
      lable.alpha = 0.2
      lable.transform = CGAffineTransform.init(scaleX: CGFloat(1-2*self.cardAnimationScale), y: CGFloat(1-2*self.cardAnimationScale))
      lable.card_y = lable.card_y + CGFloat(self.cardAnimationDistance)
      
    }, completion: nil)
    
    
    
  }
  
  //跳转到索引值的界面
  func jumpAnimation(with index:Int) {
    
    
    if index > self.transformArray.count - 1{
      return
    }
    
    var currentIndex = 0
    for i in 0..<self.transformArray.count {
      
      let sub = self.transformArray[i]
      if sub.alpha == 1.0{
        currentIndex = i
        break
      }
    }
    
    if currentIndex == index{
      return
    }
    
    if currentIndex - index == 1 {
      previousAnimation()
      return
    }
    if index - currentIndex == 1 {
      nextAnimation()
      return
    }
    
    if isAnimation {
      return
    }
    isAnimation = true
    
    var isNext = false
    
    //当前页面索引 大于 需要跳转的页面 往前饭
    if currentIndex > index {
      
      isNext = false
      
      for i in (index + 1)..<self.transformArray.count{
        
        let sub = self.transformArray[i]
        if sub.alpha != 0.2{
          var form1 = CATransform3DIdentity
          form1.m34 = -1/900
          form1 = CATransform3DRotate(form1, 0, 1, 0, 0)
          sub.layer.transform = form1
          
          sub.transform = CGAffineTransform.init(scaleX: CGFloat(1-2*self.cardAnimationScale), y: CGFloat(1-2*self.cardAnimationScale))
          sub.card_y = CGFloat(2*self.cardAnimationDistance)
          sub.alpha = 0.2
        }
      }
      
    }else{
      
      isNext = true
      
      for i in 0..<index{
        let sub = self.transformArray[i]
        if sub.alpha != 0{
          sub.alpha = 0
          sub.card_y = -75
          sub.transform = CGAffineTransform.init(scaleX: 1, y: 1)
          var form1 = CATransform3DIdentity
          form1.m34 = -1/900
          form1 = CATransform3DRotate(form1, CGFloat(30*Double.pi / 180), 1, 0, 0)
          sub.layer.transform = form1
        }
        
      }
      
    }
    
    //跳转到当前页
    let currentView = self.transformArray[index]
    
    delegate?.CardAnimationShouldWill(with: self.transformArray)
    
    UIView.animate(withDuration: 2*animationSpeed.rawValue, animations: {
      
      if !isNext{
        var form1 = CATransform3DIdentity
        form1.m34 = -1/900
        form1 = CATransform3DRotate(form1, 0, 1, 0, 0)
        currentView.layer.transform = form1
      }
      
      currentView.transform = CGAffineTransform.init(scaleX: 1, y: 1)
      currentView.card_y = 0
      currentView.alpha = 1
      
    }) { (flag) in
      
      self.isAnimation = false
      self.delegate?.CardAnimationViewFinish(with: self.transformArray, currentSub: currentView)
    }
    
    if index + 1 > self.transformArray.count - 1 {
      return
    }
    
    let nextView = self.transformArray[index + 1]
    
    UIView.animate(withDuration: 2*animationSpeed.rawValue) {
      
      if !isNext{
        var form1 = CATransform3DIdentity
        form1.m34 = -1/900
        form1 = CATransform3DRotate(form1, 0, 1, 0, 0)
        nextView.layer.transform = form1
      }
      nextView.transform = CGAffineTransform.init(scaleX: CGFloat(1-self.cardAnimationScale), y: CGFloat(1-self.cardAnimationScale))
      nextView.card_y = CGFloat(self.cardAnimationDistance)
      nextView.alpha = 0.6
    }
    
    if index + 2 > self.transformArray.count - 1{
      return
    }
    
    let nextnextView = self.transformArray[index + 2]
    UIView.animate(withDuration: 2*animationSpeed.rawValue) {
      
      if !isNext{
        var form1 = CATransform3DIdentity
        form1.m34 = -1/900
        form1 = CATransform3DRotate(form1, 0, 1, 0, 0)
        nextnextView.layer.transform = form1
        
      }
      nextnextView.transform = CGAffineTransform.init(scaleX: CGFloat(1-2*self.cardAnimationScale), y: CGFloat(1-2*self.cardAnimationScale))
      nextnextView.card_y = CGFloat(2*self.cardAnimationDistance)
      nextnextView.alpha = 0.2
    }
    
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
      
      UIView.animate(withDuration: animationSpeed.rawValue, animations: {
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
