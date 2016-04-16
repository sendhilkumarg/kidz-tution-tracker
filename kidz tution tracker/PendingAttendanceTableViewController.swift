//
//  PendingAttendanceTableViewController.swift
//  Activity Tracker
//
//  Created by Sendhil kumar Gurunathan on 2/7/16.
//  Copyright © 2016 Sendhil kumar Gurunathan. All rights reserved.
//
//  ViewController to display the pending attendance and handle the status change events
//

import UIKit
import CoreData

class PendingAttendanceTableViewController: UITableViewController  , AttendanceChangeControllerDelegate , NSFetchedResultsControllerDelegate
{
    let managedObjectContext = TuitionTrackerDataController.sharedInstance.managedObjectContext
    var messageLabel : UILabel?
    lazy var fetchedResultsController: NSFetchedResultsController = {
        let fetchRequest = NSFetchRequest(entityName: "Attendance")
         fetchRequest.predicate = NSPredicate(format: "status == %@", AttendanceStatus.Pending.description)
        let sortDescriptor1 = NSSortDescriptor(key: "date", ascending: false)
        let sortDescriptor2 = NSSortDescriptor(key: "relTuition.name", ascending: true)
        let sortDescriptor3 = NSSortDescriptor(key: "relTuition.personname", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor2,sortDescriptor3, sortDescriptor1]
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext, sectionNameKeyPath: "relTuition.objectID", cacheName: nil)
        fetchedResultsController.delegate = self
        
        return fetchedResultsController
    }()
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.refreshControl?.addTarget(self, action: #selector(PendingAttendanceTableViewController.handleRefresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
        do {
            try self.fetchedResultsController.performFetch()
        } catch {
            let fetchError = error as NSError
             Utils.showAlertWithTitle(self, title: Utils.title, message: String( fetchError))
        }

    }
    
    func handleRefresh(refreshControl: UIRefreshControl) {
        DataUtils.processMissingData(true, processPayments: false, showErrorMessage: true)
       do {
            try self.fetchedResultsController.performFetch()
        } catch {
            let fetchError = error as NSError
            Utils.showAlertWithTitle(self, title: Utils.title, message: String( fetchError))
        }
        self.tableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        guard let sectionCount = fetchedResultsController.sections?.count else {
            return 0
        }
        if sectionCount == 0 {
            messageLabel = UILabel(frame: CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height))
            messageLabel!.text = "No pending attendance is currently available. Please pull down to refresh.";
            messageLabel!.textColor = UIColor.blackColor() ;
            messageLabel!.numberOfLines = 0;
            messageLabel!.textAlignment = NSTextAlignment.Center;
            messageLabel!.font = UIFont(name: "Trebuchet MS", size: 14)
            self.tableView.backgroundView = messageLabel;
        }
        return sectionCount
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sectionData = fetchedResultsController.sections?[section] else {
            return 0
        }
        if(sectionData.numberOfObjects > 0){
            if let label = messageLabel{
                label.hidden = true;
            }
            
        }
        return sectionData.numberOfObjects
    }

    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let sectionData = fetchedResultsController.sections?[section] else {
            return ""
        }
       
        return sectionData.name
    }
    

    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let  headerCell = tableView.dequeueReusableCellWithIdentifier("headerCell") as? PendingAttenanceHeaderCell
        if let cell = headerCell {
            cell.tuitionLabel.text = ""
            cell.timeLabel.text = ""
            if  let sectionData = fetchedResultsController.sections?[section] {
                if sectionData.objects != nil && sectionData.objects!.count > 0 {
                   if  let atn = sectionData.objects?[0] as? Attendance , tuition = atn.relTuition
                   {
                    let (name,time,_ ) =  Utils.getDisplayData(tuition)
                    cell.tuitionLabel.text = name
                    cell.timeLabel.text  = time
                    }
                }
                
            }

        }
        return headerCell
  
    }
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60.00
    }
        
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let cellIdentifier = "pendingAttendanceTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as! PendingAttendanceCell
        configureCell(cell, atIndexPath: indexPath)
        return cell

    }

    func configureCell(cell : PendingAttendanceCell , atIndexPath indexPath: NSIndexPath){
        
        if let attendance = fetchedResultsController.objectAtIndexPath(indexPath) as? Attendance {
            cell.delegate = self
            cell.objectId = attendance.objectID
            cell.dayLabel.text = Utils.toLongDateString( attendance.date!)
            cell.attendanceSegemnt.selected = false ;
            cell.attendanceSegemnt.selectedSegmentIndex = -1
             if let _ = attendance.status  {
                switch attendance.CurrentStatus
                {
                case AttendanceStatus.Pending :
                    cell.attendanceSegemnt.selected = false ;
                    break
                    
                case AttendanceStatus.Attended :
                    cell.attendanceSegemnt.selectedSegmentIndex = 0
                    break
                case AttendanceStatus.Absent :
                    cell.attendanceSegemnt.selectedSegmentIndex = 1
                    break
                    
                }
                
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
    
     func controller(
        controller: NSFetchedResultsController,
        didChangeSection sectionInfo: NSFetchedResultsSectionInfo,
        atIndex sectionIndex: Int,
        forChangeType type: NSFetchedResultsChangeType) {
            
            switch type {
            case .Insert:
                let sectionIndexSet = NSIndexSet(index: sectionIndex)
                self.tableView.insertSections(sectionIndexSet, withRowAnimation: UITableViewRowAnimation.Fade)
            case .Delete:
                let sectionIndexSet = NSIndexSet(index: sectionIndex)
                self.tableView.deleteSections(sectionIndexSet, withRowAnimation: UITableViewRowAnimation.Fade)
            default:
                break
            }
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
                self.tableView.reloadData()
            }
            break;

        case .Update:
            if let indexPath = indexPath {
                let cell = tableView.cellForRowAtIndexPath(indexPath) as! PendingAttendanceCell
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



    //MARK : AttendanceChangeControllerDelegate
    func StatusChanged( objectId : NSManagedObjectID, status : AttendanceStatus)
    {

        do {
            let record = try managedObjectContext.existingObjectWithID(objectId )
            record.setValue(NSInteger( status.rawValue), forKeyPath: "status")
            try record.managedObjectContext?.save()
            
        } catch {
            let saveError = error as NSError
            Utils.showAlertWithTitle(self, title: Utils.title, message: String(saveError.userInfo) )
        }
        
        
    }
    
}
