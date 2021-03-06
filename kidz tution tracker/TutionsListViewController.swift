//
//  TutionsListViewController.swift
//  Kidz Tuition Tracker
//
//  Created by Sendhil kumar Gurunathan on 1/19/16.
//  Copyright © 2016 Sendhil kumar Gurunathan. All rights reserved.
//
//  View Controller to to display the list of available tuitions
//

import UIKit
import CoreData

class TutionsListViewController: UIViewController , UITableViewDataSource , UITableViewDelegate , NSFetchedResultsControllerDelegate {
    let managedObjectContext = TuitionTrackerDataController.sharedInstance.managedObjectContext
    var deleteTutionsIndexPath: NSIndexPath? = nil
    @IBOutlet weak var tuitionsTableView: UITableView!
    var messageLabel : UILabel?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tuitionsTableView.tableFooterView = UIView(frame: .zero)
        tuitionsTableView.tableFooterView?.hidden = true;
        do {
            try self.fetchedResultsController.performFetch()
        } catch {
            let fetchError = error as NSError
            Utils.showAlertWithTitle(self, title: Utils.title, message: String( fetchError) )
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
    
    

    // MARK: Table View Data Source Methods
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        guard let sectionCount = fetchedResultsController.sections?.count else {
            return 0
        }
        
        return sectionCount
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = fetchedResultsController.sections {
            let sectionInfo = sections[section]
            if (sectionInfo.numberOfObjects == 0){
                messageLabel = UILabel(frame: CGRectMake(0, 0, self.view.bounds.size.width , self.view.bounds.size.height))
                messageLabel!.text = "No tuitions currently configured. Please add a tuition.";
                messageLabel!.textColor = UIColor.blackColor() ;
                messageLabel!.numberOfLines = 0;
                messageLabel!.textAlignment = NSTextAlignment.Center;
                messageLabel!.font = UIFont(name: "Trebuchet MS", size: 14)
                tuitionsTableView.backgroundView = messageLabel;

            }
            else if let label = messageLabel
            {
                label.hidden = true;
               
            }
            return sectionInfo.numberOfObjects
        }
        else{
                    return 0
        }

        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
         let cellIdentifier = "TuitionsTableViewCell"
        let cell = tuitionsTableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! TuitionsTableViewCell
         let tuition = fetchedResultsController.objectAtIndexPath(indexPath) as! Tuition
         configureTuitionsTableViewCellCell(cell,tuition: tuition, atIndexPath: indexPath)
        return cell
    }
    
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == .Delete) {
            deleteTutionsIndexPath = indexPath
            confirmDelete()
           
        }
    }
  
    // MARK: Table View Delegate Methods
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

    // MARK: Fetched Results Controller Delegate Methods
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        tuitionsTableView.beginUpdates()
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        tuitionsTableView.endUpdates()
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        switch (type) {
        case .Insert:
            if let indexPath = newIndexPath {
                tuitionsTableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            }
            break;
        case .Delete:
            if let indexPath = indexPath {
                tuitionsTableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            }
            break;
        case .Update:
            if let indexPath = indexPath {
                let cell = tuitionsTableView.cellForRowAtIndexPath(indexPath) as! TuitionsTableViewCell
                let tuition = fetchedResultsController.objectAtIndexPath(indexPath) as! Tuition
                configureTuitionsTableViewCellCell(cell,tuition: tuition, atIndexPath: indexPath)

            }
            break;
        case .Move:
            if let indexPath = indexPath {
                tuitionsTableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            }
            
            if let newIndexPath = newIndexPath {
                tuitionsTableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Fade)
            }
            break;
        }
    }
    
    //MARK: Construct table cell
    
    func configureTuitionsTableViewCellCell(cell: TuitionsTableViewCell, tuition : Tuition , atIndexPath indexPath: NSIndexPath) {
        let (name,time,days ) =  Utils.getDisplayData(tuition)
        cell.tuitionNameLabel.text = name
        cell.timeLabel.text  = time
        cell.daysLabel.text  = days
    }

    
    
    // MARK: Prepare for Segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

         if segue.identifier == "segueEditTuitions" {
           if let navigationController = segue.destinationViewController as? UINavigationController {
                if let viewController = navigationController.topViewController as? TuitionsEditViewController {
                     if let indexPath = tuitionsTableView.indexPathForSelectedRow {
                    // Fetch Record
                    let record = fetchedResultsController.objectAtIndexPath(indexPath) as! Tuition
                    
                    viewController.tuition = record
                   
                }
                }
            }
           
        }

    }
    

    // MARK: Delete Tuition
    
    func confirmDelete() {
        let record = fetchedResultsController.objectAtIndexPath(deleteTutionsIndexPath! ) as! Tuition
        
        let alert = UIAlertController(title: "Delete Tuition", message: "Are you sure you want to permanently delete the tuition \"\(record.name!)\" of \"\(record.personname!)\"? ", preferredStyle: .ActionSheet)
        
        let DeleteAction = UIAlertAction(title: "Delete", style: .Destructive, handler: handleDelete)
        let CancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: cancelDelete)
        
        alert.addAction(DeleteAction)
        alert.addAction(CancelAction)
        
        // Support display in iPad
        alert.popoverPresentationController?.sourceView = self.view
        alert.popoverPresentationController?.sourceRect = CGRectMake(self.view.bounds.size.width / 2.0, self.view.bounds.size.height / 2.0, 1.0, 1.0)
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func handleDelete(alertAction: UIAlertAction!) -> Void {
        // Fetch Record
        let record = fetchedResultsController.objectAtIndexPath(deleteTutionsIndexPath! ) as! Tuition
        
        // Delete Record
        managedObjectContext.deleteObject(record)
        do {
            try  managedObjectContext.save()
        }
        catch {
            let saveError = error as NSError
            Utils.showAlertWithTitle(self, title: Utils.title, message: "\(Utils.failedToDeleteTuition). \(saveError.userInfo)") ;
        }
        deleteTutionsIndexPath = nil

    }
    
    func cancelDelete(alertAction: UIAlertAction!) {
        deleteTutionsIndexPath  = nil
        
    }
}
