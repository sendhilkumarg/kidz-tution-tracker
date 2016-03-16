//
//  TuitionsViewController.swift
//  kidz tution tracker
//
//  Created by Sendhil kumar Gurunathan on 1/16/16.
//  Copyright © 2016 Sendhil kumar Gurunathan. All rights reserved.
//

import UIKit
import CoreData
class TuitionsAddViewController: UIViewController , UITextFieldDelegate , UINavigationControllerDelegate ,
    UIPickerViewDataSource , UIPickerViewDelegate ,UITableViewDataSource ,UITableViewDelegate// , UITableViewController ,
{
   
    var managedObjectContext: NSManagedObjectContext!

    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    @IBOutlet weak var txtTution: UITextField!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var tutionTimePicker: UIDatePicker!
    @IBOutlet weak var tutionDayPicker: DayPickerControl!
    @IBOutlet weak var payDayPicker: UIPickerView!
   
    @IBOutlet weak var personNameText: UITextField!

    @IBOutlet weak var payPerClassText: UITextField!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var parentStackView: UIStackView!
    
    @IBOutlet weak var customTableView: UITableView!
    
    let dayPickerData = [
        [1,2,3,4,5,6,7,8,9,10,11,12,
            13,14,15,16,16,18 ,19,20,21,22,23,24,25,26,27,28,29,30,31]
    ]
   

    override func viewDidLoad() {
       
        super.viewDidLoad()
        txtTution.delegate = self
        personNameText.delegate = self
        payPerClassText.delegate = self
        //payPerClassText.keyboardType = .NumberPad
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat =  "HH:mm"
        
        if let date = dateFormatter.dateFromString("07:00") {
            tutionTimePicker.date = date
          
        }
       //parentStackView.v = view.frame.width - 40
      //  self.automaticallyAdjustsScrollViewInsets = false;
        
      /*  scrollView.contentSize = CGSize(width: parentStackView.frame.width, height: parentStackView.frame.height)
        */
    
        customTableView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    /*
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
  
        parentStackView.frame =  CGRectMake(0 , self.view.frame.height * 0.7, self.view.frame.width, self.view.frame.height * 0.3)
        scrollView.contentSize = CGSize(width: parentStackView.frame.width, height: parentStackView.frame.height)
        scrollView.contentInset = UIEdgeInsetsMake(64, 0, 44, 0)
        scrollView.scrollIndicatorInsets = UIEdgeInsetsMake(64, 0, 44, 0)

    }
    */
    
     func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // return the number of sections
        return 1
    }
    
     func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // return the number of rows
        return 2
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
                 return customTableView.dequeueReusableCellWithIdentifier("cell1", forIndexPath: indexPath);// as!
        }
               return customTableView.dequeueReusableCellWithIdentifier("cell2", forIndexPath: indexPath);// as!
        
 
        
     //   return nil
    }
    
    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if(textField == txtTution)
        {
           txtTution.resignFirstResponder()
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
    func textFieldDidBeginEditing(textField: UITextField) {
        //saveButton.enabled = true;
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        navigationItem.title = textField.text;
    }
   
    
    // MARK: - Navigation
/*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if sender === saveButton{
             tuition = NSEntityDescription.insertNewObjectForEntityForName("Tuition", inManagedObjectContext: managedObjectContext) as! Tuition
            
           // tuition = Tuition()
            tuition!.setValue(txtTution.text, forKey: "name")
            do {
                try  managedObjectContext.save()
                
                
            } catch {
                fatalError("Failure to save context: \(error)")
            }
        }
    }
*/
    
    //MARK: Picker
    // returns the number of 'columns' to display.
    //refer http://makeapppie.com/tag/uipickerview-in-swift/ for good sample
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
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        if pickerView == payDayPicker
        {
            let day = dayPickerData[0][payDayPicker.selectedRowInComponent(0)]
            print(day)

        }

    }

   // func override tab
    // MARK: Save
    @IBAction func saveAction(sender: UIBarButtonItem) {
        let name = txtTution.text
        let personName = personNameText.text
        let amount =  payPerClassText.text
        
        let selectedDays = tutionDayPicker.selectedDays;
        
        if let isEmpty = name?.isEmpty where isEmpty == true {
            showAlertWithTitle("Error", message: "Please enter the tution name", cancelButtonTitle: "OK")
            return
        }
        if let isEmpty = personName?.isEmpty where isEmpty == true {
            showAlertWithTitle("Error", message: "Please enter who attends the tution ", cancelButtonTitle: "OK")
            return
        }
        
        
        if selectedDays.isEmpty
        {
             showAlertWithTitle("Error", message: "Please select the tution days", cancelButtonTitle: "OK")
            return
        }
        
        if let isEmpty = amount?.isEmpty where isEmpty == true {
            showAlertWithTitle("Error", message: "Please enter the fee amount", cancelButtonTitle: "OK")
            return
        }
        else
        {
            let decimalAmount = NSDecimalNumber(string: amount)
            
            if decimalAmount == NSDecimalNumber.notANumber() {
                showAlertWithTitle("Error", message: "Please enter a valid fee amount", cancelButtonTitle: "OK")
                return
            }
        }

        let formatter = NSDateFormatter()
        formatter.dateFormat =  "HH:mm"
        let time = formatter.stringFromDate(tutionTimePicker.date)
        
        let day = dayPickerData[0][payDayPicker.selectedRowInComponent(0)]
        
            // Create Entity
            let entity = NSEntityDescription.entityForName("Tuition", inManagedObjectContext: self.managedObjectContext)
            
            // Initialize Record
            let record = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: self.managedObjectContext)
        
        
        //let decimalFormatter = NSNumberFormatter()
       // decimalFormatter.numberStyle = NSNumberFormatter.st
        //var paymentAmount : NSNumber? = decimalFormatter.numberFromString(amount!)
            
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
            value: -69,
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
                showAlertWithTitle("Warning", message: "Your to-do could not be saved.", cancelButtonTitle: "OK")
            }
            

    }
    
    @IBAction func cancelAction(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
/*
       // var x = presentingViewController
       // let isPresentingInAddMode = presentingViewController is UINavigationController;
        if(presentingViewController != nil){
            dismissViewControllerAnimated(true, completion: nil)
        }
        else
        {
            navigationController!.popViewControllerAnimated(true)
        }
*/

    }
    
    
    @IBAction func tutionTimeChanged(sender: UIDatePicker) {
        print(tutionTimePicker.date)
        
        let formatter = NSDateFormatter()
         formatter.dateFormat =  "HH:mm"
       // formatter.timeStyle = .ShortStyle
        print(formatter.stringFromDate(tutionTimePicker.date))
    }

    // MARK: -
    // MARK: Helper Methods
    private func showAlertWithTitle(title: String, message: String, cancelButtonTitle: String) {
        // Initialize Alert Controller
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        
        // Configure Alert Controller
        alertController.addAction(UIAlertAction(title: cancelButtonTitle, style: .Default, handler: nil))
        
        // Present Alert Controller
        presentViewController(alertController, animated: true, completion: nil)
    }
}
