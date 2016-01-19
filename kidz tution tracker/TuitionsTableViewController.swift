//
//  TutionsTableViewController.swift
//  kidz tution tracker
//
//  Created by Sendhil kumar Gurunathan on 1/16/16.
//  Copyright © 2016 Sendhil kumar Gurunathan. All rights reserved.
//

import UIKit
import CoreData

class TuitionsTableViewController: UITableViewController {
    
    let managedObjectContext = TuitionTrackerDataController().managedObjectContext
    var tuitions = [Tuition]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = editButtonItem()
        loadTutions()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    func loadTutions(){
        var tutionFetch =  NSFetchRequest(entityName: "Tuition")
        do{
            tuitions = try managedObjectContext.executeFetchRequest(tutionFetch) as! [Tuition]
           // print(tuitions.first!.name!)
        }catch {
            fatalError("Failure to read from context: \(error)")
        }
        
    }
    

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
       
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
               return tuitions.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...
        let cellIdentifier = "TuitionsTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! TuitionsTableViewCell
        
        let tution = tuitions[indexPath.row]
        
      //  cell.lblTutionName.text = tution.name //todo: enable it when required
       
        return cell
    }

    @IBAction func unwindToMealList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.sourceViewController as? TuitionsViewController, tuition = sourceViewController.tuition {
            
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                // Update
                tuitions[selectedIndexPath.row] = tuition
                tableView.reloadRowsAtIndexPaths([selectedIndexPath], withRowAnimation: .None)
            }
            else {
            // Add
            let newIndexPath = NSIndexPath(forRow: tuitions.count, inSection: 0)
            tuitions.append(tuition)
            tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Bottom)
            }
        }
    }
    
    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
   

    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            // tuitions.removeAtIndex(indexPath.row)
          //  tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowDetail" {
            let tutionViewController = segue.destinationViewController as! TuitionsViewController
            
            // Get the cell that generated this segue.
            if let selectedTuitionCell = sender as? TuitionsTableViewCell {
                let indexPath = tableView.indexPathForCell(selectedTuitionCell)!
                let selectedTuition = tuitions[indexPath.row]
                tutionViewController.tuition = selectedTuition
            }
        }
        else if segue.identifier == "AddItem" {
            print("Adding new Tution.")
        }
    }

}
