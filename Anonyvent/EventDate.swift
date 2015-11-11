//
//  EventDate.swift
//  Anonyvent
//
//  Created by Evan Kohout on 11/1/15.
//  Copyright © 2015 Evan Kohout. All rights reserved.
//

import Foundation

class EventDate {
    class func parse(dateStr: String, format:String="yyyy-MM-dd") -> NSDate {
        var dateFmt = NSDateFormatter()
        dateFmt.timeZone = NSTimeZone.defaultTimeZone()
        dateFmt.dateFormat = format
        return (dateFmt.dateFromString(dateStr))!
    }
}