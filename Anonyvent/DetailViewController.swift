//
//  DetailViewController.swift
//  Anonyvent
//
//  Created by Evan Kohout on 12/17/15.
//  Copyright © 2015 Evan Kohout. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController,  UITextFieldDelegate, UINavigationControllerDelegate {


    @IBOutlet weak var eventStartDateLabel: UILabel!
    @IBOutlet weak var done: UIBarButtonItem!
    @IBOutlet weak var eventTitleLabel: UILabel!
    var eventTitle : String!
    var eventStartDate : String!
    var eventDescription : String!
    var authorUDID : String!
    var uuid : String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.eventTitleLabel.text = eventTitle
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation
    
    
    @IBAction func done(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    /*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
