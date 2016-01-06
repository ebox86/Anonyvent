//
//  EventsHomeViewController.swift
//  Anonyvent
//
//  Created by Evan Kohout on 11/11/15.
//  Copyright © 2015 Evan Kohout. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Foundation
import CoreLocation
import MapKit

class EventsHomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate {
    //@IBOutlet weak var createPost: UIBarButtonItem!
    @IBOutlet weak var createPost: UIBarButtonItem!
    
    
    var refreshControl = UIRefreshControl()
    let formatter = NSDateFormatter()
    let locationManager = CLLocationManager()
    
    var events:Array<EventPost>?
    var eventsWrapper:EventWrapper? // holds the last wrapper that we've loaded
    var isLoadingEvents = false
    let prefs = NSUserDefaults.standardUserDefaults()
    
    @IBOutlet weak var eventsTableViewNew2: UITableView?
    
    @IBAction func unwindActionFromCreateEvent(segue: UIStoryboardSegue) {
        events?.removeAll()
        loadEvents()
        self.eventsTableViewNew2?.reloadData()
    }
    @IBAction func unwindActionFromCancel(segue: UIStoryboardSegue) {}
    
    @IBAction func deleteUnwind(segue:UIStoryboardSegue){}
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()
        
        self.title = "SomeApp"
        
        //let navigationBar = navigationController!.navigationBar
        //navigationBar.tintColor = UIColor.blueColor()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
        // date format for pull refresher
        self.formatter.dateStyle = NSDateFormatterStyle.ShortStyle
        self.formatter.timeStyle = NSDateFormatterStyle.LongStyle
        
        // set up the refresh control
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.eventsTableViewNew2?.addSubview(refreshControl)
        events?.removeAll()
        self.loadEvents()
    }
    
    func refresh(sender:AnyObject) {
        events?.removeAll()
        self.loadEvents()
    }
    
    func loadEvents()
    {
        isLoadingEvents = true
        EventPost.getEvents { wrapper, error in
            if let error = error
            {
                // TODO: improved error handling
                self.isLoadingEvents = false
                let alert = UIAlertController(title: "Uh Oh", message: "Could not load any events. \(error.localizedDescription)", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
            self.addEventsFromWrapper(wrapper)
            self.isLoadingEvents = false
            
            // update "last updated" title for refresh control
            let now = NSDate()
            let updateString = "Last Updated at " + self.formatter.stringFromDate(now)
            self.refreshControl.attributedTitle = NSAttributedString(string: updateString)
            
            // tell refresh control it can stop showing up now
            if self.refreshControl.refreshing
            {
                self.refreshControl.endRefreshing()
            }
            
            self.eventsTableViewNew2?.reloadData()
        }
    }
   
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        print("locations = \(locValue.latitude) \(locValue.longitude)")
    }
    

    func addEventsFromWrapper(wrapper: EventWrapper?)
    {
        self.eventsWrapper = wrapper
        if self.events == nil
        {
            self.events = self.eventsWrapper?.event
        }
        else if self.eventsWrapper != nil && self.eventsWrapper!.event != nil
        {
            self.events = self.events! + self.eventsWrapper!.event!
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.events == nil
        {
            return 0
        }
        return self.events!.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! EventsTableViewCell
        if self.events != nil && self.events!.count >= indexPath.row
        {
            let events = self.events![indexPath.row]
            
            cell.titleLabel?.text = events.eventName
            cell.titleLabel?.numberOfLines = 2
            //cell.eventDetailLabel?.text = events.description
            cell.layer.borderWidth = 0.25
            cell.layer.borderColor = UIColor.lightGrayColor().CGColor
            cell.eventDateLabel?.text = events.startDate
            
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            
            //let whiteRoundedView : UIView = UIView(frame: CGRectMake(0, 5, self.view.frame.size.width - 10, 90))
            
            //let shadowPath = UIBezierPath(rect: whiteRoundedView.bounds)
            //whiteRoundedView.layer.backgroundColor = CGColorCreate(CGColorSpaceCreateDeviceRGB(), [1.0, 1.0, 1.0, 1.0])
            //whiteRoundedView.layer.masksToBounds = false
            //whiteRoundedView.layer.cornerRadius = 0.5
            //whiteRoundedView.layer.shadowOffset = CGSizeMake(-1, 1)
            //whiteRoundedView.layer.shadowOpacity = 0.2
            //whiteRoundedView.layer.shadowPath = shadowPath.CGPath
            
            //ell.contentView.addSubview(whiteRoundedView)
            //cell.contentView.sendSubviewToBack(whiteRoundedView)
            
            // See if we need to load more events
            let rowsToLoadFromBottom = 5;
            let rowsLoaded = self.events!.count
            
            
            if (!self.isLoadingEvents && (indexPath.row >= (rowsLoaded - rowsToLoadFromBottom)))
            {
                let totalRows = self.eventsWrapper?.count
                let remainingEventsToLoad: Int? = (totalRows! - rowsLoaded)
            }
            
        }
        
        return cell
    }
    
    /*override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let indexPath = tableView!.indexPathForSelectedRow();
        let currentCell = tableView.cellForRowAtIndexPath(indexPath!) as UITableViewCell!;
        eventTitleToPass = currentCell.textLabel?.text
        eventDescriptionToPass = currentCell.detailTextLabel?.text
        performSegueWithIdentifier("detailViewSegue", sender: self)
    }
    */
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "detailViewSegue")
        {
            //let viewController = segue.destinationViewController as! DetailViewController
            let navVC = segue.destinationViewController as! UINavigationController
            let viewController = navVC.topViewController as! DetailViewController
            let indexPath = eventsTableViewNew2!.indexPathForCell(sender as! UITableViewCell)
            let viewEvents = self.events![indexPath!.row]
            viewController.eventTitle = viewEvents.eventName
            viewController.eventDescription = viewEvents.description
            viewController.eventStartDate = viewEvents.startDate
            viewController.authorUDID = viewEvents.udid
            viewController.uuid = viewEvents.uuid
            viewController.eventStatus = viewEvents.eventStatus
            viewController.postId = viewEvents.postId
            viewController.created = viewEvents.created
            viewController.modified = viewEvents.modified
            viewController.hidesBottomBarWhenPushed = true
        }
    }
    
    /*
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row % 2 == 0
        {
            cell.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0) // very light gray
        }
        else
        {
            cell.backgroundColor = UIColor.whiteColor()
        }
    }
    */

}
