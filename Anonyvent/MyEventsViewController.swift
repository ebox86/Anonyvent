//
//  SettingsViewController.swift
//  Anonyvent
//
//  Created by Evan Kohout on 11/2/15.
//  Copyright © 2015 Evan Kohout. All rights reserved.
//

import UIKit

class MyEventsViewController: UIViewController {
    
    @IBOutlet weak var udidLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        udidLabel.text = UIDevice.currentDevice().identifierForVendor!.UUIDString.uppercaseString
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
