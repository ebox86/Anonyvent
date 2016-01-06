//
//  HomeSwipeViewController.swift
//  Anonyvent
//
//  Created by Evan Kohout on 1/5/16.
//  Copyright © 2016 Evan Kohout. All rights reserved.
//

import UIKit
import EZSwipeController

class HomeSwipeViewController: EZSwipeController {
    override func setupView() {
        datasource = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.whiteColor()
    }
}

extension HomeSwipeViewController: EZSwipeControllerDataSource {
    func viewControllerData() -> [UIViewController] {
        let redVC = UIViewController()
        redVC.view.backgroundColor = UIColor.redColor()
        
        let blueVC = UIViewController()
        blueVC.view.backgroundColor = UIColor.blueColor()
        
        let greenVC = UIViewController()
        greenVC.view.backgroundColor = UIColor.greenColor()
        
        return [redVC, blueVC, greenVC]
    }
}