//
//  PendingAttendanceTableViewController.swift
//  kidz tuition tracker
//
//  Created by Sendhil kumar Gurunathan on 2/7/16.
//  Copyright © 2016 Sendhil kumar Gurunathan. All rights reserved.
//

import UIKit
import CoreData

class PendingAttendanceTableViewController: UITableViewController  , AttendanceChangeControllerDelegate , NSFetchedResultsControllerDelegate
{
    let managedObjectContext = TuitionTrackerDataController().managedObjectContext
    var itemsChanged =  [NSIndexPath]()
    var dayUpdteCounter  = 1
    
    lazy var fetchedResultsController: NSFetchedResultsController = {
        // Initialize Fetch Request
        let fetchRequest = NSFetchRequest(entityName: "Attendance")
        //fetchRequest.predicate = NSPredicate(format: "status = %@", AttendanceStatus.Pending.rawValue)
         fetchRequest.predicate = NSPredicate(format: "status == %@", AttendanceStatus.Pending.description)
        // Add Sort Descriptors
        let sortDescriptor1 = NSSortDescriptor(key: "date", ascending: false)
        let sortDescriptor2 = NSSortDescriptor(key: "relTuition.name", ascending: true)
        let sortDescriptor3 = NSSortDescriptor(key: "relTuition.personname", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor2,sortDescriptor3, sortDescriptor1]
        
        // Initialize Fetched Results Controller
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext, sectionNameKeyPath: "relTuition.objectID", cacheName: nil)
        // Configure Fetched Results Controller
        fetchedResultsController.delegate = self
        
