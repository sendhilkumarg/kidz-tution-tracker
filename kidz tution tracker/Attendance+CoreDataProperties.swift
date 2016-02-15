//
//  Attendance+CoreDataProperties.swift
//  kidz tuition tracker
//
//  Created by Sendhil kumar Gurunathan on 2/15/16.
//  Copyright © 2016 Sendhil kumar Gurunathan. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Attendance {

    @NSManaged var status: NSNumber?
    @NSManaged var date: NSDate?
    @NSManaged var notes: String?
    @NSManaged var relTuition: Tuition?

}
