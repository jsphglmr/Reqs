//
//  ReqsViewController.swift
//  Reqs
//
//  Created by Joseph Gilmore on 6/8/22.
//

import UIKit
import RealmSwift

class ReqsViewController: UIViewController {
    
    let realm = try! Realm()
    var reqItems: Results<ReqsModel>?
    var selectedReq: ProfileModel? {
        didSet{
            loadReqs()
        }
    }
    
    private let reqsTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(reqsTableView)
        reqsTableView.delegate = self
        reqsTableView.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        reqsTableView.frame = view.frame
    }
    
    func loadReqs() {

    }
}
//MARK: - Tableview Delegate & Datasource
extension ReqsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reqItems?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.selectionStyle = .none
        return cell
    }
}
