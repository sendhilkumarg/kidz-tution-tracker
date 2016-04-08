//
//  PaymentViewController.swift
//  kidz tuition tracker
//
//  Created by Sendhil kumar Gurunathan on 2/16/16.
//  Copyright © 2016 Sendhil kumar Gurunathan. All rights reserved.
//

import UIKit

class PaymentViewController: UIViewController {

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var containerView: UIView!
    weak var currentViewController: UIViewController?
    override func viewDidLoad() {
        self.currentViewController = self.storyboard?.instantiateViewControllerWithIdentifier("pendingPayment")
        self.currentViewController!.view.translatesAutoresizingMaskIntoConstraints = false
        //self.currentViewController!.view.layoutSubviews()
        self.addChildViewController(self.currentViewController!)
        
        Utils.addSubview(self.currentViewController!.view, toView: self.containerView)
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
    

    @IBAction func showComponent(sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            let newViewController = self.storyboard?.instantiateViewControllerWithIdentifier("pendingPayment")
            newViewController!.view.translatesAutoresizingMaskIntoConstraints = false
            self.cycleFromViewController(self.currentViewController!, toViewController: newViewController!)
            self.currentViewController = newViewController
        } else {
            let newViewController = self.storyboard?.instantiateViewControllerWithIdentifier("historyPayment")
            newViewController!.view.translatesAutoresizingMaskIntoConstraints = false
            self.cycleFromViewController(self.currentViewController!, toViewController: newViewController!)
            self.currentViewController = newViewController
        }
    }

}
