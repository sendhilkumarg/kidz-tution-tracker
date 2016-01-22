//
//  Tuition+CoreDataProperties.swift
//  kidz tuition tracker
//
//  Created by Sendhil kumar Gurunathan on 1/22/16.
//  Copyright © 2016 Sendhil kumar Gurunathan. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Tuition {

    @NSManaged var name: String?
    @NSManaged var frequency: [NSInteger]?
    @NSManaged var hours: NSNumber?
    @NSManaged var payon: NSNumber?
    @NSManaged var personname: String?
    @NSManaged var minutes: NSNumber?
    @NSManaged var amount: NSDecimalNumber?
    @NSManaged var am: NSNumber?
    @NSManaged var startdate: NSDate?

}
