//
//  PushAnimation.swift
//  NormalAnimations
//
//  Created by 掌上先机 on 17/1/9.
//  Copyright © 2017年 wangchao. All rights reserved.
//

import UIKit

class PushAnimation: NSObject,UIViewControllerAnimatedTransitioning {
    
    var context:UIViewControllerContextTransitioning!
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        context = transitionContext
        
        
        let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
        let fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)
        transitionContext.containerView.addSubview((toViewController?.view)!)
        
        var frame = fromViewController?.view.frame
        let originRect = frame
        
        frame?.origin.x = (frame?.origin.x)! + (frame?.size.width)!
        toViewController?.view.frame = frame!
        
        UIView.animate(withDuration: self.transitionDuration(using: transitionContext), animations: { 
            
            fromViewController?.view.transform = CGAffineTransform.init(scaleX: 0.9, y: 0.9)
            toViewController?.view.frame = originRect!
            
        }) { (finish) in
            
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
        
        
    }

}
