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
    
    private let profileTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(MyReqsTableViewCell.self, forCellReuseIdentifier: MyReqsTableViewCell.identifier)
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
    
    override func viewWillAppear(_ animated: Bool) {
        profileTableView.reloadData()
    }
    
    private func setupNavigation() {
        navigationItem.title = "Reqs List"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.barTintColor = .systemBackground
        navigationItem.rightBarButtonItem?.tintColor = .label
        navigationController?.navigationBar.isTranslucent = false
    }
    
    func convertReqModelToBusinessModel(_ reqModel: ReqsModel) -> Business {

        let location = Business.Location(city: reqModel.city, country: reqModel.country, state: reqModel.state, address1: reqModel.address1, address2: reqModel.address2, address3: reqModel.address3, zipCode: reqModel.zipCode)
        let coordinates = Business.Coordinates(latitude: reqModel.latitude, longitude: reqModel.longitude)
        let business = Business(name: reqModel.name, url: reqModel.url, imageUrl: reqModel.imageUrl, location: location, coordinates: coordinates, categories: nil, rating: reqModel.rating, price: reqModel.price, phone: reqModel.phone)
        
        return business
    }
}

//MARK: - Tableview Delegate & Datasource
extension ReqsViewController: UITableViewDelegate, UITableViewDataSource {
    //datasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reqsList?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MyReqsTableViewCell.identifier, for: indexPath) as? MyReqsTableViewCell else { return UITableViewCell() }
        cell.accessoryType = .disclosureIndicator
        if let selectedProfile = reqsList?[indexPath.row] {
            cell.set(req: selectedProfile)
            return cell
        }
        return cell
    }
    
    //delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let currentRow = reqsList?[indexPath.row] else { return }
        
        let annotationVC = AnnotationViewController(business: convertReqModelToBusinessModel(currentRow))
        navigationController?.present(annotationVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        .delete
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            //Remove from Realm
            if let reqForDeletion = self.reqsList?[indexPath.row] {
                do {
                    try self.realm.write({
                        self.realm.delete(reqForDeletion)
                        tableView.reloadData()
                    })
                } catch {
                    print("error deleting from realm \(error)")
                }
            }
            tableView.endUpdates()
        }
    }
}
