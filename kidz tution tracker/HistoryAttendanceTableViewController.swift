//
//  HistoryAttendanceTableViewController.swift
//  kidz tuition tracker
//
//  Created by Sendhil kumar Gurunathan on 2/13/16.
//  Copyright © 2016 Sendhil kumar Gurunathan. All rights reserved.
//

import UIKit
import CoreData

class HistoryAttendanceTableViewController: UITableViewController , AttendanceChangeControllerDelegate {

    let managedObjectContext = TuitionTrackerDataController.sharedInstance.managedObjectContext

    var tuitionObjectId : NSManagedObjectID?
    var tuition : Tuition?
    var attendanceList : [Attendance] = [];

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let sortDescriptor1 = NSSortDescriptor(key: "date", ascending: false)

        for item in tuition!.relAttendance!.sortedArrayUsingDescriptors([sortDescriptor1]) {
            attendanceList.append(item as! Attendance)
        }
        if let tuition = tuition{
            var header = ""
        if let name = tuition.name {
            if let personName = tuition.personname {
                header = "\(personName)'s \(name)"
            }
            else{
               header = name
                
            }
            
        }
        
        if let  time = tuition.time  {
            header = header + " " + Utils.ToTimeFromString(time)
        }
     self.navigationItem.title = header
        }

        
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
        return attendanceList.count
 
    }
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let  headerCell = tableView.dequeueReusableCellWithIdentifier("headerCell") as? HistoryAttenanceHeaderCell
        return headerCell
    }
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60.00
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellIdentifier = "historyAttendanceTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! HistoryAttendanceCell
        configureCell(cell, atIndexPath: indexPath)
        return cell
        
    }
    
    func configureCell(cell : HistoryAttendanceCell , atIndexPath indexPath: NSIndexPath){
        let attendance = attendanceList[indexPath.row]

        cell.dayLabel.text = Utils.ToLongDateString( attendance.date!)
        if let _ = attendance.status {
            cell.statusLabel.text =  attendance.CurrentStatus.displaytext;
        }
        else
        {
            cell.statusLabel.text = "Pending"
        }
    }
    
    // MARK: Prepare for Segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "seagueEditTuitionItem" {
            if let controller = segue.destinationViewController as? AttendanceEditController
            {
                 if let indexPath = tableView.indexPathForSelectedRow {
                    controller.attendance = attendanceList[indexPath.row]
                    controller.atIndexPath = indexPath
                    controller.objectId = attendanceList[indexPath.row].objectID
                    controller.delegate = self
                }
            }
        }

 
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        if identifier == "seagueEditTuitionItem"{
            if let cell = sender
            {
                if let historyCell = cell as? HistoryAttendanceCell
                {
                    if historyCell.statusLabel.text != AttendanceStatus.Pending.displaytext{
                        return true
                    }
                }
            }
            return false
        }
        return false
    }
    
    
    //MARK : AttendanceChangeControllerDelegate
    func StatusChanged(atIndexPath : NSIndexPath ,  objectId : NSManagedObjectID, status : AttendanceStatus)
    {
        
        do {
            // Save Record
            let record = try managedObjectContext.existingObjectWithID(objectId )
            
            record.setValue(NSInteger( status.rawValue), forKeyPath: "status")
            try record.managedObjectContext?.save()
            attendanceList[atIndexPath.row].status = NSInteger(status.rawValue)
            let cell = tableView.cellForRowAtIndexPath(atIndexPath) as! HistoryAttendanceCell
            configureCell(cell, atIndexPath: atIndexPath)

            
        } catch {
            let saveError = error as NSError
            print("\(saveError), \(saveError.userInfo)")
            
            // Show Alert View
            Utils.showAlertWithTitle(self, title: "Error", message: "error", cancelButtonTitle: "Cancel")
        }
    }

    
}

