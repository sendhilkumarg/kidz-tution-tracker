//
//  TuitionsEditViewController.swift
//  kidz tuition tracker
//
//  Created by Sendhil kumar Gurunathan on 1/20/16.
//  Copyright © 2016 Sendhil kumar Gurunathan. All rights reserved.
//

import UIKit
import CoreData

class TuitionsEditViewController: UIViewController , UITextFieldDelegate ,
UIPickerViewDataSource , UIPickerViewDelegate  {
var managedObjectContext: NSManagedObjectContext!
    var tuition : Tuition?
   
    @IBOutlet weak var txtTution: UITextField!

    @IBOutlet weak var personNameText: UITextField!
    
    @IBOutlet weak var tutionDayPicker: DayPickerControl!
    
    @IBOutlet weak var tutionTimePicker: UIDatePicker!
    
    @IBOutlet weak var payPerClassText: UITextField!
    @IBOutlet weak var payDayPicker: UIPickerView!
    
    let dayPickerData = [
        [1,2,3,4,5,6,7,8,9,10,11,12,
            13,14,15,16,16,18 ,19,20,21,22,23,24,25,26,27,28,29,30,31]
    ]
    override func viewDidLoad() {
        super.viewDidLoad()
        txtTution.delegate = self
 personNameText.delegate = self
        payPerClassText.delegate = self
        if let tutionToEdit = tuition {
            txtTution.text = tutionToEdit.name
            personNameText.text = tutionToEdit.personname
            payPerClassText.text = String( tutionToEdit.amount!)
            
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat =  "HH:mm"
            
            if let date = dateFormatter.dateFromString(tutionToEdit.time!) {
                tutionTimePicker.date = date
                           
            }

            
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func saveAction(sender: UIBarButtonItem) {
        /*
        var name : string? /txtTution.text
        
        if let isEmpty = name.isEmpty where isEmpty == false {
            // Update Record
            tuition!.setValue(name, forKey: "name")
            
            do {
                // Save Record
                try tuition!.managedObjectContext?.save()
                
                // Dismiss View Controller
                //navigationController?.popViewControllerAnimated(true)
                dismissViewControllerAnimated(true, completion: nil)
                
            } catch {
                let saveError = error as NSError
                print("\(saveError), \(saveError.userInfo)")
                
                // Show Alert View
                showAlertWithTitle("Warning", message: "Your Tution could not be saved.", cancelButtonTitle: "OK")
            }
            
        } else {
            // Show Alert View
            showAlertWithTitle("Warning", message: "Your Tution needs a name.", cancelButtonTitle: "OK")
        }
        */
    }

    @IBAction func cancelAction(sender: UIBarButtonItem) {
        //navigationController?.popViewControllerAnimated(true)
        dismissViewControllerAnimated(true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    
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
        
        // checkValidMealName()
        navigationItem.title = textField.text;
    }
    
    func checkValidMealName(){
      //  let name = txtTution.text ?? ""
       // saveButton.enabled =  !name.isEmpty
    }
    
    //MARK: Picker
    // returns the number of 'columns' to display.
    //refer http://makeapppie.com/tag/uipickerview-in-swift/ for good sample
    @available(iOS 2.0, *)
    public func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int{
        if pickerView == payDayPicker{
            return dayPickerData.count
        }
        
        return 0
        
    }
    
    // returns the # of rows in each component..
    @available(iOS 2.0, *)
    public func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        
        if pickerView == payDayPicker{
            return dayPickerData[component].count
        }
        
        return 0
        
    }
    
    func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        //let titleData = pickerData[row]
        let myAttribute = [ NSFontAttributeName: UIFont(name: "Chalkduster", size: 18.0)! ]
        /*  if pickerView == timePicker{
        let result = NSAttributedString(string:  timePickerData[component][row] , attributes: myAttribute);
        return result
        }
        else{ */
        let result = NSAttributedString(string: String( dayPickerData[component][row]) , attributes: myAttribute);
        return result
        // }
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        if pickerView == payDayPicker
        {
            let day = dayPickerData[0][payDayPicker.selectedRowInComponent(0)]
            print(day)
            
        }
        
        
        /*      if pickerView == timePicker{
        //hours = timePickerData[0][timePicker.selectedRowInComponent(0)]
        
        // let selectedminute = timePickerData[1][timePicker.selectedRowInComponent(1)]
        //let period = timePickerData[2][timePicker.selectedRowInComponent(2)]
        // print ("time: \(hour)  : \(minute) \(period)")
        
        // print(row.description)
        }
        else
        {*/
        // }
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
