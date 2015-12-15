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

class EventsHomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var refreshControl = UIRefreshControl()
    let formatter = NSDateFormatter()
    
    var events:Array<EventPost>?
    var eventsWrapper:EventWrapper? // holds the last wrapper that we've loaded
    var isLoadingEvents = false
    
    @IBOutlet weak var eventsTableViewNew2: UITableView?
    @IBAction func unwindActionFromCreateEvent(segue: UIStoryboardSegue) {
    events?.removeAll()
    loadFirstEvents()
    self.eventsTableViewNew2?.reloadData()
    }
    @IBAction func unwindActionFromCancel(segue: UIStoryboardSegue) {}
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // date format for pull refresher
        self.formatter.dateStyle = NSDateFormatterStyle.ShortStyle
        self.formatter.timeStyle = NSDateFormatterStyle.LongStyle
        
        // set up the refresh control
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.eventsTableViewNew2?.addSubview(refreshControl)
        
        self.loadFirstEvents()
    }
    
    func refresh(sender:AnyObject) {
        events?.removeAll()
        self.loadFirstEvents()
    }
    
    func loadFirstEvents()
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
   
    func loadMoreEvents()
    {
        self.isLoadingEvents = true
        if self.events != nil && self.eventsWrapper != nil && self.events!.count < self.eventsWrapper!.count
        {
            print("test")
            // there are more events out there!
            EventPost.getEvents { wrapper, error in
                if let error = error
                {
                    // TODO: improved error handling
                    self.isLoadingEvents = false
                    let alert = UIAlertController(title: "Uh Oh", message: "Could not load more events. \(error.localizedDescription)", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                }
                print("got more!")
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
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        if self.events != nil && self.events!.count >= indexPath.row
        {
            let events = self.events![indexPath.row]
            cell.textLabel?.text = events.eventName
            cell.detailTextLabel?.text = events.description
            //cell.textLabel?.text = events.startDate
            
            // See if we need to load more events
            let rowsToLoadFromBottom = 5;
            let rowsLoaded = self.events!.count
            
            
            if (!self.isLoadingEvents && (indexPath.row >= (rowsLoaded - rowsToLoadFromBottom)))
            {
                let totalRows = self.eventsWrapper?.count
                let remainingEventsToLoad: Int? = (totalRows! - rowsLoaded)
                if (remainingEventsToLoad > 0)
                {
                    self.loadMoreEvents()
                }
            }
            
        }
        
        return cell
    }
    
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
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }

    
    
}
