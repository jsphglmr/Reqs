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
