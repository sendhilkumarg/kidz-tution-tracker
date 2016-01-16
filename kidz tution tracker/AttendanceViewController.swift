//
//  FirstViewController.swift
//  kidz tution tracker
//
//  Created by Sendhil kumar Gurunathan on 1/13/16.
//  Copyright © 2016 Sendhil kumar Gurunathan. All rights reserved.
//

import UIKit
import CoreData
class AttendanceViewController: UIViewController {
let managedObjectContext = TuitionTrackerDataController().managedObjectContext
  
    @IBOutlet weak var containerView: UIView!
     weak var currentViewController: UIViewController?

    
    override func viewDidLoad() {
        self.currentViewController = self.storyboard?.instantiateViewControllerWithIdentifier("pendingAttendance")
        self.currentViewController!.view.translatesAutoresizingMaskIntoConstraints = false
        self.addChildViewController(self.currentViewController!)
        self.addSubview(self.currentViewController!.view, toView: self.containerView)
        super.viewDidLoad()
        //savedata()
        //fetch()
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func savedata(){
        
        let tution = NSEntityDescription.insertNewObjectForEntityForName("Tuition", inManagedObjectContext: managedObjectContext) as! Tution
        tution.setValue("Music1", forKey: "name")
        
        do {
            try  managedObjectContext.save()
            // print("saved the data")
            
        } catch {
            fatalError("Failure to save context: \(error)")
        }

    }
    
    func fetch(){
        var tutionFetch =  NSFetchRequest(entityName: "Tuition")
        do{
            let fectchedTutions = try managedObjectContext.executeFetchRequest(tutionFetch) as! [Tution]
            print(fectchedTutions.first!.name!)
        }catch {
             fatalError("Failure to read from context: \(error)")
        }
        
    }
    
    func addSubview(subView:UIView, toView parentView:UIView) {
        parentView.addSubview(subView)
        
        
        var viewBindingsDict = [String: AnyObject]()
        viewBindingsDict["subView"] = subView
        parentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[subView]|",
            options: [], metrics: nil, views: viewBindingsDict))
        parentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[subView]|",
            options: [], metrics: nil, views: viewBindingsDict))

    }
/*
    func cycleFromViewController(oldViewController: UIViewController, toViewController newViewController: UIViewController) {
        oldViewController.willMoveToParentViewController(nil)
        self.addChildViewController(newViewController)
        self.addSubview(newViewController.view, toView:self.containerView!)
        newViewController.view.alpha = 0
        newViewController.view.layoutIfNeeded()
        UIView.animateWithDuration(0.5, animations: {
            newViewController.view.alpha = 1
            oldViewController.view.alpha = 0
            },
            completion: { finished in
                oldViewController.view.removeFromSuperview()
                oldViewController.removeFromParentViewController()
                newViewController.didMoveToParentViewController(self)
        })
    }
    */
    func cycleFromViewController(oldViewController: UIViewController, toViewController newViewController: UIViewController) {
        oldViewController.willMoveToParentViewController(nil)
        self.addChildViewController(newViewController)
        self.addSubview(newViewController.view, toView:self.containerView!)
        // TODO: Set the starting state of your constraints here
        newViewController.view.layoutIfNeeded()
        
        // TODO: Set the ending state of your constraints here
        
        UIView.animateWithDuration(0.5, animations: {
            // only need to call layoutIfNeeded here
            newViewController.view.layoutIfNeeded()
            },
            completion: { finished in
                oldViewController.view.removeFromSuperview()
                oldViewController.removeFromParentViewController()
                newViewController.didMoveToParentViewController(self)
        })
    }
    
  
    @IBAction func showComponent(sender: UISegmentedControl) {
        
        if sender.selectedSegmentIndex == 0 {
            let newViewController = self.storyboard?.instantiateViewControllerWithIdentifier("pendingAttendance")
            newViewController!.view.translatesAutoresizingMaskIntoConstraints = false
            self.cycleFromViewController(self.currentViewController!, toViewController: newViewController!)
            self.currentViewController = newViewController
        } else {
            let newViewController = self.storyboard?.instantiateViewControllerWithIdentifier("historyAttendance")
            newViewController!.view.translatesAutoresizingMaskIntoConstraints = false
            self.cycleFromViewController(self.currentViewController!, toViewController: newViewController!)
            self.currentViewController = newViewController
        }
    }

}

