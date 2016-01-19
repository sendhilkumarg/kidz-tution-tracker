//
//  TuitionsViewController.swift
//  kidz tution tracker
//
//  Created by Sendhil kumar Gurunathan on 1/16/16.
//  Copyright © 2016 Sendhil kumar Gurunathan. All rights reserved.
//

import UIKit
import CoreData
class TuitionsViewController: UIViewController , UITextFieldDelegate , UINavigationControllerDelegate {
   /*
    let managedObjectContext = TuitionTrackerDataController().managedObjectContext
*/
    var managedObjectContext: NSManagedObjectContext!
    var tuition : Tuition?
        @IBOutlet weak var saveButton: UIBarButtonItem!
    
    @IBOutlet weak var txtTution: UITextField!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    override func viewDidLoad() {
       
        super.viewDidLoad()
        txtTution.delegate = self

        if let tuitionToEdit = tuition {
            txtTution.text = tuitionToEdit.name
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        txtTution.resignFirstResponder()
        return true
    }
    func textFieldDidBeginEditing(textField: UITextField) {
        //saveButton.enabled = true;
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        //lblText1.text = textField.text;
        //saveButton.enabled = false
       // checkValidMealName()
        navigationItem.title = textField.text;
    }
    
    func checkValidMealName(){
        let name = txtTution.text ?? ""
        saveButton.enabled =  !name.isEmpty
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
    
    @IBAction func saveAction(sender: UIBarButtonItem) {
        let name = txtTution.text
        
        if let isEmpty = name?.isEmpty where isEmpty == false {
            // Create Entity
            let entity = NSEntityDescription.entityForName("Tuition", inManagedObjectContext: self.managedObjectContext)
            
            // Initialize Record
            let record = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: self.managedObjectContext)
            
            // Populate Record
            record.setValue(name, forKey: "name")
            //record.setValue(NSDate(), forKey: "createdAt")
            
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
            
        } else {
            // Show Alert View
            showAlertWithTitle("Warning", message: "Your to-do needs a name.", cancelButtonTitle: "OK")
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
