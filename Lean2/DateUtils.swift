//
//  DateUtils.swift
//  Lean2
//
//  Created by dongyi228 on 16/7/14.
//  Copyright (c) 2016年 dongyi228. All rights reserved.
//

import Foundation

class DateUtils {
    
    struct Constants {
        static let Seconds_Per_Day = 86400.0
        static let Days_Per_Week = 7.0
        
        static let Today = "今天"
        static let Tomorrow = "明天"
        static let Undefined = "待定"
    }
    
    class func removeTimePart(date: NSDate) -> NSDate? {
        let calendarUnit = NSCalendarUnit.CalendarUnitDay | NSCalendarUnit.CalendarUnitMonth | NSCalendarUnit.CalendarUnitYear
        let dateComponent = NSCalendar.currentCalendar().components(calendarUnit, fromDate: date)
        return NSCalendar.currentCalendar().dateFromComponents(dateComponent)
        
    }
    
    class func today() -> NSDate {
        return DateUtils.removeTimePart(NSDate())!
    }
    
    class func tomorrow() -> NSDate {
        return DateUtils.removeTimePart(NSDate().dateByAddingTimeInterval(Constants.Seconds_Per_Day))!
    }
    
    class func nextWeek() -> NSDate {
        return DateUtils.removeTimePart(NSDate().dateByAddingTimeInterval(Constants.Seconds_Per_Day * Constants.Days_Per_Week))!
    }
    
    class func representationTextOfDate(theDate: NSDate?) -> String {
        
        if let date = theDate {
            
            if (DateUtils.removeTimePart(date)?.compare(DateUtils.today()) == NSComparisonResult.OrderedSame) {
                return Constants.Today
            } else if (DateUtils.removeTimePart(date)?.compare(DateUtils.tomorrow()) == NSComparisonResult.OrderedSame) {
                return Constants.Tomorrow
            } else {
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "MM-dd"
                return dateFormatter.stringFromDate(date)
            }
        }
        
        return Constants.Undefined
    }
    
    class func representationCompleteTextOfDate(theDate: NSDate?) -> String {
        
        if let date = theDate {
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "MM-dd hh:mm"
            return dateFormatter.stringFromDate(date)
        }
        
        return Constants.Undefined
    }
}
