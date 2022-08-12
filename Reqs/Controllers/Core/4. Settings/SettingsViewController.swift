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
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(SettingsTableViewCell.self, forCellReuseIdentifier: SettingsTableViewCell.identifier)
        table.register(SwitchTableViewCell.self, forCellReuseIdentifier: SwitchTableViewCell.identifier)

        return table
    }()
    
    private let infoView: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        return view
    }()
    
    private var models = [Section]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        settingsTableView.delegate = self
        settingsTableView.dataSource = self
        view.addSubview(settingsTableView)
        settingsTableView.tableFooterView = infoView
        configure()
        viewConstraints()
        setupNavigation()
    }
    
    private func configure() {
        models.append(Section(title: "General", options: [
            .switchCell(model: SettingsSwitchOption(title: "Use Dark Mode", icon: UIImage(systemName: "display"), iconBackgroundColor: .systemGray, isOn: true, handler: {
                
            })),
            .staticCell(model: SettingsOption(title: "Notifications", icon: UIImage(systemName: "bell"), iconBackgroundColor: .systemPink, handler: {
                
            })),
            .staticCell(model: SettingsOption(title: "Location", icon: UIImage(systemName: "location"), iconBackgroundColor: .systemBlue, handler: {
                
            })),
            .staticCell(model: SettingsOption(title: "Privacy", icon: UIImage(systemName: "hand.raised"), iconBackgroundColor: .systemOrange, handler: {
                
            })),
        ]))
        
        models.append(Section(title: "Information", options: [
            .staticCell(model: SettingsOption(title: "Report Issue", icon: UIImage(systemName: "questionmark"), iconBackgroundColor: .systemRed, handler: {
                if let url = URL(string: "https://github.com/jsphglmr/Reqs/issues") {
                    UIApplication.shared.open(url)
                }
            })),
            .staticCell(model: SettingsOption(title: "View on Github", icon: UIImage(systemName: "person"), iconBackgroundColor: .systemGreen, handler: {
                if let url = URL(string: "https://github.com/jsphglmr/Reqs/") {
                    UIApplication.shared.open(url)
                }
            }))
        ]))
    }
    
    private func viewConstraints() {
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
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let section = models[section]
        return section.title
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models[section].options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = models[indexPath.section].options[indexPath.row]

        switch model.self {
        case .staticCell(let model):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingsTableViewCell.identifier, for: indexPath) as? SettingsTableViewCell else {
                return UITableViewCell()
            }
            cell.configure(with: model)
            return cell
        case .switchCell(let model):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SwitchTableViewCell.identifier, for: indexPath) as? SwitchTableViewCell else {
                return UITableViewCell()
            }
            cell.configure(with: model)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let type = models[indexPath.section].options[indexPath.row]
        switch type.self {
        case .staticCell(let model):
            model.handler()
        case .switchCell(let model):
            model.handler()
        }
    }
}

//MARK: - Enums and Structs
enum SettingsOptionType {
    case staticCell(model: SettingsOption)
    case switchCell(model: SettingsSwitchOption)
}

struct SettingsOption {
    let title: String
    let icon: UIImage?
    let iconBackgroundColor: UIColor
    let handler: (() -> Void)
}

struct SettingsSwitchOption {
    let title: String
    let icon: UIImage?
    let iconBackgroundColor: UIColor
    var isOn: Bool
    let handler: (() -> Void)
}

struct Section {
    let title: String
    let options: [SettingsOptionType]
}


