//
//  CreateEventViewController.swift
//  Anonyvent
//
//  Created by Evan Kohout on 11/1/15.
//  Copyright © 2015 Evan Kohout. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class CreateEventViewController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate {
    
    
    @IBOutlet weak var eventTitle: UITextField!
    @IBOutlet weak var eventDescription: UITextField!
    @IBOutlet weak var eventDateSelector: UIDatePicker!
    @IBOutlet weak var postButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    
    var event: Event?
    var newEvent = [String: String]()
    //var randoIcon = EventIcons.randomIcon
    //var newSession = httpConnectionHandler
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        //Handle the text fields user input through the delegate callbacks
        eventTitle.delegate = self
        
        if let event = event {
            
            navigationItem.title = event.title
            eventTitle.text = event.title
            eventDescription.text = event.description
            eventDateSelector.date = event.date
            
        }
        
        // Enable the Post button only if the text field has a valid Event name
        checkValidEventName()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    // MARK: - Navigation
    
    @IBAction func cancelButton(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    //MARK - UITextFieldDelegate
    
    func textFieldDidBeginEditing(textField: UITextField) {
        postButton.enabled = false
    }
    
    func checkValidEventName() {
        let text = eventTitle.text ?? ""
        postButton.enabled = !text.isEmpty
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        checkValidEventName()
        navigationItem.title = eventTitle.text
    }
    
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if postButton === sender {
            let title = eventTitle.text ?? ""
            let description = eventDescription.text ?? ""
            let date = eventDateSelector.date
            let UDIDset = UIDevice.currentDevice().identifierForVendor!.UUIDString
            
            //current time for record creation timestamp
            let currentDateTime = NSDate()
            let formatter = NSDateFormatter()
            formatter.dateStyle = NSDateFormatterStyle.ShortStyle
            formatter.timeStyle = NSDateFormatterStyle.ShortStyle
            let creationTimestamp = formatter.stringFromDate(currentDateTime)
            print(creationTimestamp)
            
            
            //rando number get
            let unsignedArrayCount = UInt32(10000000)
            let unsignedRandomNumber = arc4random_uniform(unsignedArrayCount)
            let randomNumber = Int(unsignedRandomNumber)
            
            //creates new event dict
            newEvent = ["id": String(randomNumber), "title": title, "name": "\(title)-\(randomNumber)", "description": description, "startDate": String(date), "UDID": UDIDset, "timestamp": creationTimestamp, "eventStatus": "\(EventStatus.Active)"]
            //creates event object
            //event = Event(title: name, date: date, description: description, icon: randoIcon.randomIcon())

            Alamofire.request(.POST, "https://ebox86-test.apigee.net/anonyvent/event", parameters: newEvent, encoding: .JSON)
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    
}
