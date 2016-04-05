//
//  TuitionsAddViewController.swift
//  kidz tuition tracker
//
//  Created by Sendhil kumar Gurunathan on 3/17/16.
//  Copyright © 2016 Sendhil kumar Gurunathan. All rights reserved.
//

import UIKit
import CoreData

class TuitionsAddViewController: UITableViewController , UITextFieldDelegate , UINavigationControllerDelegate ,
UIPickerViewDataSource , UIPickerViewDelegate ,  DayChangeControllerDelegate {
    let managedObjectContext = TuitionTrackerDataController.sharedInstance.managedObjectContext
    

    
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
        payPerClassText.keyboardType = .DecimalPad
        
        let currencyLabel = UILabel(frame: CGRectZero)
        currencyLabel.text = NSNumberFormatter().currencySymbol
        currencyLabel.font = payPerClassText.font
        currencyLabel.textAlignment = .Right
        currencyLabel.sizeToFit()
        currencyLabel.frame.size.width += 10
        payPerClassText.leftView = currencyLabel
        payPerClassText.leftViewMode = .Always

        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat =  "HH:mm"
        
        if let date = dateFormatter.dateFromString("07:00") {
            tuitionTimePicker.date = date
            
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
        let attribute = [ NSFontAttributeName: UIFont(name: "Trebuchet MS", size: 18.0)! ]
        
        let result = NSAttributedString(string: String( dayPickerData[component][row]) , attributes: attribute);
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
    
    @IBAction func cancelAction(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
        
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
                Utils.showAlertWithTitle(self, title: "Error", message: "Please enter a valid fee amount", cancelButtonTitle: "OK") ;
                return
            }
        }
        
        let formatter = NSDateFormatter()
        formatter.dateFormat =  "HH:mm"
        let time = formatter.stringFromDate(tuitionTimePicker.date)
        
        let day = dayPickerData[0][payDayPicker.selectedRowInComponent(0)]
        
        // Create Entity
        let entity = NSEntityDescription.entityForName("Tuition", inManagedObjectContext: self.managedObjectContext)
        
        // Initialize Record
        let record = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: self.managedObjectContext)

        
        // Populate Record
        record.setValue(name, forKey: "name")
        record.setValue(selectedDays, forKey: "frequency")
        record.setValue(time, forKey: "time")
        record.setValue(day, forKey: "payon")
        record.setValue(personName, forKey: "personname")
        record.setValue( NSDecimalNumber(string: amount), forKey: "amount")
        //record.setValue(NSDate(), forKey: "startdate")
        
        let dayToProcess = NSCalendar.currentCalendar().dateByAddingUnit(
            .Day,
            value: -60,
            toDate: NSDate(),
            options: NSCalendarOptions(rawValue: 0))
        record.setValue(dayToProcess, forKey: "startdate")
        
        
        do {
            // Save Record
            try record.managedObjectContext?.save()
            
            // Dismiss View Controller
            dismissViewControllerAnimated(true, completion: nil)
            
        } catch {
            let saveError = error as NSError
            print("\(saveError), \(saveError.userInfo)")
            
            // Show Alert View
            Utils.showAlertWithTitle(self, title: "Error", message: "Failed to save the tuition details", cancelButtonTitle: "OK") ;

        }
        
        
    }
    
    // MARK: - Custom Delegates
    func DaysChanged(days :[Int]){
        selectedDays = days
        selectedDaysLabel.text = Utils.GetRepeatLabel(days)

    }
    
    
}
