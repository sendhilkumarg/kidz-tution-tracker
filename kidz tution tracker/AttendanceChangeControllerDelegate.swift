//
//  attendanceChangeController.swift
//  kidz tuition tracker
//
//  Created by Sendhil kumar Gurunathan on 2/9/16.
//  Copyright © 2016 Sendhil kumar Gurunathan. All rights reserved.
//

import Foundation
import UIKit
public protocol AttendanceChangeControllerDelegate{
    func StatusChanged(atIndexPath : NSIndexPath, status : AttendanceStatus)
}