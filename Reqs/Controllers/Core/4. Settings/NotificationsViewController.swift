//
//  NotificationsViewController.swift
//  Reqs
//
//  Created by Joseph Gilmore on 7/20/22.
//

import UIKit

class NotificationsViewController: UIViewController {
    
    var notificationsList = [
        "Recommended Reqs",
        "Daily Reqs",
        "Travel Mode"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()

    }
    
    func configureView() {
        navigationItem.title = "Notifications"
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.barTintColor = .systemBackground
        navigationItem.rightBarButtonItem?.tintColor = .label
        navigationController?.navigationBar.isTranslucent = false
    }
    
}

extension NotificationsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notificationsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = notificationsList[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }

//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//
//    }
}
