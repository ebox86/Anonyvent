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

    var events:Array<EventPost>?
    var eventsWrapper:EventWrapper? // holds the last wrapper that we've loaded
    var isLoadingEvents = false
    
    @IBOutlet weak var EventsTableView: UITableView!

    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // place tableview below status bar, cuz I think it's prettier that way
        self.EventsTableView?.contentInset = UIEdgeInsetsMake(20.0, 0.0, 0.0, 0.0);
        
        //self.loadFirstEvent()
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
            let species = self.events![indexPath.row]
            cell.textLabel?.text = species.name
            cell.detailTextLabel?.text = events?.description
            
            // See if we need to load more species
            let rowsToLoadFromBottom = 5;
            let rowsLoaded = self.events!.count
            if (!self.isLoadingEvents && (indexPath.row >= (rowsLoaded - rowsToLoadFromBottom)))
            {
                let totalRows = self.eventsWrapper!.count!
                let remainingSpeciesToLoad = totalRows - rowsLoaded;
                if (remainingSpeciesToLoad > 0)
                {
                    self.loadMoreEvents()
                }
            }
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    func loadFirstEvents()
    {
        isLoadingEvents = true
        EventPost.getEvents { wrapper, error in
            if let error = error
            {
                // TODO: improved error handling
                self.isLoadingEvents = false
                let alert = UIAlertController(title: "Error", message: "Could not load first event \(error.localizedDescription)", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
            self.addEventsFromWrapper(wrapper)
            self.isLoadingEvents = false
            self.tableview?.reloadData()
        }
    }
    
    func loadMoreEvents()
    {
        self.isLoadingEvents = true
        if self.events != nil && self.eventsWrapper != nil && self.events!.count < self.eventsWrapper!.count
        {
            // there are more species out there!
            EventPost.getMoreEvents(self.eventsWrapper, completionHandler: { wrapper, error in
                if let error = error
                {
                    // TODO: improved error handling
                    self.isLoadingEvents = false
                    let alert = UIAlertController(title: "Error", message: "Could not load more events \(error.localizedDescription)", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                }
                print("got more!")
                self.addEventsFromWrapper(wrapper)
                self.isLoadingEvents = false
                self.tableview?.reloadData()
            })
        }
    }
    
    func addEventsFromWrapper(wrapper: EventsWrapper?)
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
}
