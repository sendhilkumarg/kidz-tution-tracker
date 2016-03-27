//
//  DayListTableViewController.swift
//  kidz tuition tracker
//
//  Created by Sendhil kumar Gurunathan on 3/16/16.
//  Copyright © 2016 Sendhil kumar Gurunathan. All rights reserved.
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
        let cell = tableView.dequeueReusableCellWithIdentifier("dayCell", forIndexPath: indexPath) as UITableViewCell
        cell.textLabel?.text = days[indexPath.row]
        if selectedDays.contains(indexPath.row)
        {
            cell.accessoryType = .Checkmark
        }
        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let index = indexPath.row
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let newCell = tableView.cellForRowAtIndexPath(indexPath)
        if selectedDays.contains(index)
        {
             selectedDays.removeAtIndex(selectedDays.indexOf(index)!)
             newCell?.accessoryType = .None
        }
        else
        {
            selectedDays.append(index)
             newCell?.accessoryType = .Checkmark
            
        }

        if let delegate = delegate {
            delegate.DaysChanged(selectedDays)
        }
       

    }


    
}
