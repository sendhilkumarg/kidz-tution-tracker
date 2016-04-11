//
//  PaymentTuitionListTableViewController.swift
//  kidz tuition tracker
//
//  Created by Sendhil kumar Gurunathan on 2/20/16.
//  Copyright © 2016 Sendhil kumar Gurunathan. All rights reserved.
//
//  ViewController to display the list of the tuitions
//

import UIKit
import CoreData

class PaymentTuitionListTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    let managedObjectContext = TuitionTrackerDataController.sharedInstance.managedObjectContext

    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            try self.fetchedResultsController.performFetch()
        } catch {
            let fetchError = error as NSError
            Utils.showAlertWithTitle(self, title: Utils.title, message: String( fetchError))
        }
    }
    
    lazy var fetchedResultsController: NSFetchedResultsController = {
        let fetchRequest = NSFetchRequest(entityName: "Tuition")
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        
        return fetchedResultsController
    }()
    
    
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
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "HistoryTuitionViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! PaymentTuitionTableViewCell
        let tuition = fetchedResultsController.objectAtIndexPath(indexPath) as! Tuition
        configurePaymentTuitionTableViewCell(cell,tuition: tuition, atIndexPath: indexPath)
        return cell
    }
    func configurePaymentTuitionTableViewCell(cell: PaymentTuitionTableViewCell, tuition : Tuition , atIndexPath indexPath: NSIndexPath) {
        if let name = tuition.name {
            if let personName = tuition.personname {
                cell.tuitionNameLabel.text = "\(personName)'s \(name)"
            }
            else{
                cell.tuitionNameLabel.text = name
                
            }
            
        }
        
        if let  time = tuition.time  {
            cell.timeLabel.text = Utils.ToTimeFromString(time)
        }
        else
        {
            cell.timeLabel.text = "";
        }
        
        
        if let isEmpty = tuition.frequency?.isEmpty where isEmpty != true {
            
            cell.daysLabel.text  = Utils.GetRepeatLabelInShortFormat(tuition.frequency!)
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
                let cell = tableView.cellForRowAtIndexPath(indexPath) as! PaymentTuitionTableViewCell
                let tuition = fetchedResultsController.objectAtIndexPath(indexPath) as! Tuition
                configurePaymentTuitionTableViewCell(cell,tuition: tuition, atIndexPath: indexPath)
                
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

    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "segueShowPayment" {
            if let viewController = segue.destinationViewController as? PaymentHistoryTableViewControler {
                if let indexPath = tableView.indexPathForSelectedRow {
                    let record = fetchedResultsController.objectAtIndexPath(indexPath) as! Tuition
                    viewController.tuition = record
                }
            }
            
        }
    }
}
