//
//  UIViewController + Utilities.swift
//  Reqs
//
//  Created by Joseph Gilmore on 11/1/22.
//

import UIKit

extension UIViewController {
    func addNavigationHelpItem() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "info.circle"), primaryAction: UIAction { _ in
            let alert = UIAlertController(title: "Getting Started", message: "Use the map to search for places near you. Once you find a place you love or want to try, save it to your list!", preferredStyle: .alert)
            let cancel = UIAlertAction(title: "Cancel", style: .cancel)
            let mapButton = UIAlertAction(title: "Go to map!", style: .default, handler: { _ in
                //move to index 0 of tabbar once tapped
                self.tabBarController?.selectedIndex = 0
            })
            
            alert.addAction(cancel)
            alert.addAction(mapButton)
            self.present(alert, animated: true)
        })
    }
}
