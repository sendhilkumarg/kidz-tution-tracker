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
    let managedObjectContext = TuitionTrackerDataController().managedObjectContext
    

    
    lazy var fetchedResultsController: NSFetchedResultsController = {
        // Initialize Fetch Request
        let fetchRequest = NSFetchRequest(entityName: "Payment")
        fetchRequest.predicate = NSPredicate(format: "status == %@", PaymentStatus.Pending.description)
        // Add Sort Descriptors
        let sortDescriptor1 = NSSortDescriptor(key: "date", ascending: false)
        let sortDescriptor2 = NSSortDescriptor(key: "relTuition.name", ascending: true)
        let sortDescriptor3 = NSSortDescriptor(key: "relTuition.personname", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor2,sortDescriptor3, sortDescriptor1]
        //fetchRequest.sortDescriptors = [sortDescriptor1]
        // Initialize Fetched Results Controller
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext, sectionNameKeyPath: "relTuition.objectID", cacheName: nil) //"relTuition.objectID"
        // Configure Fetched Results Controller
        fetchedResultsController.delegate = self
        
        return fetchedResultsController
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // CreateTestData()
        
        do {
            try self.fetchedResultsController.performFetch()
        } catch {
            let fetchError = error as NSError
            print("\(fetchError), \(fetchError.userInfo)")
            Utils.showAlertWithTitle(self, title: "Error", message: String( fetchError), cancelButtonTitle: "Cancel")
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
        // tableView.endUpdates()
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
