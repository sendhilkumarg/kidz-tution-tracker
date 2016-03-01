//
//  PendingPaymentTableViewController.swift
//  kidz tuition tracker
//
//  Created by Sendhil kumar Gurunathan on 2/17/16.
//  Copyright © 2016 Sendhil kumar Gurunathan. All rights reserved.
//

import UIKit
import CoreData

class PendingPaymentTableViewController: UITableViewController, NSFetchedResultsControllerDelegate, PaymentChangeControllerDelegate {
    let managedObjectContext = TuitionTrackerDataController.sharedInstance.managedObjectContext //TuitionTrackerDataController().managedObjectContext
    var messageLabel : UILabel?

    
    lazy var fetchedResultsController: NSFetchedResultsController = {
        // Initialize Fetch Request
        let fetchRequest = NSFetchRequest(entityName: "Payment")
        fetchRequest.predicate = NSPredicate(format: "status == %@", PaymentStatus.Pending.description)
        // Add Sort Descriptors
        let sortDescriptor1 = NSSortDescriptor(key: "date", ascending: false)
        let sortDescriptor2 = NSSortDescriptor(key: "relTuition.name", ascending: true)
        let sortDescriptor3 = NSSortDescriptor(key: "relTuition.personname", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor2,sortDescriptor3, sortDescriptor1]
        // Initialize Fetched Results Controller
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext, sectionNameKeyPath: "relTuition.objectID", cacheName: nil) //"relTuition.objectID"
        // Configure Fetched Results Controller
        fetchedResultsController.delegate = self
        
        return fetchedResultsController
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        
        DataUtils.processMissingData(false, processPayments: true, showErrorMessage: true)
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
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        guard let sectionCount = fetchedResultsController.sections?.count else {
            
            return 0
        }
        if sectionCount == 0 {
             messageLabel = UILabel(frame: CGRectMake(0, 0, self.view.bounds.size.width , self.view.bounds.size.height))
            
            
            messageLabel!.text = "No pending payments is currently available. Please pull down to refresh.";
            messageLabel!.textColor = UIColor.blackColor() ;
            messageLabel!.numberOfLines = 0;
            messageLabel!.textAlignment = NSTextAlignment.Center;
            messageLabel!.font = UIFont(name: "Arial", size: 12)
            //self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
            
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
            
            //messageLabel!.hidden = true;
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
        
        let  headerCell = tableView.dequeueReusableCellWithIdentifier("headerCell") as? PendingPaymentHeaderCell
        if let cell = headerCell {
            cell.tuitionLabel.text = ""
            cell.timeLabel.text = ""
            if  let sectionData = fetchedResultsController.sections?[section] {
                if sectionData.objects != nil && sectionData.objects!.count > 0 {
                    if  let payment = sectionData.objects?[0] as? Payment , tuition = payment.relTuition
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
        
        let cellIdentifier = "pendingPaymentTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! PendingPaymentCell
        configureCell(cell, atIndexPath: indexPath)
        return cell
        
    }
    
    func configureCell(cell : PendingPaymentCell , atIndexPath indexPath: NSIndexPath){
        print(fetchedResultsController.objectAtIndexPath(indexPath))
        let payment = fetchedResultsController.objectAtIndexPath(indexPath) as! Payment
        cell.atIndexPath = indexPath
        cell.dayLabel.text = Utils.ToLongDateString( payment.date!)
       // cell.statusSwitch.on = payment.status.attended!.boolValue
        if let _ = payment.status  {
            switch payment.CurrentStatus
            {
            case PaymentStatus.Pending :
                cell.statusSwitch.on = false ;
                break
                
            case PaymentStatus.Paid :
                cell.statusSwitch.on = true ;
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
        print("pending payment \(type.rawValue)")
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
                let cell = tableView.cellForRowAtIndexPath(indexPath) as! PendingPaymentCell
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
    
    


    //MARK : PaymentChangeControllerDelegate
    func StatusChanged(atIndexPath : NSIndexPath ,status : PaymentStatus)
    {
        // Fetch Record
        let record = fetchedResultsController.objectAtIndexPath(atIndexPath) as! Payment
        
        record.setValue(NSInteger( status.rawValue), forKeyPath: "status")
        
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
        
    }
    

}
