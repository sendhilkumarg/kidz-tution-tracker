//
//  PaymentChangeControllerDelegate.swift
//  kidz tuition tracker
//
//  Created by Sendhil kumar Gurunathan on 2/17/16.
//  Copyright © 2016 Sendhil kumar Gurunathan. All rights reserved.
//

import Foundation
import UIKit
import CoreData
public protocol PaymentChangeControllerDelegate{
    func StatusChanged(atIndexPath : NSIndexPath,  objectId : NSManagedObjectID, status : PaymentStatus)
}