//
//  attendanceChangeController.swift
//  Kidz Tuition Tracker
//
//  Created by Sendhil kumar Gurunathan on 2/9/16.
//  Copyright © 2016 Sendhil kumar Gurunathan. All rights reserved.
//
//  Delegate to handle the attendance status chage events from pending and history views
//

import Foundation
import UIKit
import CoreData
public protocol AttendanceChangeControllerDelegate{
    func StatusChanged(objectId : NSManagedObjectID , status : AttendanceStatus)
}