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
import BRYXBanner
import MapKit
import CoreLocation

class CreateEventViewController: UIViewController, UITextFieldDelegate, CLLocationManagerDelegate, MKMapViewDelegate, UITextViewDelegate, UINavigationControllerDelegate {
    
    
    @IBOutlet weak var eventTitle: UITextField!
    @IBOutlet weak var eventDescription: UITextView!
    @IBOutlet weak var eventDateSelector: UIDatePicker!
    @IBOutlet weak var postButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var charCounter: UILabel!
    @IBOutlet weak var charCounter2: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var deleteEventButton: UIButton!

    var keyboardDismissTapGesture: UIGestureRecognizer?

    var eventRequest = [String: AnyObject]()
    //var randoIcon = EventIcons.randomIcon
    var editFlag = false
    var postId : Int?
    var eventStartDate : String?
    var eventCreatedTimestamp : String?
    var udid : String?
    var uuid : String?
    var eventStatus : String?
    var editTitle : String?
    var editDescrip : String?
    var banner : Banner?
    var locationmgr : CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Create Event"
        // Do any additional setup after loading the view.
        //eventDescription.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0).CGColor
        eventDescription.text = "Description"
        eventDescription.textColor = UIColor.lightGrayColor()
        eventTitle.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0)
        eventTitle.attributedPlaceholder = NSAttributedString(string:"Event Title",
            attributes:[NSForegroundColorAttributeName: UIColor.lightGrayColor()])
        

        
        
        deleteEventButton.hidden = true
        
        if editFlag == true {
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
            dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
            let updatedDateFormatted = dateFormatter.dateFromString(eventStartDate!)
            eventDateSelector.date = updatedDateFormatted!
            self.title = "Update Event"
            postButton.title = "Done"
            //config for update banner
            banner = Banner(title: "Success", subtitle: "Event Updated Successfully", image: UIImage(named: "Icon"), backgroundColor: UIColor(red:48.00/255.0, green:174.0/255.0, blue:51.5/255.0, alpha:1.000))
            banner!.dismissesOnTap = true
            deleteEventButton.hidden = false
            
        }
        //Handle the text fields user input through the delegate callbacks
        if(editFlag == true){
            let length = editTitle!.characters.count
            let length2 = editDescrip!.characters.count
            self.charCounter.text = String(40 - length)
            self.charCounter2.text = String(100 - length2)
        } else {
            self.charCounter.text = "40"
            self.charCounter2.text = "100"
        }
        eventTitle.delegate = self
        eventDescription.delegate = self
        
        eventDescription.selectedTextRange = eventDescription.textRangeFromPosition(eventDescription.beginningOfDocument, toPosition: eventDescription.beginningOfDocument)
        
        self.view.addSubview(eventTitle!)
        self.view.addSubview(eventDescription!)
        
        //locationmgr.requestWhenInUseAuthorization()
        //locationmgr.requestAlwaysAuthorization()
        mapView.showsUserLocation = true
        //locationmgr.delegate = self
        if (CLLocationManager.locationServicesEnabled())
        {
            locationmgr = CLLocationManager()
            locationmgr.delegate = self
            locationmgr.desiredAccuracy = kCLLocationAccuracyBest
            locationmgr.requestAlwaysAuthorization()
            //locationmgr.startUpdatingLocation()
        }
        
        let currentDate = NSDate()
        self.eventDateSelector.minimumDate = currentDate

        if(editFlag == true){
            self.eventTitle.text = editTitle
            self.eventDescription.text = editDescrip
            if eventDescription.text != "Description" {
                eventDescription.textColor = UIColor.blackColor()
            }
        }
        // Enable the Post button only if the text field has a valid Event name
        checkValidEventName()
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        
        let location = locations.last! as CLLocation
        
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        self.mapView.setRegion(region, animated: true)
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        var newLength = 40
        newLength = textField.text!.utf16.count + string.utf16.count - range.length
        if(newLength <= 40){
            self.charCounter.text = "\(40 - newLength)"
            if ((40 - newLength) < 40) {
                postButton.enabled = true
            } else {
                postButton.enabled = false
            }
            return true
        }else{
            return false
        }
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        var newLength = 100
        newLength = textView.text!.utf16.count + text.utf16.count - range.length
        if(newLength <= 100){
            if(textView.text == "Description"){
                newLength -= 11
            }
            self.charCounter2.text = "\(100 - newLength)"
        } else {
            return false
        }

        // Combine the textView text and the replacement text to
        // create the updated text string
        let currentText:NSString = eventDescription.text
        let updatedText = currentText.stringByReplacingCharactersInRange(range, withString: text)
        
        // If updated text view will be empty, add the placeholder
        // and set the cursor to the beginning of the text view
        if (updatedText.isEmpty){
            
            eventDescription.text = "Description"
            eventDescription.textColor = UIColor.lightGrayColor()
            
            eventDescription.selectedTextRange = eventDescription.textRangeFromPosition(eventDescription.beginningOfDocument, toPosition: eventDescription.beginningOfDocument)
            
            return false
        }
            
            // Else if the text view's placeholder is showing and the
            // length of the replacement string is greater than 0, clear
            // the text view and set its color to black to prepare for
            // the user's entry
        else if eventDescription.textColor == UIColor.lightGrayColor() && !text.isEmpty {
            eventDescription.text = nil
            eventDescription.textColor = UIColor.blackColor()
        }
        if (text == "\n") {
            eventDescription.resignFirstResponder()
            return false
        }
        return true
    }
    
    func textViewDidChangeSelection(textView: UITextView) {
        if self.view.window != nil {
            if (eventDescription.textColor == UIColor.lightGrayColor() && eventDescription.text == "Description") {
                eventDescription.selectedTextRange = eventDescription.textRangeFromPosition(eventDescription.beginningOfDocument, toPosition: eventDescription.beginningOfDocument)
            }
        }
    }
    
    // resign keyboard for eventTitle TextField on 'done'
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        eventTitle.resignFirstResponder()
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
    
    @IBAction func deleteEventButton(sender: AnyObject) {
    showAlertButtonTapped(deleteEventButton)
    }
    
    @IBAction func showAlertButtonTapped(sender: UIButton){
        
        //create the alert
        let alert = UIAlertController(title: "Delete Event", message: "Are you sure you want to delete this event?", preferredStyle: UIAlertControllerStyle.Alert)
        
        //add action buttons
        alert.addAction(UIAlertAction(title: "Delete", style: UIAlertActionStyle.Destructive, handler: {action in
            self.deleteEventFunc()
            self.performSegueWithIdentifier("deleteSegue", sender: self)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
        
        self.presentViewController(alert, animated: true, completion: nil)
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

    func checkValidEventName() {
        let text = eventTitle.text ?? ""
        postButton.enabled = !text.isEmpty
    }
    
    func deleteEventFunc(){
        banner = Banner(title: "Success", subtitle: "Event Deleted Successfully", image: UIImage(named: "Icon"), backgroundColor: UIColor(red:48.00/255.0, green:174.0/255.0, blue:51.5/255.0, alpha:1.000))
        banner!.dismissesOnTap = true
        //makes api call
        Alamofire.request(.DELETE, "https://ebox86-test.apigee.net/anonyvent/deleteEvent/\(uuid!)", parameters: nil, encoding: .JSON)
        banner!.show(duration: 1.5)
        
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if postButton === sender {
            if editFlag == false {
                //Set up date and time formats
                let formatter = NSDateFormatter()
                formatter.dateStyle = NSDateFormatterStyle.ShortStyle
                formatter.timeStyle = NSDateFormatterStyle.ShortStyle
                
                //constants to grab data from fields
                let name = eventTitle.text ?? ""
                let startDate = eventDateSelector.date
                let description = eventDescription.text ?? ""
                let formattedStartDate = formatter.stringFromDate(startDate)
                let UDIDset = UIDevice.currentDevice().identifierForVendor!.UUIDString.uppercaseString
                
                //current time for record creation timestamp
                let currentDateTime = NSDate()
                let creationTimestamp = formatter.stringFromDate(currentDateTime)
                
                //rando number get
                
                let unsignedArrayCount = UInt32(10000000)
                let unsignedRandomNumber = arc4random_uniform(unsignedArrayCount)
                let randomNumber = Int(unsignedRandomNumber)

                
                //creates new event dict
                eventRequest = ["id": String(randomNumber), "eventName": name, "description": description, "startDate": String(formattedStartDate), "udid": UDIDset, "eventTimestamp": String(creationTimestamp), "eventStatus": "\(EventStatus.Active)"/*, "location" : ["latitude" : 123.123, "longitude": 123.456]*/]
                //makes api call
                Alamofire.request(.POST, "https://ebox86-test.apigee.net/anonyvent/event", parameters: eventRequest, encoding: .JSON)
            } else {
                //Set up date and time formats
                let formatter = NSDateFormatter()
                formatter.dateStyle = NSDateFormatterStyle.ShortStyle
                formatter.timeStyle = NSDateFormatterStyle.ShortStyle
                
                let updatedTitle = eventTitle.text
                let updatedDescrip = eventDescription.text
                let startDate = eventDateSelector.date
                let formattedStartDate = formatter.stringFromDate(startDate)
                
                //current time to record modification timestamp
                let currentDateTime = NSDate()
                let modifiedTimestamp = formatter.stringFromDate(currentDateTime)
                //builds updated posts in new event dict and posts to apigee
                eventRequest = ["id": postId!, "eventName": updatedTitle!, "description": updatedDescrip, "startDate": String(formattedStartDate), "udid": udid!, "eventTimestamp": eventCreatedTimestamp!, "eventLastModified": modifiedTimestamp, "eventStatus": eventStatus!, /*"location" : ["latitude" : 123.123, "longitude": 123.456]*/ "uuid":uuid!]
                //makes api call
                Alamofire.request(.POST, "https://ebox86-test.apigee.net/anonyvent/event", parameters: eventRequest, encoding: .JSON)
                banner!.show(duration: 1.5)
            }
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    
}
