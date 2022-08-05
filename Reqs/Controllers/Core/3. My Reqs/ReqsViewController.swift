//
//  ReqsViewController.swift
//  Reqs
//
//  Created by Joseph Gilmore on 8/4/22.
//

import UIKit
import RealmSwift

//MARK: - UIViewController
class ReqsViewController: UIViewController {
    
    lazy var realm: Realm = {
        return try! Realm()
    }()
    
    var reqsList: Results<ReqsModel>? {
        didSet {
            profileTableView.reloadData()
        }
    }
    var business: Business?
    
    private let profileTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigation()
        loadReqs()
        
        profileTableView.delegate = self
        profileTableView.dataSource = self
    }
    
    private func loadReqs() {
        reqsList = realm.objects(ReqsModel.self)
        view.addSubview(profileTableView)
        profileTableView.frame = view.bounds
        profileTableView.reloadData()
    }
    
    private func setupNavigation() {
        navigationItem.title = "Reqs List"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.barTintColor = .systemBackground
        navigationItem.rightBarButtonItem?.tintColor = .label
        navigationController?.navigationBar.isTranslucent = false
    }
}

//MARK: - Tableview Delegate & Datasource
extension ReqsViewController: UITableViewDelegate, UITableViewDataSource {
    //datasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reqsList?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let selectedProfile = reqsList?[indexPath.row]
        cell.textLabel?.text = selectedProfile?.name.capitalized
        return cell
    }
    
    //delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let annotationVC = AnnotationViewController(business: indexPath.row)
//        navigationController?.pushViewController(annotationVC, animated: true)
    }

// TODO: Add Delete from Realm CRUD op
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            tableView.deleteRows(at: [indexPath], with: .fade)
//            //TODO: Remove from Realm
//        }
//    }


}
