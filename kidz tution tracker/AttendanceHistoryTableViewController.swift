//
//  HistoryAttendanceTableViewController.swift
//  kidz tuition tracker
//
//  Created by Sendhil kumar Gurunathan on 2/13/16.
//  Copyright © 2016 Sendhil kumar Gurunathan. All rights reserved.
//
//  ViewController to display the list of the attendance for a specific tuition
//
import UIKit
import CoreData

class AttendanceHistoryTableViewController: UITableViewController , NSFetchedResultsControllerDelegate , AttendanceChangeControllerDelegate {

    let managedObjectContext = TuitionTrackerDataController.sharedInstance.managedObjectContext
    var tuition : Tuition?
    lazy var fetchedResultsController: NSFetchedResultsController = {
        
        let fetchRequest = NSFetchRequest(entityName: "Attendance")
        fetchRequest.predicate = NSPredicate(format: "relTuition == %@", self.tuition!)
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        
        return fetchedResultsController
    }( )

    
    override func viewDidLoad() {
        super.viewDidLoad()
        do {
            try self.fetchedResultsController.performFetch()
        } catch {
            let fetchError = error as NSError
            Utils.showAlertWithTitle(self, title: Utils.titleError, message: String( fetchError), cancelButtonTitle: Utils.titleCancel)
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

    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        guard let sectionCount = fetchedResultsController.sections?.count else {
            return 0
        }
        return sectionCount
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sectionData = fetchedResultsController.sections?[section] else {
            return 0
        }
        return sectionData.numberOfObjects
    }
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let  headerCell = tableView.dequeueReusableCellWithIdentifier("headerCell") as UITableViewCell?
        return headerCell
    }
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60.00
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellIdentifier = "historyAttendanceTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! AttendanceHistoryCell
        configureCell(cell, atIndexPath: indexPath)
        return cell
        
    }
    
    func configureCell(cell : AttendanceHistoryCell , atIndexPath indexPath: NSIndexPath){
        let attendance = fetchedResultsController.objectAtIndexPath(indexPath) as! Attendance

        if let date = attendance.date{
            cell.dayLabel.text = Utils.ToLongDateString( date)
            if let _ = attendance.status {
                cell.statusLabel.text =  attendance.CurrentStatus.displaytext;
            }
            else
            {
                cell.statusLabel.text = "Pending"
            }
        }

    }
    
    // MARK: -  FetchedResultsController Delegate
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        tableView.endUpdates()
    }

    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        
        switch (type) {
        case .Insert:
            if let indexPath = newIndexPath {
                tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            }
            break;
        case .Delete:
            if let indexPath = indexPath {
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            }
            break;
            
        case .Update:
            if let indexPath = indexPath {
                let cell = tableView.cellForRowAtIndexPath(indexPath) as! AttendanceHistoryCell
                configureCell(cell, atIndexPath: indexPath)
            }
            break;
            
        case .Move:
            if let indexPath = indexPath {
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            }
            
            if let newIndexPath = newIndexPath {
                tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Fade)
            }
            break;
        }
    }
    
    // MARK: Prepare for Segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "seagueEditTuitionItem" {
            if let controller = segue.destinationViewController as? AttendanceEditController
            {
                 if let indexPath = tableView.indexPathForSelectedRow {
                    let attendance = fetchedResultsController.objectAtIndexPath(indexPath) as! Attendance

                    controller.attendance = attendance
                    controller.objectId = attendance.objectID
                    controller.delegate = self
                    
                    let backItem = UIBarButtonItem()
                    backItem.title = "Back"
                    navigationItem.backBarButtonItem = backItem
                }
            }
        }

 
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        if identifier == "seagueEditTuitionItem"{
            if let cell = sender
            {
                if let historyCell = cell as? AttendanceHistoryCell
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
    func StatusChanged(  objectId : NSManagedObjectID, status : AttendanceStatus)
    {
        
        do {
            let record = try managedObjectContext.existingObjectWithID(objectId )
            record.setValue(NSInteger( status.rawValue), forKeyPath: "status")
            try record.managedObjectContext?.save()
            
        } catch {
            let saveError = error as NSError
            
            // Show Alert View
            Utils.showAlertWithTitle(self, title: Utils.titleError, message: String(saveError.userInfo), cancelButtonTitle: Utils.titleCancel)
        }
    }

    
}

