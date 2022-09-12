//
//  AppDelegate.swift
//  Reqs
//
//  Created by Joseph Gilmore on 4/23/22.
//

import UIKit
import RealmSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        //realm configuration
        print("realm model: \(Realm.Configuration.defaultConfiguration.fileURL!)") // local realm file url
        do {
            _ = try Realm()
        } catch {
            print("realm error \(error)")
        }
        return true
    }
}

