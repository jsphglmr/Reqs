//
//  ViewController.swift
//  Reqs
//
//  Created by Joseph Gilmore on 4/23/22.
//

import UIKit

class MainTabbarViewController: UITabBarController {
    
    override func viewDidLoad() {
        view.backgroundColor = .systemBackground
        
        let blurEffect = UIBlurEffect(style: .regular)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        
        let vc1 = UINavigationController(rootViewController: MapViewController())
        let vc2 = UINavigationController(rootViewController: DiscoverViewController())
        let vc3 = UINavigationController(rootViewController: ReqsViewController())
        let vc4 = UINavigationController(rootViewController: SettingsViewController())
        
        vc1.tabBarItem.image = UIImage(systemName: "mappin.circle")
        vc1.tabBarItem.selectedImage = UIImage(systemName: "mappin.circle.fill")
        vc1.title = "Explore"
        
        vc2.tabBarItem.image = UIImage(systemName: "hands.sparkles")
        vc2.tabBarItem.selectedImage = UIImage(systemName: "hands.sparkles.fill")
        vc2.title = "Discover"
        
        vc3.tabBarItem.image = UIImage(systemName: "person")
        vc3.tabBarItem.selectedImage = UIImage(systemName: "person.fill")
        vc3.title = "My Reqs"
        
        vc4.tabBarItem.image = UIImage(systemName: "gearshape")
        vc4.tabBarItem.selectedImage = UIImage(systemName: "gearshape.fill")
        vc4.title = "Settings"
        
        tabBar.tintColor = .label
        
        setViewControllers([vc1, vc2, vc3, vc4], animated: true)
    }
}


