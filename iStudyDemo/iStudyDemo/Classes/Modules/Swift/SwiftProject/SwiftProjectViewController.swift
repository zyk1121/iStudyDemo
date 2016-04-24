//
//  SwiftProjectViewController.swift
//  iStudyDemo
//
//  Created by zhangyuanke on 16/4/24.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

import Foundation
import UIKit


class SwiftProjectTableView: UIViewController {
    
    lazy var box = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        
        box.backgroundColor = UIColor.redColor()
        self.view.addSubview(box)
        
        box.snp_makeConstraints { (make) -> Void in
            make.width.height.equalTo(50)
            make.center.equalTo(self.view)
        }
    }
}