//
//  DayChangeControllerDelegate.swift
//  Activity Tracker
//
//  Created by Sendhil kumar Gurunathan on 3/17/16.
//  Copyright © 2016 Sendhil kumar Gurunathan. All rights reserved.
//
//  Delegate to update the parent view about the change in selection of the days
//

import Foundation
public protocol DayChangeControllerDelegate{
    func DaysChanged(days :[Int])
}