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
        //remove storyboards
        //set maintabbar vc as root vc
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        window?.rootViewController = MainTabbarViewController()
        window?.makeKeyAndVisible()
    }
}

