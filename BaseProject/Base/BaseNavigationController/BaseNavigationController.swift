//
//  BaseNavigationController.swift
//  Life
//
//  Created by tiens on 2019/6/12.
//  Copyright © 2019 yyy. All rights reserved.
//

import UIKit

class BaseNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBar.barTintColor = UIColor.white
        
        interactivePopGestureRecognizer?.delegate=self
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        
        if children.count > 0{
            
            viewController.hidesBottomBarWhenPushed=true
            viewController.navigationItem.leftBarButtonItem=UIBarButtonItem(image: UIImage(named: "commonBack"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(leftBtnDidClick))
            
        }
        
        super.pushViewController(viewController, animated: animated)
    }
    
    
    @objc func leftBtnDidClick(){
        popViewController(animated: true)
    }
    
    override var childForStatusBarStyle: UIViewController?{
        
        return visibleViewController
    }
}

extension BaseNavigationController:UIGestureRecognizerDelegate{
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return children.count != 1
    }
    
}
