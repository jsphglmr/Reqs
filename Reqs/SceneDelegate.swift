//
//  SceneDelegate.swift
//  Reqs
//
//  Created by Joseph Gilmore on 4/23/22.
//

import UIKit
import RealmSwift


class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        //MARK: Used to get rid of Storyboards
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        
        let launchedBefore = UserDefaults.standard.bool(forKey: "hasLaunched")
        var vc = UIViewController()
        if launchedBefore {
            vc = MainTabbarViewController()
        } else {
            vc = OnboardingViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
            UserDefaults.standard.set(true, forKey: "hasLaunched")
        }

        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        window?.rootViewController = vc
        window?.makeKeyAndVisible()
    }
}

