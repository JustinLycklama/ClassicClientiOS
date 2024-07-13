//
//  TimeInterval+Extensions.swift
//  ClassicClient
//
//  Created by Justin Lycklama on 2024-07-12.
//

import Foundation

extension TimeInterval {
    public static func from(hours: Int, minutes: Int) -> TimeInterval {
        // Calculate the total number of seconds from hours and minutes
        let totalSeconds = (hours * 3600) + (minutes * 60)
        return TimeInterval(totalSeconds)
    }
    
    public func splitTimeIntervalHourMinute() -> (hours: Int, minutes: Int) {
        // Calculate the total number of minutes
        let totalMinutes = Int(self) / 60
        
        // Calculate the hours component
        let hours = totalMinutes / 60
        
        // Calculate the remaining minutes component
        let minutes = totalMinutes % 60
        
        return (hours, minutes)
    }
}
