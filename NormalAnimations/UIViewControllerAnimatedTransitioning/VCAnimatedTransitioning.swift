//
//  VcAnimatedTransitioning.swift
//  NormalAnimations
//
//  Created by 掌上先机 on 17/1/8.
//  Copyright © 2017年 wangchao. All rights reserved.
//

import UIKit

class VCAnimatedTransitioning: UIViewController,UINavigationControllerDelegate,UIGestureRecognizerDelegate {
    
    var interactionController:UIPercentDrivenInteractiveTransition!
    
    var pan : UIPanGestureRecognizer!

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.groupTableViewBackground
        navigationController?.delegate = self
        configureBtn()
        configureGesture()
    }
    
    func configureGesture() {
        
        //handleSwipeFromLeftEdge
        
        pan = UIPanGestureRecognizer.init(target: self, action: #selector(handleSwipeFromLeftEdge(gesture:)))
        pan.delegate = self
        navigationController?.view.addGestureRecognizer(pan)
    }
    

    func configureBtn()  {
        
        let click = UIButton.init(type: .system)
        click.bounds = CGRect(x: 0, y: 0, width: 100, height: 100)
        
        click.center = CGPoint(x: self.view.center.x, y: 180)
        
        click.backgroundColor = UIColor.red
        
        click.addTarget(self, action: #selector(btnClick(sender:)), for: UIControlEvents.touchUpInside)
        click.setTitle("点我", for: .normal)
        view.addSubview(click)

    }
    
    func handleSwipeFromLeftEdge(gesture:UIScreenEdgePanGestureRecognizer)  {
        
        let translate = gesture.translation(in: UIApplication.shared.windows.last)
        
        let percent = translate.x / UIScreen.main.bounds.width
        
        if gesture.state == UIGestureRecognizerState.began {
            
            interactionController = UIPercentDrivenInteractiveTransition.init()
            
           let _  = navigationController?.popViewController(animated: true)
        }
        else if gesture.state == UIGestureRecognizerState.changed {
            
            interactionController.update(percent)
            
        }else if gesture.state == UIGestureRecognizerState.ended{
        
            let velocity = gesture.velocity(in: gesture.view)
            
            if velocity.x > 0 {
                
                interactionController.finish()
            }
            else{
            
                interactionController.cancel()
            }
            
            interactionController = nil
        }
    }
    
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning?{
    
        if operation == UINavigationControllerOperation.push {
            return PushAnimation()
        }
        
        if operation == UINavigationControllerOperation.pop {
            return PopAnimation()
        }
        return nil
    }
    
    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        
        return interactionController
    }
  
    func btnClick(sender:UIButton){
        let push = pushVC()
        navigationController?.pushViewController(push, animated: true)
    }
    
    deinit {
      
        navigationController?.delegate = nil
        pan.removeTarget(self, action: #selector(handleSwipeFromLeftEdge(gesture:)))
        pan = nil
    }
    
    


}
