//
//  DayListTableViewController.swift
//  Activity Tracker
//
//  Created by Sendhil kumar Gurunathan on 3/16/16.
//  Copyright © 2016 Sendhil kumar Gurunathan. All rights reserved.
//
//  View Controller to display the list of week days for selection
//

import UIKit

class DayListTableViewController: UITableViewController {
    var delegate : DayChangeControllerDelegate?

    private var days = ["Sunday", "Monday" , "Tuesday","Wednesday","Thursday","Friday","Saturday"]
    var selectedDays = [Int]()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return days.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("dayCell", forIndexPath: indexPath) as! DayTableViewCell
        cell.dayLabel!.text = days[indexPath.row]

        if selectedDays.contains(indexPath.row)
        {
            cell.accessoryType = .Checkmark
        }
        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let index = indexPath.row
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if let cell = tableView.cellForRowAtIndexPath(indexPath)
        {
            if selectedDays.contains(index)
            {
                selectedDays.removeAtIndex(selectedDays.indexOf(index)!)
                cell.accessoryType = .None
            }
            else
            {
                selectedDays.append(index)
                cell.accessoryType = .Checkmark
            }

            if let delegate = delegate {
                delegate.DaysChanged(selectedDays)
            }
        }

    }


    
}
