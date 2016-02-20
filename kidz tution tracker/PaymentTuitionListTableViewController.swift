//
//  PaymentTuitionListTableViewController.swift
//  kidz tuition tracker
//
//  Created by Sendhil kumar Gurunathan on 2/20/16.
//  Copyright © 2016 Sendhil kumar Gurunathan. All rights reserved.
//

import UIKit
import CoreData

class PaymentTuitionListTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    let managedObjectContext = TuitionTrackerDataController().managedObjectContext

    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            try self.fetchedResultsController.performFetch()
        } catch {
            let fetchError = error as NSError
            print("\(fetchError), \(fetchError.userInfo)")
            Utils.showAlertWithTitle(self, title: "Error", message: String( fetchError), cancelButtonTitle: "Cancel")
        }
    }
    
    lazy var fetchedResultsController: NSFetchedResultsController = {
        // Initialize Fetch Request
        let fetchRequest = NSFetchRequest(entityName: "Tuition")
        
        // Add Sort Descriptors
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        // Initialize Fetched Results Controller
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        
        // Configure Fetched Results Controller
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
        Utils.configurePaymentTuitionTableViewCell(cell,tuition: tuition, atIndexPath: indexPath)
        return cell
    }
    
    // MARK: -  FetchedResultsController Delegate
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        tableView.endUpdates()
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "segueShowPayment" {
            if let viewController = segue.destinationViewController as? PaymentHistoryTableViewControler {
                if let indexPath = tableView.indexPathForSelectedRow {
                    let record = fetchedResultsController.objectAtIndexPath(indexPath) as! Tuition
                    
                    
                    viewController.tuitionObjectId = record.objectID
                    viewController.tuition = record
                }
            }
            
        }
    }
}