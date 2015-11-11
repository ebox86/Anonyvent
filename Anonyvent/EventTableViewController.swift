//
//  EventTableViewController.swift
//  Anonyvent
//
//  Created by Evan Kohout on 11/1/15.
//  Copyright © 2015 Evan Kohout. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Foundation

class EventTableViewController: UITableViewController {

    //MARK : Properties
    let randoIcon = EventIcons()
    var events = [Event]()
    let endpoint = "https://ebox86-test.apigee.net/anonyvent/events"

    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Load Sample Data
        //loadSampleEvents()
        pullnParse()
        print(events.count)
        print("last")
        
                //print(response)
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    func pullnParse (){
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        Alamofire.request(.GET, endpoint)
            .responseJSON { response in
            switch response.result {
                case .Success(let JSON):
                    //print("Success wth JSON: \(JSON)")
                    var newArray = (JSON as! NSArray) as Array
                    var x = 0
                    for (x; x < newArray.count; x++) {
                        //print(x)
                        let dateX : NSDate = dateFormatter.dateFromString(String(newArray[x]["startDate"]!!))!
                        print(dateX)
                        let eventX = Event(title: String(newArray[x]["name"]), date: dateX, description: String(newArray[x]["description"]), icon: self.randoIcon.randomIcon(), id: String(newArray[x]["id"]))
                            self.events.append(eventX!)
                        print(self.events.count)
                }
                
            case .Failure(let error):
                print("request failed with error: \(error)")
                }
        
        }
    }

    
    func loadSampleEvents(){
        /*
        let event1 = Event(title: "Party", date: EventDate.parse("2015-11-11"), description: "Party at x", icon: randoIcon.randomIcon())!
        
        let event2 = Event(title: "Study Session", date: EventDate.parse("2015-11-10"), description: "Calculus meet at Zoka", icon: randoIcon.randomIcon())!
        
        let event3 = Event(title: "Trip downtown", date: EventDate.parse("2015-11-19"), description: "Going downtown, anyone want to join?", icon: randoIcon.randomIcon())!
        
        let event4 = Event(title: "Movie", date: EventDate.parse("2015-11-12"), description: "anyone down for a movie", icon: randoIcon.randomIcon())!

        events.append(event1)
        events.append(event2)
        events.append(event3)
        events.append(event4)
        */
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {

        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return events.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "EventTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! EventTableViewCell
        let event = events[indexPath.row]

        cell.titleLabel.text = event.title
        cell.evebtIconView.image = event.icon
        cell.dateLabel.text = String(event.date)
        cell.descriptionLabel.text = event.description

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "ShowDetail" {
            let eventDetailViewController = segue.destinationViewController as! CreateEventViewController
            if let selectedEventCell = sender as? EventTableViewCell {
                let indexPath = tableView.indexPathForCell(selectedEventCell)!
                let selectedEvent = events[indexPath.row]
                eventDetailViewController.event = selectedEvent
            }
        } else if segue.identifier == "AddItem" {
            print("adding a new event")
        }
    }
    

    
    @IBAction func unwindToEventList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.sourceViewController as? CreateEventViewController, event = sourceViewController.event {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                // update existing event
                events[selectedIndexPath.row] = event
                tableView.reloadRowsAtIndexPaths([selectedIndexPath], withRowAnimation: .None)
            } else {
                //add an event
                let newIndexPath = NSIndexPath(forRow: events.count, inSection: 0)
                events.append(event)
                tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Bottom)
        
            }
        }
    }
}
