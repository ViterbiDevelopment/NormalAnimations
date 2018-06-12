//
//  ViewController.swift
//  NormalAnimations
//
//  Created by 掌上先机 on 17/1/6.
//  Copyright © 2017年 wangchao. All rights reserved.
//

import UIKit


class ViewController: UITableViewController {
  
    enum CellIndetifier:String {
        case cell
    }

    let animations = ["CATransform3D","UIViewControllerAnimatedTransitioning","wave TableView","CardViewAnimationController"]
  
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.groupTableViewBackground
        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: CellIndetifier.cell.rawValue)
        tableView.tableFooterView = UIView()
    }
  
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIndetifier.cell.rawValue, for: indexPath)
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.text = animations[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return animations.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 0 {
            let transformVC = TransformviewController()
            navigationController?.pushViewController(transformVC, animated: true)
        }
        if indexPath.row == 1{
            let transformVC = VCAnimatedTransitioning()
            navigationController?.pushViewController(transformVC, animated: true)
        }
        if indexPath.row == 2 {
            let waveTB = waveTableViewController()
            navigationController?.pushViewController(waveTB, animated: true)
        }
        if indexPath.row == 3 {
            let cardVC = CardViewAnimationController()
            navigationController?.pushViewController(cardVC, animated: true)
        }
    }
}

