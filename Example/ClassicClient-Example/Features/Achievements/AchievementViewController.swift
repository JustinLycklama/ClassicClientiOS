////
////  AchievementViewController.swift
////  ClassicClient-Example
////
////  Created by Justin Lycklama on 2020-08-24.
////  Copyright © 2020 CocoaPods. All rights reserved.
////
//
//import UIKit
//import ClassicClient
//
//class AchievementViewController: GridViewController {
//
//    private let cellIdentifier = "ACell"
//    private let headerIdentifier = "AHeader"
//
//    var achievements: [Achievement]? {
//        didSet {
//            achievementGroups.removeAll()
//            achievementKeys.removeAll()
//            
//            for achievement in achievements ?? [] {
//                
//                let key = achievement.category
//                if (!achievementGroups.keys.contains(key)) {
//                    achievementGroups[key] = [Achievement]()
//                    achievementKeys.append(key)
//                }
//                
//                achievementGroups[key]!.append(achievement)
//            }
//        }
//    }
//    
//    var achievementGroups = [String : [Achievement]]()
//    var achievementKeys = [String]()
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        title = "Achievements"
//        navigationController?.navigationBar.backgroundColor = .blue
//        
//        super.registerNib(xib: UINib(nibName: "AchievementCollectionViewCell", bundle: nil), identifier: cellIdentifier)
//        
//        super.registerSupplementaryNib(xib: UINib(nibName: "AchievementHeaderCell", bundle: nil), kind: UICollectionView.elementKindSectionHeader, identifier: headerIdentifier)
//        
//        addLoadingView()
//        
//        loadingView?.setLoading(true)
//        AchievementViewModel.sharedInstance.getAchievements { [weak self] (result: Result<Achievement>) in
//            switch result {
//            case .success(let results):
//                self?.achievements = results
//                self?.reloadData()
//                break
//            case .error(_):
//                break;
//            }
//            
//            self?.loadingView?.setLoading(false)
//        }
//        
//    }
//    
//    
//    override func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return achievementKeys.count
//    }
//
//    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return achievementGroups[achievementKeys[section]]?.count ?? 0
//    }
//    
//    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? AchievementCollectionViewCell else {
//            return UICollectionViewCell()
//        }
//        
//        cell.setAchievement(achievement: achievementGroups[achievementKeys[indexPath.section]]?[indexPath.row])
//        
//        return cell
//    }
//    
//    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentifier, for: indexPath) as? AchievementHeaderCell else {
//            return UICollectionReusableView()
//        }
//        
//        header.setTitle(title: achievementKeys[indexPath.section].capitalized)
//        
//        return header
//    }
//    
//
//
//}
