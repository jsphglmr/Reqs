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
        let width = view.frame.width
        let navBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: width, height: 44))

        view.addSubview(navBar)
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
        //switch to different VCs


        switch indexPath.row {
        case 0:
            let nVC = NotificationsViewController()
            self.navigationController?.pushViewController(nVC, animated: true)
        case 1:
            let lVC = LocationSettingsViewController()
            self.navigationController?.pushViewController(lVC, animated: true)
        case 2:
            let pVC = PrivacyViewController()
            self.navigationController?.pushViewController(pVC, animated: true)
        case 3:
            let hVC = HelpViewController()
            self.navigationController?.pushViewController(hVC, animated: true)
        case 4:
            let aVC = AboutViewController()
            self.navigationController?.pushViewController(aVC, animated: true)
        default:
            break
        }
    }
}
