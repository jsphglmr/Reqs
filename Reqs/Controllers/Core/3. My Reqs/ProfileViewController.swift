//
//  ProfileViewController.swift
//  Reqs
//
//  Created by Joseph Gilmore on 4/24/22.
//
// MARK: - Add Table View


import UIKit
import RealmSwift

//MARK: - UIViewController
class ProfileViewController: UIViewController {
    
    let realm = try! Realm()
    var profileList: Results<ProfileModel>?
    
    private let profileTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadProfiles()
        setupNavigation()
        
        profileTableView.delegate = self
        profileTableView.dataSource = self
    }
    
    private func loadProfiles() {
        profileList = realm.objects(ProfileModel.self)
        view.addSubview(profileTableView)
        profileTableView.frame = view.bounds
        profileTableView.reloadData()
    }
    
    private func setupNavigation() {
        let width = view.frame.width
        let navBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: width, height: 44))
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAddButton))

        view.addSubview(navBar)
        navigationItem.rightBarButtonItem = addButton
        navigationItem.title = "Reqs List"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.barTintColor = .systemBackground
        navigationItem.rightBarButtonItem?.tintColor = .label
        navigationController?.navigationBar.isTranslucent = false
    }
    
    @objc private func didTapAddButton() {
        print("button pressed")
        var textField = UITextField()
        let newProfile = UIAlertController(title: "Add new Req profile", message: nil, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        let add = UIAlertAction(title: "Add", style: .default, handler: { action in
            //realm add + save fn
            if textField.text != "" {
                let newProfile = ProfileModel()
                newProfile.profile = textField.text!
                self.save(profile: newProfile)
            } else {
                return
            }
        })
        newProfile.addAction(cancel)
        newProfile.addAction(add)
        newProfile.addTextField { (alertTextField) in
            alertTextField.placeholder = "Add new profile"
            textField = alertTextField
        }

        present(newProfile, animated: true, completion: nil)
    }
}

//MARK: - Tableview Delegate & Datasource
extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    //datasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profileList?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let selectedProfile = profileList?[indexPath.row]
        cell.textLabel?.text = selectedProfile?.profile
        return cell
    }
    
    //delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let reqsVC = ReqsViewController()
        navigationController?.pushViewController(reqsVC, animated: true)
    }

//MARK:  Data persistance / Realm
    func save(profile: ProfileModel) {
        do {
            try realm.write({
                realm.add(profile)
            })
        } catch {
            print("error saving : \(error)")
        }
        profileTableView.reloadData()
    }
}
