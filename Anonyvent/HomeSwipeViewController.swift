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
        navigationBarShouldNotExist = false
        datasource = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.whiteColor()
    }
}

extension HomeSwipeViewController: EZSwipeControllerDataSource {
    func viewControllerData() -> [UIViewController] {
        let eventsHomevc : UIViewController! = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("eventsHome") as UIViewController
        self.presentViewController(eventsHomevc, animated: false, completion: nil)
        
        let mapHomevc : UIViewController! = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("mapView") as UIViewController
        self.presentViewController(eventsHomevc, animated: false, completion: nil)
        
        let myEvents : UIViewController! = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("myEvents") as UIViewController
        self.presentViewController(myEvents, animated: false, completion: nil)
        
        return [eventsHomevc, mapHomevc, myEvents]
    }
    
    func titlesForPages() -> [String] {
        return ["Events", "Map", "Settings"]
    }
    
    func indexOfStartingPage() -> Int {
        return 1 // EZSwipeController starts from 2nd, green page
    }
}