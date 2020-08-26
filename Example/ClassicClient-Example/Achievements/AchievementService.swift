//
//  AchievementService.swift
//  ClassicClient-Example
//
//  Created by Justin Lycklama on 2020-08-26.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation
import ClassicClient

class AchievementService: NSObject, FakeServerProtocol {
    typealias T = Achievement
    let dataFileName = "achievements"
}
