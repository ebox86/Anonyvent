//
//  EventsHomeViewController.swift
//  Anonyvent
//
//  Created by Evan Kohout on 11/11/15.
//  Copyright © 2015 Evan Kohout. All rights reserved.
//

import UIKit

class EventsHomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var events:Array<EventPost>?
    var eventsWrapper:EventPost? // holds the last wrapper that we've loaded
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
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
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

}
