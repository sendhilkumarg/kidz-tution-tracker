//
//  Tuition+CoreDataProperties.swift
//  kidz tuition tracker
//
//  Created by Sendhil kumar Gurunathan on 4/2/16.
//  Copyright © 2016 Sendhil kumar Gurunathan. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Tuition {

    @NSManaged var amount: NSDecimalNumber?
    @NSManaged var frequency: [NSInteger]?
    @NSManaged var name: String?
    @NSManaged var payon: NSNumber?
    @NSManaged var personname: String?
    @NSManaged var startdate: NSDate?
    @NSManaged var time: String?
    @NSManaged var relAttendance: NSSet?
    @NSManaged var relPayment: NSSet?

}
