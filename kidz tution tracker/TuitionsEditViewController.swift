//
//  TuitionsEditViewController.swift
//  kidz tuition tracker
//
//  Created by Sendhil kumar Gurunathan on 3/19/16.
//  Copyright © 2016 Sendhil kumar Gurunathan. All rights reserved.
//

import UIKit
import CoreData

class TuitionsEditViewController: UITableViewController , UITextFieldDelegate , //UINavigationControllerDelegate ,
UIPickerViewDataSource , UIPickerViewDelegate ,  DayChangeControllerDelegate{
    
    var managedObjectContext: NSManagedObjectContext!
    var tuition : Tuition?

    @IBOutlet weak var saveButton: UIBarButtonItem!

    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    @IBOutlet weak var tuitionTimePicker: UIDatePicker!
    
    @IBOutlet weak var payDayPicker: UIPickerView!
    
    
    @IBOutlet weak var tuitionNameText: UITextField!
    
    @IBOutlet weak var personNameText: UITextField!
    
    @IBOutlet weak var selectedDaysLabel: UILabel!
    
    @IBOutlet weak var payPerClassText: UITextField!
    
    let dayPickerData = [
        [1,2,3,4,5,6,7,8,9,10,11,12,
            13,14,15,16,16,18 ,19,20,21,22,23,24,25,26,27,28,29,30,31]
    ]
    var selectedDays = [Int]()

    override func viewDidLoad() {
        super.viewDidLoad()
        tuitionNameText.delegate = self
        personNameText.delegate = self
        payPerClassText.delegate = self
        if let tutionToEdit = tuition {
            tuitionNameText.text = tutionToEdit.name
            personNameText.text = tutionToEdit.personname
            payPerClassText.text = String( tutionToEdit.amount!)
            
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat =  "HH:mm"
            
            if let date = dateFormatter.dateFromString(tutionToEdit.time!) {
                tuitionTimePicker.date = date
                
            }
            
            if let frequency = tutionToEdit.frequency {
                DaysChanged(frequency)
              //  tutionDayPicker.selectedDays = frequency
            }
            
            if let payOn = tutionToEdit.payon{
                payDayPicker.selectRow(Int( payOn)-1, inComponent: 0, animated: true)
            }
            
        }

    }
    
    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if(textField == tuitionNameText)
        {
            tuitionNameText.resignFirstResponder()
        }
        else if textField == personNameText
        {
            payPerClassText.resignFirstResponder()
        }
        else
        {
            payPerClassText.resignFirstResponder()
        }
        
        
        return true
    }
    
    //MARK: Picker
    @available(iOS 2.0, *)
    internal func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int{
        if pickerView == payDayPicker{
            return dayPickerData.count
        }
        
        return 0
        
    }
    
    // returns the # of rows in each component..
    @available(iOS 2.0, *)
    internal func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        
        if pickerView == payDayPicker{
            return dayPickerData[component].count
        }
        
        return 0
        
    }
    func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let myAttribute = [ NSFontAttributeName: UIFont(name: "Chalkduster", size: 18.0)! ]
        
        let result = NSAttributedString(string: String( dayPickerData[component][row]) , attributes: myAttribute);
        return result
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "daysListSeague" {
            if let controller = segue.destinationViewController as? DayListTableViewController
            {
                controller.delegate = self
                controller.selectedDays = selectedDays
                
            }
        }
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    @IBAction func saveAction(sender: UIBarButtonItem) {
        
        let name = tuitionNameText.text
        let personName = personNameText.text
        let amount =  payPerClassText.text

        
        if let isEmpty = name?.isEmpty where isEmpty == true {
            Utils.showAlertWithTitle(self, title: "Error", message: "Please enter the tution name", cancelButtonTitle: "OK") ;
            return
        }
        if let isEmpty = personName?.isEmpty where isEmpty == true {
            Utils.showAlertWithTitle(self, title: "Error", message: "Please enter the person name attending the tuition ", cancelButtonTitle: "OK") ;
            return
        }
        
        
        if selectedDays.isEmpty
        {
            Utils.showAlertWithTitle(self, title: "Error", message: "Please select the tuition days", cancelButtonTitle: "OK") ;
            return
        }
        
        if let isEmpty = amount?.isEmpty where isEmpty == true {
            Utils.showAlertWithTitle(self, title: "Error", message: "Please enter the fee amount", cancelButtonTitle: "OK") ;
            return
        }
        else
        {
            let decimalAmount = NSDecimalNumber(string: amount)
            
            if decimalAmount == NSDecimalNumber.notANumber() {
                if decimalAmount == NSDecimalNumber.notANumber() {
                    Utils.showAlertWithTitle(self, title: "Error", message: "Please enter a valid fee amount", cancelButtonTitle: "OK") ;
                    return
                return
            }
        }
        
        
        let formatter = NSDateFormatter()
        formatter.dateFormat =  "HH:mm"
        let time = formatter.stringFromDate(tuitionTimePicker.date)
        
        let day = dayPickerData[0][payDayPicker.selectedRowInComponent(0)]
        
        if let tutionToEdit = tuition {
            tutionToEdit.setValue(name, forKey: "name")
            tutionToEdit.setValue(selectedDays, forKey: "frequency")
            tutionToEdit.setValue(time, forKey: "time")
            tutionToEdit.setValue(day, forKey: "payon")
            tutionToEdit.setValue(personName, forKey: "personname")
            tutionToEdit.setValue(NSDecimalNumber(string: amount), forKey: "amount")
            
            
            
            do {
                // Save Record
                try tutionToEdit.managedObjectContext?.save()
                
                dismissViewControllerAnimated(true, completion: nil)
                
            } catch {
                let saveError = error as NSError
                print("\(saveError), \(saveError.userInfo)")
                
                // Show Alert View
                Utils.showAlertWithTitle(self, title: "Error", message: "Failed to save the tuition details", cancelButtonTitle: "OK") ;
                

            }
        }
        

    }
    }

    
    @IBAction func cancelAction(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    
    // MARK: - Custom Delegates
    func DaysChanged(days :[Int]){
        selectedDays = days
        selectedDaysLabel.text = Utils.GetRepeatLabel(days)
        
    }
    
}
