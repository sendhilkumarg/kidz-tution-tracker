//
//  TutionsListViewController.swift
//  kidz tuition tracker
//
//  Created by Sendhil kumar Gurunathan on 1/19/16.
//  Copyright © 2016 Sendhil kumar Gurunathan. All rights reserved.
//

import UIKit
import CoreData

class TutionsListViewController: UIViewController , UITableViewDataSource , UITableViewDelegate , NSFetchedResultsControllerDelegate {

    @IBOutlet weak var tuitionsTableView: UITableView!
    
    //let managedObjectContext = TuitionTrackerDataController().managedObjectContext
    let managedObjectContext = TuitionTrackerDataController.sharedInstance.managedObjectContext
    var deleteTutionsIndexPath: NSIndexPath? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tuitionsTableView.tableFooterView = UIView(frame: .zero)
        tuitionsTableView.tableFooterView?.hidden = true;
        do {
            try self.fetchedResultsController.performFetch()
        } catch {
            let fetchError = error as NSError
            print("\(fetchError), \(fetchError.userInfo)")
        }
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: -
    // MARK: Table View Data Source Methods
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if let sections = fetchedResultsController.sections {
            return sections.count
        }
        
        return 0
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = fetchedResultsController.sections {
            let sectionInfo = sections[section]
            return sectionInfo.numberOfObjects
        }
        
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
         let cellIdentifier = "TuitionsTableViewCell"
        let cell = tuitionsTableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! TuitionsTableViewCell
         let tuition = fetchedResultsController.objectAtIndexPath(indexPath) as! Tuition
       Utils.configureTuitionsTableViewCellCell(cell,tuition: tuition, atIndexPath: indexPath)
        return cell
    }
    
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == .Delete) {
            deleteTutionsIndexPath = indexPath
            confirmDelete()
            /*
            // Fetch Record
            let record = fetchedResultsController.objectAtIndexPath(indexPath) as! NSManagedObject
            
            // Delete Record
            managedObjectContext.deleteObject(record)
            do {
                try  managedObjectContext.save()
            }
                catch {
                    let saveError = error as NSError
                    print("\(saveError), \(saveError.userInfo)")
                    
                    // Show Alert View
                    showAlertWithTitle("Warning", message: "Your to-do could not be saved.", cancelButtonTitle: "OK")
                }
            */
           
        }
    }
  
    // MARK: Table View Delegate Methods
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    /*
    func tableView(tableView: UITableView, accessoryTypeForRowWithIndexPath indexPath: NSIndexPath) -> UITableViewCellAccessoryType {
        code
    }

    
    func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
        print("click")
    }
*/
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
                Utils.configureTuitionsTableViewCellCell(cell,tuition: tuition, atIndexPath: indexPath)

               // configureCell(cell, atIndexPath: indexPath)
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
    
    // MARK: Prepare for Segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "segueAddTutions" {
            if let navigationController = segue.destinationViewController as? UINavigationController {
                if let viewController = navigationController.topViewController as? TuitionsAddViewController {
                    viewController.managedObjectContext = managedObjectContext
                }
            }
        }
        else if segue.identifier == "SegueEditTuitions" {
           /* if let viewController = segue.destinationViewController as? TuitionsEditViewController {
                if let indexPath = tuitionsTableView.indexPathForSelectedRow {
                    // Fetch Record
                    let record = fetchedResultsController.objectAtIndexPath(indexPath) as! Tuition
                    
                    // Configure View Controller
                    viewController.tuition = record
                    viewController.managedObjectContext = managedObjectContext
                }
            }
            */

            if let navigationController = segue.destinationViewController as? UINavigationController {
                if let viewController = navigationController.topViewController as? TuitionsEditViewController {
                     if let indexPath = tuitionsTableView.indexPathForSelectedRow {
                    // Fetch Record
                    let record = fetchedResultsController.objectAtIndexPath(indexPath) as! Tuition
                    
                    viewController.tuition = record
                    viewController.managedObjectContext = managedObjectContext
                }
                }
            }
           
        }

    }
    
    // MARK: Helper Methods
    private func showAlertWithTitle(title: String, message: String, cancelButtonTitle: String) {
        // Initialize Alert Controller
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        
        // Configure Alert Controller
        alertController.addAction(UIAlertAction(title: cancelButtonTitle, style: .Default, handler: nil))
        
        // Present Alert Controller
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    func confirmDelete() {
        let record = fetchedResultsController.objectAtIndexPath(deleteTutionsIndexPath! ) as! Tuition
        let alert = UIAlertController(title: "Delete Tuition", message: "Are you sure you want to permanently delete \(record.name!)", preferredStyle: .ActionSheet)
        
        let DeleteAction = UIAlertAction(title: "Delete", style: .Destructive, handler: handleDeletePlanet)
        let CancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: cancelDeletePlanet)
        
        alert.addAction(DeleteAction)
        alert.addAction(CancelAction)
        
        // Support display in iPad
        alert.popoverPresentationController?.sourceView = self.view
        alert.popoverPresentationController?.sourceRect = CGRectMake(self.view.bounds.size.width / 2.0, self.view.bounds.size.height / 2.0, 1.0, 1.0)
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func handleDeletePlanet(alertAction: UIAlertAction!) -> Void {
        // Fetch Record
        let record = fetchedResultsController.objectAtIndexPath(deleteTutionsIndexPath! ) as! Tuition
        
        // Delete Record
        managedObjectContext.deleteObject(record)
        do {
            try  managedObjectContext.save()
        }
        catch {
            let saveError = error as NSError
            print("\(saveError), \(saveError.userInfo)")
            
            // Show Alert View
            showAlertWithTitle("Warning", message: "Your to-do could not be saved.", cancelButtonTitle: "OK")
        }
        deleteTutionsIndexPath = nil

    }
    
    func cancelDeletePlanet(alertAction: UIAlertAction!) {
        deleteTutionsIndexPath  = nil
        
    }
}
