//
//  AppLogger.swift
//  ClassicClient
//
//  Created by Justin Lycklama on 2024-03-16.
//  Copyright © 2024 Justin Lycklama. All rights reserved.
//

import os
import Foundation

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
}