        return fetchedResultsController
    }()
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
      //CreateTestData()
        self.refreshControl?.addTarget(self, action: "handleRefresh:", forControlEvents: UIControlEvents.ValueChanged)
    

        do {
            try self.fetchedResultsController.performFetch()
        } catch {
            let fetchError = error as NSError
            print("\(fetchError), \(fetchError.userInfo)")
             Utils.showAlertWithTitle(self, title: "Error", message: String( fetchError), cancelButtonTitle: "Cancel")
        }

    }
    
    func handleRefresh(refreshControl: UIRefreshControl) {
        // Do some reloading of data and update the table view's data source
        // Fetch more objects from a web service, for example...
        
        // Simply adding an object to the data source for this example

        DataUtils.processMissingData(true, processPayments: false, showErrorMessage: true)
        //CreateTestData()
        //self.tableView.reloadData()
        do {
            try self.fetchedResultsController.performFetch()
        } catch {
            let fetchError = error as NSError
            print("\(fetchError), \(fetchError.userInfo)")
            Utils.showAlertWithTitle(self, title: "Error", message: String( fetchError), cancelButtonTitle: "Cancel")
        }
        self.tableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    func CreateTestData(){
        let fetchRequest = NSFetchRequest(entityName: "Tuition")
        
        do {
            let result = try self.managedObjectContext.executeFetchRequest(fetchRequest)
            for item in result
            {
                let tuition = item as! Tuition
                for i in 1...2{
                    let today = NSDate()
                    let tomorrow = NSCalendar.currentCalendar().dateByAddingUnit(
                        .Day,
                        value: dayUpdteCounter,
                        toDate: today,
                        options: NSCalendarOptions(rawValue: 0))
dayUpdteCounter++
                     CreateNewAttendance(tuition,date: tomorrow!)
                     CreateNewPayment(tuition,date: tomorrow!)
                    }
               
                //print(tuition.name)
            }
            print ("created test data")
            //print(result)
            
        } catch {
            
            let saveError = error as NSError
            print("\(saveError), \(saveError.userInfo)")
            
            // Show Alert View
            Utils.showAlertWithTitle(self, title: "Error", message: "error", cancelButtonTitle: "Cancel")
        }
    }

    func CreateNewAttendance(tuition : Tuition , date : NSDate)
    {
        // Create Entity
        let entity = NSEntityDescription.entityForName("Attendance", inManagedObjectContext: self.managedObjectContext)
        
        // Initialize Record
        let record = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: self.managedObjectContext)
        
        record.setValue(date , forKey: "date")
        record.setValue( NSInteger( AttendanceStatus.Pending.rawValue) , forKey: "status")
        record.setValue(tuition, forKey: "relTuition")
        
        do {
            // Save Record
            try record.managedObjectContext?.save()
            
        } catch {
            let saveError = error as NSError
            print("\(saveError), \(saveError.userInfo)")
            
            // Show Alert View
            Utils.showAlertWithTitle(self, title: "Error", message: "error", cancelButtonTitle: "Cancel")
        }
    }
    
    func CreateNewPayment(tuition : Tuition , date : NSDate)
    {
        // Create Entity
        let entity = NSEntityDescription.entityForName("Payment", inManagedObjectContext: self.managedObjectContext)
        
        // Initialize Record
        let record = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: self.managedObjectContext)
        
        
        record.setValue(date , forKey: "date")
        record.setValue( NSInteger( PaymentStatus.Pending.rawValue) , forKey: "status")
        
        
        // Create Relationship
        //let parent = record.mutableSetValueForKey("relTuition")
        //parent.addObject(newChildPerson)
        record.setValue(tuition, forKey: "relTuition")
        
        do {
            // Save Record
            try record.managedObjectContext?.save()
            
        } catch {
            let saveError = error as NSError
            print("\(saveError), \(saveError.userInfo)")
            
            // Show Alert View
            Utils.showAlertWithTitle(self, title: "Error", message: "error", cancelButtonTitle: "Cancel")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let sectionData = fetchedResultsController.sections?[section] else {
            return "na"
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
                    if let name = tuition.name {
                        if let personName = tuition.personname {
                            cell.tuitionLabel.text = "\(personName)'s \(name)"
                        }
                        else{
                            cell.tuitionLabel.text = name
                            
                        }
                        
                    }
                    if let time = tuition.time {
                        cell.timeLabel.text = Utils.ToTimeFromString(time)
                    }
                    
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
        //let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! PendingAttendanceCell
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as! PendingAttendanceCell
        configureCell(cell, atIndexPath: indexPath)
        return cell

    }

    func configureCell(cell : PendingAttendanceCell , atIndexPath indexPath: NSIndexPath){
        print("indexPath \(indexPath)")
        //print(fetchedResultsController.objectAtIndexPath(indexPath))
        let attendance = fetchedResultsController.objectAtIndexPath(indexPath) as! Attendance
        //print(attendance.)
        cell.objectId = attendance.objectID
        cell.atIndexPath = indexPath
        cell.dayLabel.text = Utils.ToLongDateString( attendance.date!)
        cell.attendanceSegemnt.selected = false ;
        cell.attendanceSegemnt.selectedSegmentIndex = -1
       // cell.attendanceSegemnt.reloadInputViews()// (UISegmentedControlNoSegment)
        if let status = attendance.status  {
            print("segment status " + status.description)
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
       
        cell.delegate = self
       
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
                ""
            }
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        print(type.rawValue)
        
        if let ip = indexPath {
             itemsChanged.append(ip)
        }
       
        switch (type) {
        case .Insert:
            print("insert")
            if let indexPath = newIndexPath {
                tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            }
            break;
        case .Delete:
            print("delete")
            if let indexPath = indexPath {
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            }
            break;

        case .Update:
            print("update")
            if let indexPath = indexPath {
                let cell = tableView.cellForRowAtIndexPath(indexPath) as! PendingAttendanceCell
                configureCell(cell, atIndexPath: indexPath)
            }
            break;

        case .Move:
            print("move")
            if let indexPath = indexPath {
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            }
            
            if let newIndexPath = newIndexPath {
                tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Fade)
            }
            break;

         default :
            break;
        }
    }



    //MARK : AttendanceChangeControllerDelegate
    func StatusChanged(atIndexPath : NSIndexPath ,  objectId : NSManagedObjectID, status : AttendanceStatus)
    {
        // Fetch Record
        // let fetchRequest = NSFetchRequest(entityName: "Attendance")
       // var error: NSError?
        do {
            // Save Record
            let record = try managedObjectContext.existingObjectWithID(objectId )
            
            record.setValue(NSInteger( status.rawValue), forKeyPath: "status")
            try record.managedObjectContext?.save()
            // dismissViewControllerAnimated(true, completion: nil)
            
        } catch {
            let saveError = error as NSError
            print("\(saveError), \(saveError.userInfo)")
            
            // Show Alert View
            Utils.showAlertWithTitle(self, title: "Error", message: "error", cancelButtonTitle: "Cancel")
        }
        
      /*
        //fetchRequest.
        let record = fetchedResultsController.objectAtIndexPath(atIndexPath) as! Attendance
        
        record.setValue(NSInteger( status.rawValue), forKeyPath: "status")
        
        do {
            // Save Record
            try record.managedObjectContext?.save()
            
           // dismissViewControllerAnimated(true, completion: nil)
            
        } catch {
            let saveError = error as NSError
            print("\(saveError), \(saveError.userInfo)")
            
            // Show Alert View
            Utils.showAlertWithTitle(self, title: "Error", message: "error", cancelButtonTitle: "Cancel")
        }
        */
        
    }
    
}
