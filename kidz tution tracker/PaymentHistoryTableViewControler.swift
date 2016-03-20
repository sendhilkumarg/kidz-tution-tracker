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

class PaymentHistoryTableViewControler: UITableViewController , PaymentChangeControllerDelegate {
    let managedObjectContext = TuitionTrackerDataController.sharedInstance.managedObjectContext //TuitionTrackerDataController().managedObjectContext

   // let managedObjectContext = TuitionTrackerDataController().managedObjectContext
    var tuitionObjectId : NSManagedObjectID?
    var tuition : Tuition?
    var paymentList : [Payment] = [];
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let sortDescriptor1 = NSSortDescriptor(key: "date", ascending: false)
        
        for item in tuition!.relPayment!.sortedArrayUsingDescriptors([sortDescriptor1]) {
            //  print(item)
            paymentList.append(item as! Payment)
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
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
        
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return paymentList.count
        
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
        //let attendance = fetchedResultsController.objectAtIndexPath(indexPath) as! Attendance
        let payment = paymentList[indexPath.row]
        
        cell.dayLabel.text = Utils.ToLongDateString( payment.date!)
        if let status = payment.status {
            cell.statusLabel.text =  payment.CurrentStatus.displaytext;
            
        }
        else
        {
            cell.statusLabel.text = "Pending"
        }
    }

    // MARK: Prepare for Segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "seagueEditPaymentItem" {
            if let controller = segue.destinationViewController as? PaymentEditController
            {
                if let indexPath = tableView.indexPathForSelectedRow {
                    controller.payment = paymentList[indexPath.row]
                    controller.atIndexPath = indexPath
                    controller.objectId = paymentList[indexPath.row].objectID
                    controller.delegate = self
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
            paymentList[atIndexPath.row].status = NSInteger(status.rawValue)
            let cell = tableView.cellForRowAtIndexPath(atIndexPath) as! PaymentHistoryCell
            configureCell(cell, atIndexPath: atIndexPath)
            
            
        } catch {
            let saveError = error as NSError
            print("\(saveError), \(saveError.userInfo)")
            
            // Show Alert View
            Utils.showAlertWithTitle(self, title: "Error", message: "error", cancelButtonTitle: "Cancel")
        }
    }
    



}
