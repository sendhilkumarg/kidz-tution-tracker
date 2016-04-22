//
//  Attendance+CoreDataProperties.swift
//  Kidz Tuition Tracker
//
//  Created by Sendhil kumar Gurunathan on 4/16/16.
//  Copyright © 2016 Sendhil kumar Gurunathan. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Attendance {

    @NSManaged var date: NSDate?
    @NSManaged var isadhoc: NSNumber?
    @NSManaged var notes: String?
    @NSManaged var paymentrequired: NSNumber?
    @NSManaged var status: NSNumber?
    @NSManaged var relTuition: Tuition?

}
