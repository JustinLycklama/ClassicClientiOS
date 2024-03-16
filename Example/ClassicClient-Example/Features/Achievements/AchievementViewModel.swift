////
////  AchievementViewModel.swift
////  ClassicClient-Example
////
////  Created by Justin Lycklama on 2020-08-25.
////  Copyright © 2020 CocoaPods. All rights reserved.
////
//
//import ClassicClient
//
//class AchievementViewModel {
//    
//    public static let sharedInstance = AchievementViewModel()
//    
//    private let achievementService: AchievementService
//    
//    init() {
//        achievementService = AchievementService()
//    }
//    
//    public func getAchievements(callback: ((Result<Achievement>) -> Void)?) {
//        achievementService.request { (result: Result<Achievement>) in
//            callback?(result)
//        }
//    }
//}
