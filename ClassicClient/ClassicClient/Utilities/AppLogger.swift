//
//  AppLogger.swift
//  ClassicClient
//
//  Created by Justin Lycklama on 2024-03-16.
//  Copyright © 2024 Justin Lycklama. All rights reserved.
//

import os
import Foundation

import os.log

class AppLogger {
    static let shared = AppLogger()
    
    static let only_debug: Bool = false
    static let displayConstraintWarnings: Bool = true
    
    static func setupLoggerPreferences() {
        if !displayConstraintWarnings {
            UserDefaults.standard.set(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
        }
    }
    
    enum Severity: String {
        case log = "Log"
        case error = "Error"
        case debug = "Debug"
    }
    
    func log(_ messages: CustomStringConvertible?..., severity: Severity = .log) {
        let messageList = messages.compactMap({$0})
        guard messageList.count > 0 else {
            return
        }
        
        DispatchQueue.global(qos: .background).async {
            let output = messageList.reduce(nil) { (partialResult, nextConvertable) -> String? in
                guard let partialResult else {
                    return nextConvertable.description
                }
                
                return "\(partialResult)\n\(nextConvertable.description)"
            }
            
            if let output,
               (!AppLogger.only_debug || (AppLogger.only_debug && severity == .debug)) {
                print("[Logger - \(severity.rawValue.uppercased())] \(output)")
            }
        }
    }
    
    let systemLogger = Logger(subsystem: "com.example.MyApp", category: "DeviceActivityMonitor")

    
    // To view these logs, open the 'Console' app on Mac and click the simulator or phone on the left hand side
    // This is very useful for debugging app extensions or other things where a regular 'print' isn't visible.
    private func systemLog(message: String) {
        systemLogger.log("Notification scheduled with message: Realm path begin \(message, privacy: .public))")

    }
}
