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
            let alert = UIAlertController(title: "Info", message: "Body Info", preferredStyle: .alert)
            let cancel = UIAlertAction(title: "Cancel", style: .cancel)
            let mapButton = UIAlertAction(title: "Go to map!", style: .default)
            alert.addAction(cancel)
            alert.addAction(mapButton)
            self.present(alert, animated: true)
        })
    }
}
