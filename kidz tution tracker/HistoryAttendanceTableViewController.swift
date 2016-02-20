//
//  HistoryAttendanceTableViewController.swift
//  kidz tuition tracker
//
//  Created by Sendhil kumar Gurunathan on 2/13/16.
//  Copyright © 2016 Sendhil kumar Gurunathan. All rights reserved.
//

import UIKit
import CoreData

class HistoryAttendanceTableViewController: UITableViewController {

    //let managedObjectContext = TuitionTrackerDataController().managedObjectContext
    var tuitionObjectId : NSManagedObjectID?
    var tuition : Tuition?
    var attendanceList : [Attendance] = [];

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let sortDescriptor1 = NSSortDescriptor(key: "date", ascending: false)

        for item in tuition!.relAttendance!.sortedArrayUsingDescriptors([sortDescriptor1]) {
          //  print(item)
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
        //let attendance = fetchedResultsController.objectAtIndexPath(indexPath) as! Attendance
        let attendance = attendanceList[indexPath.row]

        cell.dayLabel.text = Utils.ToLongDateString( attendance.date!)
        if let status = attendance.status {
            cell.statusLabel.text =  attendance.CurrentStatus.displaytext;
    
        }
        else
        {
            cell.statusLabel.text = "Pending"
        }
    }
    }
