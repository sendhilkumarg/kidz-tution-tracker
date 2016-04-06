//
//  PaymentHistoryTableViewControler.swift
//  kidz tuition tracker
//
//  Created by Sendhil kumar Gurunathan on 2/20/16.
//  Copyright © 2016 Sendhil kumar Gurunathan. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class PaymentHistoryTableViewControler: UITableViewController , NSFetchedResultsControllerDelegate , PaymentChangeControllerDelegate  {
    let managedObjectContext = TuitionTrackerDataController.sharedInstance.managedObjectContext
    var tuitionObjectId : NSManagedObjectID?
    var tuition : Tuition?
    
    lazy var fetchedResultsController: NSFetchedResultsController = {
    
        let fetchRequest = NSFetchRequest(entityName: "Payment")
        fetchRequest.predicate = NSPredicate(format: "relTuition == %@", self.tuition!)
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
   
        // Initialize Fetched Results Controller
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        
        // Configure Fetched Results Controller
        fetchedResultsController.delegate = self
        
        return fetchedResultsController
    }( )

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        do {
            try self.fetchedResultsController.performFetch()
        } catch {
            let fetchError = error as NSError
            print("\(fetchError), \(fetchError.userInfo)")
            Utils.showAlertWithTitle(self, title: "Error", message: String( fetchError), cancelButtonTitle: "Cancel")
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
        
        let  headerCell = tableView.dequeueReusableCellWithIdentifier("headerCell") as? PaymentHistoryHeaderCell
        return headerCell
    }
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60.00
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellIdentifier = "historyPaymentTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! PaymentHistoryCell
        configureCell(cell, atIndexPath: indexPath)
        return cell
        
    }
    
    func configureCell(cell : PaymentHistoryCell , atIndexPath indexPath: NSIndexPath){
        let payment = fetchedResultsController.objectAtIndexPath(indexPath) as! Payment

        if let date = payment.date {
            cell.dayLabel.text = Utils.ToLongDateString( date)
            if let _ = payment.status {
                cell.statusLabel.text =  payment.CurrentStatus.displaytext;
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
            print("insert")
            if let indexPath = newIndexPath {
                tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            }
            break;
        case .Delete:
            print("deleting row")
            if let indexPath = indexPath {
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            }
            break;
            
        case .Update:
            print("update")
            if let indexPath = indexPath {
                let cell = tableView.cellForRowAtIndexPath(indexPath) as! PaymentHistoryCell
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
            
            
        }
    }

    // MARK: Prepare for Segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "seagueEditPaymentItem" {
            if let controller = segue.destinationViewController as? PaymentEditController
            {
                if let indexPath = tableView.indexPathForSelectedRow {
                     let payment = fetchedResultsController.objectAtIndexPath(indexPath) as! Payment
                    controller.payment = payment
                    controller.atIndexPath = indexPath
                     controller.objectId = payment.objectID
                    controller.delegate = self
                    
                    let backItem = UIBarButtonItem()
                    backItem.title = "Back"
                    navigationItem.backBarButtonItem = backItem

                }
            }
        }
        
        
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        if identifier == "seagueEditPaymentItem"{
            if let cell = sender
            {
                if let historyCell = cell as? PaymentHistoryCell
                {
                    if historyCell.statusLabel.text != PaymentStatus.Pending.displaytext{
                        return true
                    }
                }
            }
            return false
        }
        return false
    }
    
        //MARK : PaymentChangeControllerDelegate

    func StatusChanged(atIndexPath : NSIndexPath ,  objectId : NSManagedObjectID, status : PaymentStatus)
    {
        
        do {
            // Save Record
            let record = try managedObjectContext.existingObjectWithID(objectId )
            
            record.setValue(NSInteger( status.rawValue), forKeyPath: "status")
            try record.managedObjectContext?.save()
            
        } catch {
            let saveError = error as NSError
            print("\(saveError), \(saveError.userInfo)")
            
            // Show Alert View
            Utils.showAlertWithTitle(self, title: "Error", message: "Failed to save the changes", cancelButtonTitle: "Cancel")
        }
    }
    



}
