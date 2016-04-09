//
//  FirstViewController.swift
//  kidz tution tracker
//
//  Created by Sendhil kumar Gurunathan on 1/13/16.
//  Copyright © 2016 Sendhil kumar Gurunathan. All rights reserved.
//
//  ViewController to display the pending and history views of Attendance
//

import UIKit
import CoreData
class AttendanceViewController: UIViewController {
let managedObjectContext = TuitionTrackerDataController().managedObjectContext
  
    @IBOutlet weak var segmentedControl: UISegmentedControl!
 
    @IBOutlet weak var containerView: UIView!
     weak var currentViewController: UIViewController?

    
    override func viewDidLoad() {
        self.currentViewController = self.storyboard?.instantiateViewControllerWithIdentifier("pendingAttendance")
        self.currentViewController!.view.translatesAutoresizingMaskIntoConstraints = false
        self.addChildViewController(self.currentViewController!)
        Utils.addSubview(self.currentViewController!.view, toView: self.containerView)
       super.viewDidLoad()
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

    func cycleFromViewController(oldViewController: UIViewController, toViewController newViewController: UIViewController) {
        oldViewController.willMoveToParentViewController(nil)
        self.addChildViewController(newViewController)
        Utils.addSubview(newViewController.view, toView:self.containerView!)
        newViewController.view.layoutIfNeeded()
        
        UIView.animateWithDuration(0.5, animations: {
            newViewController.view.layoutIfNeeded()
            },
                                   completion: { finished in
                                    oldViewController.view.removeFromSuperview()
                                    oldViewController.removeFromParentViewController()
                                    newViewController.didMoveToParentViewController(self)
        })
    }

}

