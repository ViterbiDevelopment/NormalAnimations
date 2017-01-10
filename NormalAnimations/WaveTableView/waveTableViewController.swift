//
//  waveTableViewController.swift
//  NormalAnimations
//
//  Created by 掌上先机 on 17/1/10.
//  Copyright © 2017年 wangchao. All rights reserved.
//

import UIKit

class waveTableViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    var tabelView:UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        view.backgroundColor = UIColor.groupTableViewBackground
    
        configueRightItem()
    
        tabelView = UITableView.init(frame: view.bounds)
        
        tabelView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "cell")
        tabelView.tableFooterView = UIView()
        
        tabelView.delegate = self
        tabelView.dataSource = self
        
        view.addSubview(tabelView)
        
        
    }
    
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tabelView.dequeueReusableCell(withIdentifier: "cell")
        
        cell?.backgroundColor = UIColor.red
        cell?.textLabel?.text = "我是cell"
        
        return cell!
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 5;
    }
    
    
    
    func configueRightItem() {
        
        let rightItemBtn = UIButton.init(type: .system)
        
        rightItemBtn.bounds = CGRect(x: 0, y: 0, width: 80, height: 40)
        
        rightItemBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        
        rightItemBtn.setTitle("点我动画", for: .normal)
        
        rightItemBtn.addTarget(self, action: #selector(btnClick), for: .touchUpInside)
        
        
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: rightItemBtn)
        
    }
    
    func btnClick()  {
        
        tabelView.reloadTableViewWithAnimation(type: .LeftToRightAnimation)
    }
    
    
    deinit {
        
        print("我释放了")
    }
    
}


extension UITableView{


    enum animationCellDistance:Int {
        case cellDistance = 2
    }
    
    enum animationType:Int {
        case LeftToRightAnimation = -1
        case RightToLeftAnimation = 1
    }
    
    func reloadTableViewWithAnimation(type:animationType)  {
        
        UIView.animate(withDuration: 0.3, animations: { 
            
            self.isHidden = true
            
        }) { (finish) in
            
            self.isHidden = false
            
            self.cellBeginAnimation(type: type)
        }
       
    }
    
    
    func cellBeginAnimation(type:animationType)  {
        
        
        let indexPathArray = self.indexPathsForVisibleRows
        
        for i in 0..<indexPathArray!.count{
        
            let indexPath = indexPathArray![i]
            
            let cell = self.cellForRow(at: indexPath)
            cell?.isHidden = true
            
            let pathAndType = [indexPath,type] as [Any]
            
            perform(#selector(animationStar(array:)), with: pathAndType, afterDelay: (0.1 * Double(i + 1)))
        }
        
        
    }
    
    func animationStar(array:[Any]) {
        
        let path = array.first as! IndexPath
        
        let type = array[1] as! animationType
        
        
        let cell = cellForRow(at: path)

        let originPoint = cell!.center
        
        let centerX = type.rawValue == -1 ? 0:type.rawValue
        
        cell?.center = CGPoint(x: CGFloat((cell?.frame.width)! * CGFloat(centerX)) , y: originPoint.y)
        
        cell?.isHidden = false
        
        UIView.animate(withDuration: 0.4, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: { 
            
            cell?.center = CGPoint(x: originPoint.x - CGFloat(type.rawValue * animationCellDistance.cellDistance.rawValue), y: originPoint.y)
            cell?.isHidden = false
            
        }) { (finish) in
            
            
            UIView.animate(withDuration: 0.1, delay: 0, options: UIViewAnimationOptions.curveEaseIn, animations: { 
                
                cell?.center = CGPoint(x: originPoint.x - CGFloat(type.rawValue*animationCellDistance.cellDistance.rawValue), y: originPoint.y)
                
            }, completion: { (finish) in
                
                UIView.animate(withDuration: 0.1, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                    
                      cell?.center = CGPoint(x: originPoint.x + CGFloat(type.rawValue*animationCellDistance.cellDistance.rawValue), y: originPoint.y)
                    
                }, completion: { (finishOne) in
                    
                    
                    UIView.animate(withDuration: 0.1, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: { 
                        
                        cell?.center = originPoint
                        
                    }, completion: nil)
                    
                })
                
            })
            
        }
        
    }
    
    
}

