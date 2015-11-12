//
//  SettingsViewController.swift
//  Anonyvent
//
//  Created by Evan Kohout on 11/2/15.
//  Copyright © 2015 Evan Kohout. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    var sampleData = EventTableViewController()
    
    @IBOutlet weak var clearArray: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func clearData(sender: UIButton) {
        //sampleData.events.removeAll()
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
