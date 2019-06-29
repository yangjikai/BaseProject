//
//  BaseViewController.swift
//  Life
//
//  Created by tiens on 2019/6/18.
//  Copyright © 2019 yyy. All rights reserved.
//

import UIKit
import SnapKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor.white
        
        addSubViews()
        bindViewModel()
    }
    
    //MARK: - 添加子view
    func addSubViews() {
        
    }
    
    //MARK: - 绑定viewModel
    func bindViewModel() {
        
    }

}
