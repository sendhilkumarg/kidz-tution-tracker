//
//  PendingPaymentTableViewController.swift
//  Kidz Tuition Tracker
//
//  Created by Sendhil kumar Gurunathan on 2/17/16.
//  Copyright © 2016 Sendhil kumar Gurunathan. All rights reserved.
//
//  ViewController to display the pending payments and handle the status change events
//

import UIKit
import CoreData

class PendingPaymentTableViewController: UITableViewController, NSFetchedResultsControllerDelegate, PaymentChangeControllerDelegate {
    let managedObjectContext = TuitionTrackerDataController.sharedInstance.managedObjectContext
    var messageLabel : UILabel?

    
    lazy var fetchedResultsController: NSFetchedResultsController = {
        let fetchRequest = NSFetchRequest(entityName: "Payment")
        fetchRequest.predicate = NSPredicate(format: "status == %@", PaymentStatus.Pending.description)
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
        tableView.delegate = self
        tableView.dataSource = self
        self.refreshControl?.addTarget(self, action: #selector(PendingPaymentTableViewController.handleRefresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
        
        do {
            try self.fetchedResultsController.performFetch()
        } catch {
            let fetchError = error as NSError
            Utils.showAlertWithTitle(self, title: Utils.title, message: String( fetchError) )
        }
        
    }
    
    func handleRefresh(refreshControl: UIRefreshControl) {
        DataUtils.processMissingData(false, processPayments: true, showErrorMessage: true)
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
             messageLabel = UILabel(frame: CGRectMake(0, 0, self.view.bounds.size.width , self.view.bounds.size.height))
            messageLabel!.text = "No pending payments is currently available. Please pull down to refresh.";
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

    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let  headerCell = tableView.dequeueReusableCellWithIdentifier("headerCell") as? PendingPaymentHeaderCell
            if let cell = headerCell {
            cell.tuitionLabel.text = ""
            cell.timeLabel.text = ""
            if  let sectionData = fetchedResultsController.sections?[section] {
                if sectionData.objects != nil && sectionData.objects!.count > 0 {
                    if  let payment = sectionData.objects?[0] as? Payment , tuition = payment.relTuition
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
    
   override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        true
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellIdentifier = "pendingPaymentTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! PendingPaymentCell
        configureCell(cell, atIndexPath: indexPath)
        return cell
        
    }
    
    func configureCell(cell : PendingPaymentCell , atIndexPath indexPath: NSIndexPath){
     if    let payment = fetchedResultsController.objectAtIndexPath(indexPath) as? Payment
     {
        cell.dayLabel.text = Utils.toLongDateString( payment.date!)
        cell.objectId = payment.objectID
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
        
        let sectionIndexSet = NSIndexSet(index: sectionIndex)
                    switch type {
            case .Insert:
                self.tableView.insertSections(sectionIndexSet, withRowAnimation: UITableViewRowAnimation.Fade)
                break
            case .Delete:
                 self.tableView.deleteSections(sectionIndexSet, withRowAnimation: UITableViewRowAnimation.Fade)
                break
             default :
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
                let cell = tableView.cellForRowAtIndexPath(indexPath) as! PendingPaymentCell
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
    
    


    //MARK : PaymentChangeControllerDelegate
    func StatusChanged( objectId : NSManagedObjectID ,status : PaymentStatus)
    {
        
        do {
            let record = try managedObjectContext.existingObjectWithID(objectId )
            record.setValue(NSInteger( status.rawValue), forKeyPath: "status")
            record.setValue(NSDate(), forKeyPath: "updatedon")
            try record.managedObjectContext?.save()
            dismissViewControllerAnimated(true, completion: nil)
            
        } catch {
            let saveError = error as NSError
            Utils.showAlertWithTitle(self, title: Utils.title, message: String(saveError.userInfo) )
        }
        
    }
    

}
