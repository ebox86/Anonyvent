//
//  DetailViewController.swift
//  Anonyvent
//
//  Created by Evan Kohout on 12/17/15.
//  Copyright © 2015 Evan Kohout. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController,  UITextFieldDelegate, UITableViewDelegate {


//    @IBOutlet weak var eventStartDateLabel: UILabel!
//    @IBOutlet weak var eventTitleLabel: UILabel!
//    @IBOutlet weak var eventDescriptionLabel: UITextView!
//    @IBOutlet weak var lastModified: UILabel!
//    @IBOutlet weak var openMapButton: UIButton!
    @IBOutlet weak var tableView: UITableView!


    var eventTitle : String!
    var eventStartDate : String!
    var eventDescription : String!
    var authorUDID : String!
    var uuid : String!
    var eventStatus : String?
    var postId : Int?
    var created : String?
    var modified : String?
    
    let currentDeviceUDID = UIDevice.currentDevice().identifierForVendor!.UUIDString
    
    var editButton: UIBarButtonItem!
    var ownerFlag = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
/*
        self.openMapButton.backgroundColor = UIColor.lightGrayColor()
        self.openMapButton.tintColor = UIColor.whiteColor()
        
        self.eventTitleLabel.text = eventTitle
        self.eventDescriptionLabel.text = eventDescription
        self.eventStartDateLabel.text = eventStartDate
        self.eventTitleLabel.numberOfLines = 2
*/
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
        /*
        //Set up date and time formats
        let formatter = NSDateFormatter()
        let timeZone = NSTimeZone(name: "UTC")
        formatter.timeZone = timeZone
        formatter.locale = NSLocale.currentLocale()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        //formatter.formatterBehavior = NSDateFormatterBehavior.BehaviorDefault

        //current time for record creation timestamp
        let currentDateTime = NSDate()
        */
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
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == 0 || indexPath.row == 1{
            let cell = self.tableView.dequeueReusableCellWithIdentifier("section1", forIndexPath: indexPath) as! EventsDetailTableViewCell
            self.tableView.rowHeight = 500
            cell.eventNameLabel.text = eventTitle
            print(eventTitle)
            cell.eventDescription.text = eventDescription
            if (modified != created) {
                /*
                print(eventLastModified!)
                let date1 = currentDateTime
                let date2 = formatter.dateFromString(eventLastModified!)
                
                let compareTimestamps = date1.compare(date2!)
                let interval : NSTimeInterval = date1.timeIntervalSinceDate(date2!)
                */
                cell.lastModifiedLabel.text = "last modified \(modified!)"
            } else {
                cell.lastModifiedLabel.text = ""
            }

            return cell
            
        } else {
            
            let cell = self.tableView.dequeueReusableCellWithIdentifier("section2", forIndexPath: indexPath) as! CommentTableViewCell
            self.tableView.rowHeight = 60
            cell.commentLabel.text = "Static Test Comment"
            return cell
        }
        
    }
    
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "editEventSegue")
        {
            let viewController = segue.destinationViewController as! CreateEventViewController
            viewController.editTitle = eventTitle
            viewController.editDescrip = eventDescription
            viewController.eventStartDate = eventStartDate
            viewController.udid = authorUDID
            viewController.uuid = uuid
            viewController.eventStatus = eventStatus
            viewController.eventCreatedTimestamp = created
            viewController.postId = postId
            viewController.editFlag = true
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
