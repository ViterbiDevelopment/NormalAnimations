//
//  PopAnimation.swift
//  NormalAnimations
//
//  Created by 掌上先机 on 17/1/9.
//  Copyright © 2017年 wangchao. All rights reserved.
//

import UIKit

class PopAnimation: NSObject,UIViewControllerAnimatedTransitioning {

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    
        return 0.3
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
        let fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)
        transitionContext.containerView.insertSubview((toViewController?.view)!, belowSubview: (fromViewController?.view)!)
        
        var frame = fromViewController?.view.frame
        
        frame?.origin.x = (frame?.origin.x)! + (frame?.size.width)!
        
        UIView.animate(withDuration: self.transitionDuration(using: transitionContext), animations: {
            
            fromViewController?.view.frame = frame!

            toViewController?.view.transform = CGAffineTransform.identity
            
            
        }) { (finish) in
         
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            
        }
    }
    
}
