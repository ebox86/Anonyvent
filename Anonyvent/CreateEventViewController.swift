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
import QuartzCore

class CreateEventViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate, UINavigationControllerDelegate {
    
    
    @IBOutlet weak var eventTitle: UITextField!
    @IBOutlet weak var eventDescription: UITextView!
    @IBOutlet weak var eventDateSelector: UIDatePicker!
    @IBOutlet weak var postButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var charCounter: UILabel!
    
    var keyboardDismissTapGesture: UIGestureRecognizer?
    var newEvent = [String: AnyObject]()
    //var randoIcon = EventIcons.randomIcon
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        eventDescription.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0).CGColor
        eventDescription.text = "Description"
        eventDescription.textColor = UIColor.lightGrayColor()
        eventTitle.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0)
        
        //Handle the text fields user input through the delegate callbacks
        self.charCounter.text = "40"
        eventTitle.delegate = self
        eventDescription.delegate = self
        
        self.view.addSubview(eventTitle!)
        self.view.addSubview(eventDescription!)
        // Enable the Post button only if the text field has a valid Event name
        checkValidEventName()
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        var newLength = 40
        newLength = textField.text!.utf16.count + string.utf16.count - range.length
        if(newLength <= 40){
            self.charCounter.text = "\(40 - newLength)"
            return true
        }else{
            return false
        }
    }
    
    // resign keyboard for eventTitle TextField on 'done'
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        eventTitle.resignFirstResponder()
        return true
    }
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: Selector("keyboardWillShow:"),
            name: UIKeyboardWillShowNotification,
            object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: Selector("keyboardWillHide:"),
            name: UIKeyboardWillHideNotification,
            object: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self)
        
        super.viewWillDisappear(animated)
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
    
    func keyboardWillShow(notification: NSNotification) {
        if keyboardDismissTapGesture == nil
        {
            keyboardDismissTapGesture = UITapGestureRecognizer(target: self, action: Selector("dismissKeyboard:"))
            self.view.addGestureRecognizer(keyboardDismissTapGesture!)
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if keyboardDismissTapGesture != nil
        {
            self.view.removeGestureRecognizer(keyboardDismissTapGesture!)
            keyboardDismissTapGesture = nil
        }
    }
    
    func dismissKeyboard(sender: AnyObject) {
        eventTitle?.resignFirstResponder()
        eventDescription?.resignFirstResponder()
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        postButton.enabled = false
    }
    
    func checkValidEventName() {
        let text = eventTitle.text ?? ""
        postButton.enabled = !text.isEmpty
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        checkValidEventName()
        //navigationItem.title = eventTitle.text
    }
    
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if postButton === sender {
            //Set up date and time formats
            let formatter = NSDateFormatter()
            formatter.dateStyle = NSDateFormatterStyle.ShortStyle
            formatter.timeStyle = NSDateFormatterStyle.ShortStyle
            
            //constants to grab data from fields
            let name = eventTitle.text ?? ""
            let description = eventDescription.text ?? ""
            let startDate = eventDateSelector.date
            let formattedStartDate = formatter.stringFromDate(startDate)
            let UDIDset = UIDevice.currentDevice().identifierForVendor!.UUIDString
            
            //current time for record creation timestamp
            let currentDateTime = NSDate()
            let creationTimestamp = formatter.stringFromDate(currentDateTime)
            
            //rando number get
            
            let unsignedArrayCount = UInt32(10000000)
            let unsignedRandomNumber = arc4random_uniform(unsignedArrayCount)
            let randomNumber = Int(unsignedRandomNumber)

            
            //creates new event dict
            newEvent = ["id": String(randomNumber), "eventName": name, "description": description, "startDate": String(formattedStartDate), "UDID": UDIDset, "eventTimestamp": String(creationTimestamp), "eventStatus": "\(EventStatus.Active)"/*, "location" : ["latitude" : 123.123, "longitude": 123.456]*/]
            //makes api call
            Alamofire.request(.POST, "https://ebox86-test.apigee.net/anonyvent/event", parameters: newEvent, encoding: .JSON)
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    
}
