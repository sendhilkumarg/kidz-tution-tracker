//
//  TuitionsEditViewController.swift
//  kidz tuition tracker
//
//  Created by Sendhil kumar Gurunathan on 1/20/16.
//  Copyright © 2016 Sendhil kumar Gurunathan. All rights reserved.
//

import UIKit
import CoreData

class TuitionsEditViewController: UIViewController , UITextFieldDelegate   {
var managedObjectContext: NSManagedObjectContext!
    var tuition : Tuition?
    @IBOutlet weak var txtTution: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // txtTution.delegate = self

        if let tutionToEdit = tuition {
            //print(tutionToEdit)
            txtTution.text = tutionToEdit.name
            
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func saveAction(sender: UIBarButtonItem) {
        let name = txtTution.text
        
        if let isEmpty = name?.isEmpty where isEmpty == false {
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
        txtTution.resignFirstResponder()
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
        let name = txtTution.text ?? ""
       // saveButton.enabled =  !name.isEmpty
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
