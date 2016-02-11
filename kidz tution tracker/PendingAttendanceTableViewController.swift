//
//  PendingAttendanceTableViewController.swift
//  kidz tuition tracker
//
//  Created by Sendhil kumar Gurunathan on 2/7/16.
//  Copyright © 2016 Sendhil kumar Gurunathan. All rights reserved.
//

import UIKit
import CoreData

class PendingAttendanceTableViewController: UITableViewController  , NSFetchedResultsControllerDelegate , AttendanceChangeControllerDelegate{
    let managedObjectContext = TuitionTrackerDataController().managedObjectContext

    
    lazy var fetchedResultsController: NSFetchedResultsController = {
        // Initialize Fetch Request
        let fetchRequest = NSFetchRequest(entityName: "Attendance")
        
        // Add Sort Descriptors
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        // Initialize Fetched Results Controller
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext, sectionNameKeyPath: "relTuition.name", cacheName: nil)
        
        // Configure Fetched Results Controller
        fetchedResultsController.delegate = self
        
        return fetchedResultsController
    }()
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
      /*
        let fetchRequest = NSFetchRequest(entityName: "Tuition")
        
        do {
            let result = try self.managedObjectContext.executeFetchRequest(fetchRequest)
            for item in result
            {
               let tuition = item as! Tuition
                CreateNewAttendance(tuition)
                //print(tuition.name)
            }
            //print(result)
            
        } catch {

            let saveError = error as NSError
            print("\(saveError), \(saveError.userInfo)")
            
            // Show Alert View
            Utils.showAlertWithTitle(self, title: "Error", message: "error", cancelButtonTitle: "Cancel")
        }

      */
 

        do {
            try self.fetchedResultsController.performFetch()
        } catch {
            let fetchError = error as NSError
            print("\(fetchError), \(fetchError.userInfo)")
             Utils.showAlertWithTitle(self, title: "Error", message: String( fetchError), cancelButtonTitle: "Cancel")
        }

    }

    func CreateNewAttendance(tuition : Tuition )
    {
        // Create Entity
        let entity = NSEntityDescription.entityForName("Attendance", inManagedObjectContext: self.managedObjectContext)
        
        // Initialize Record
        let record = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: self.managedObjectContext)
        
        record.setValue(NSDate() , forKey: "date")
        record.setValue(false, forKey: "attended")
        record.setValue("", forKey: "notes")
        
        // Create Relationship
        //let parent = record.mutableSetValueForKey("relTuition")
        //parent.addObject(newChildPerson)
        record.setValue(tuition, forKey: "relTuition")
        
        do {
            // Save Record
            try record.managedObjectContext?.save()
            
            // Dismiss View Controller
            dismissViewControllerAnimated(true, completion: nil)
            
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
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        //1
        let attendance = fetchedResultsController.objectAtIndexPath(indexPath) as! Attendance
        //2
        //let cell = tableView.dequeueReusableCellWithIdentifier("movieCell")!
        let cellIdentifier = "pendingAttendanceTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! PendingAttendanceCell
        //3
         configureCell(cell, atIndexPath: indexPath)

        return cell

    }

    func configureCell(cell : PendingAttendanceCell , atIndexPath indexPath: NSIndexPath){
        let attendance = fetchedResultsController.objectAtIndexPath(indexPath) as! Attendance
        cell.atIndexPath = indexPath
        cell.dayLabel.text = Utils.ToLongDateString( attendance.date!)
        cell.attendanceSwitch.on = attendance.attended!.boolValue
        cell.delegate = self
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
    func StatusChanged(atIndexPath : NSIndexPath ,attended : Bool)
    {
        //if let indexPath = tableView.indexPathForSelectedRow {
        // Fetch Record
        let record = fetchedResultsController.objectAtIndexPath(atIndexPath) as! Attendance
        
        record.setValue(attended, forKeyPath: "attended")
        
        do {
            // Save Record
            try record.managedObjectContext?.save()
            
            dismissViewControllerAnimated(true, completion: nil)
            
        } catch {
            let saveError = error as NSError
            print("\(saveError), \(saveError.userInfo)")
            
            // Show Alert View
            Utils.showAlertWithTitle(self, title: "Error", message: "error", cancelButtonTitle: "Cancel")
        }
        
        
        
        // print(attended)
    }
    
}
