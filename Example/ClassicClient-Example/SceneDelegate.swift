//
//  SceneDelegate.swift
//  ClassicClient
//
//  Created by Justin Lycklama on 2020-03-19.
//  Copyright © 2020 Justin Lycklama. All rights reserved.
//

import UIKit
import ClassicClient

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    var loginViewController: LoginViewController?

    @available(iOS 13.0, *)
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        
        let contentViewController = HomePageViewController()
        let navController = UINavigationController(rootViewController: contentViewController)
        
        
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            
            
            
            window.rootViewController = navController
            
            let launch = UIStoryboard(name: "LaunchScreen", bundle: nil).instantiateInitialViewController()!
            
            self.window = window
            window.makeKeyAndVisible()
            
            // Present the launch screen to avoid any visible flashes when presenting view controller
//            window.addSubview(launch.view)
//            window.constrainView(launch.view)
//
//            loginViewController = LoginViewController()
//            loginViewController?.modalPresentationStyle = .fullScreen
//            
//            //Using DispatchQueue to prevent "Unbalanced calls to begin/end appearance transitions"
//            DispatchQueue.global().async {
//               // Bounce back to the main thread to update the UI
//               DispatchQueue.main.async {
//                self.window?.rootViewController?.present(self.loginViewController!, animated: false, completion: {
//
//                       UIView.animate(withDuration: 1.5, animations: {
//                           launch.view.alpha = 0
//                       }, completion: { (_) in
//                           launch.view.removeFromSuperview()
//                       })
//                   })
//               }
//            }
        }
    }

    @available(iOS 13.0, *)
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    @available(iOS 13.0, *)
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    @available(iOS 13.0, *)
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    @available(iOS 13.0, *)
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    @available(iOS 13.0, *)
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }

    // MARK: LoginUpdateDelegate
//    func LoginStateUpdated(loggedIn: Bool) {
//        if loggedIn && loginViewController != nil {
//            window?.rootViewController?.dismiss(animated: true, completion: nil)
//            loginViewController = nil
//        } else if !loggedIn && loginViewController == nil {
//            presentNewLoginScreen()
//        }
//    }
        
//    private func presentNewLoginScreen() {
//        loginViewController = LoginViewController()
//        loginViewController?.modalPresentationStyle = .fullScreen
//        if #available(iOS 13.0, *) {
//            loginViewController?.isModalInPresentation = true
//        } else {
//            // Fallback on earlier versions
//        }
//
//        window?.rootViewController?.present(loginViewController!, animated: true, completion: nil)
//    }
}

