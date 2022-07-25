//
//  HelpViewController.swift
//  Reqs
//
//  Created by Joseph Gilmore on 7/20/22.
//

import UIKit

class HelpViewController: UIViewController {
    override func viewDidLoad() {
        configureView()

    }
    
    func configureView() {
        navigationItem.title = "Help"
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.barTintColor = .systemBackground
        navigationItem.rightBarButtonItem?.tintColor = .label
        navigationController?.navigationBar.isTranslucent = false
    }
}

extension HelpViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "Help settings text placeholder"
        cell.selectionStyle = .none
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
