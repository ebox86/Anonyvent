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
    @IBOutlet weak var eventTitleLabel: UILabel!
    @IBOutlet weak var eventDescriptionLabel: UITextView!


    var eventTitle : String!
    var eventStartDate : String!
    var eventDescription : String!
    var authorUDID : String!
    var uuid : String!
    var eventStatus : String?
    var postId : Int?
    var eventCreatedTimestamp : String?
    
    let currentDeviceUDID = UIDevice.currentDevice().identifierForVendor!.UUIDString
    
    var editButton: UIBarButtonItem!
    var ownerFlag = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.eventTitleLabel.text = eventTitle
        self.eventDescriptionLabel.text = eventDescription
        self.eventStartDateLabel.text = eventStartDate
        print("\(currentDeviceUDID) - current")
        print(authorUDID)
        editButton = UIBarButtonItem(title: "Edit", style: UIBarButtonItemStyle.Plain, target: self, action: "buttonAction")
        if (authorUDID == currentDeviceUDID) {
            print("I AM OWNER!")
            navigationItem.rightBarButtonItems = [editButton]
            ownerFlag = true
            print(ownerFlag)
        } else {
            ownerFlag = false
            navigationItem.rightBarButtonItems = []
            print(ownerFlag)
        }
        // Do any additional setup after loading the view.
        
    }
    
    @IBAction func hide(sender: AnyObject) {
        if(ownerFlag == true) {
            navigationItem.rightBarButtonItems = []
            ownerFlag = false
        } else {
            navigationItem.rightBarButtonItems = [editButton]
            ownerFlag = true
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func buttonAction(){
        self.performSegueWithIdentifier("editEventSegue", sender: editButton)
    }
    
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "editEventSegue")
        {
            let viewController = segue.destinationViewController as! CreateEventViewController
            //var viewController: DetailViewController = segue.destinationViewController as! DetailViewController
            //let indexPath = eventsTableViewNew2!.indexPathForCell(sender as! UITableViewCell)
            //let viewEvents = self.events![indexPath!.row]
            viewController.editTitle = eventTitle
            viewController.editDescrip = eventDescription
            viewController.eventStartDate = eventStartDate
            viewController.udid = authorUDID
            viewController.uuid = uuid
            viewController.eventStatus = eventStatus
            viewController.eventCreatedTimestamp = eventCreatedTimestamp
            viewController.postId = postId
            viewController.editFlag = true
            
            //let cell = eventsTableViewNew2!.cellForRowAtIndexPath(indexPath!)
            //let eventTitleToPass = cell?.textLabel?.text
            //viewController.eventTitleLabel.text = eventTitleToPass
            //self.navigationController?.pushViewController(viewController, animated: true)
        }
    }

    
    /*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
