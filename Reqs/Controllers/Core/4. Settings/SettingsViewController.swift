//
//  SettingsViewController.swift
//  Reqs
//
//  Created by Joseph Gilmore on 4/24/22.
//
// MARK: - Add Table View


import UIKit

class SettingsViewController: UIViewController {
        
    private let settingsTableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    private let settings = [ "Notifications", "Location Settings", "Privacy", "Help", "About"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        settingsTableView.delegate = self
        settingsTableView.dataSource = self
        view.addSubview(settingsTableView)
        tableViewConfig()
        setupNavigation()
    }
    
    private func tableViewConfig() {
        settingsTableView.frame = view.bounds
        settingsTableView.reloadData()
    }
    
    private func setupNavigation() {
        navigationItem.title = "Settings"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.barTintColor = .systemBackground
        navigationItem.rightBarButtonItem?.tintColor = .label
        navigationController?.navigationBar.isTranslucent = false
    }
    
}
//MARK: - Tableview Delegate & Datasource
extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        settings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = settings[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let notificationVC = NotificationsViewController()
            self.navigationController?.pushViewController(notificationVC, animated: true)
        case 1:
            let locationVC = LocationSettingsViewController()
            self.navigationController?.pushViewController(locationVC, animated: true)
        case 2:
            let privacyVC = PrivacyViewController()
            self.navigationController?.pushViewController(privacyVC, animated: true)
        case 3:
            let helpVC = HelpViewController()
            self.navigationController?.pushViewController(helpVC, animated: true)
        case 4:
            let aboutVC = AboutViewController()
            self.navigationController?.pushViewController(aboutVC, animated: true)
        default:
            break
        }
    }
}
