//
//  MyReqsTableViewCell.swift
//  Reqs
//
//  Created by Joseph Gilmore on 8/8/22.
//

import UIKit

import Kingfisher

class MyReqsTableViewCell: UITableViewCell {
    
    static let identifier = "MyReqsTableViewCell"
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 25
        imageView.layer.masksToBounds = true
        imageView.clipsToBounds = true
        imageView.image = UIImage(systemName: "pin.circle.fill")
        imageView.backgroundColor = .systemBackground
        return imageView
    }()
    
    private let displayName: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let addressLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(iconImageView)
        contentView.addSubview(displayName)
        contentView.addSubview(addressLabel)
        
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureConstraints() {
        let iconImageConstraints = [
            iconImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            iconImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 14),
            iconImageView.heightAnchor.constraint(equalToConstant: 50),
            iconImageView.widthAnchor.constraint(equalToConstant: 50)
        ]
        let displayNameConstraints = [
            displayName.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 20),
            displayName.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
        ]
        let addressLabelConstraints = [
            addressLabel.leadingAnchor.constraint(equalTo: displayName.leadingAnchor),
            addressLabel.topAnchor.constraint(equalTo: displayName.bottomAnchor, constant: 5),
        ]
        
        NSLayoutConstraint.activate(iconImageConstraints)
        NSLayoutConstraint.activate(displayNameConstraints)
        NSLayoutConstraint.activate(addressLabelConstraints)
    }
    
    func set(req: ReqsModel) {
        let url = URL(string: req.imageUrl)
        iconImageView.kf.setImage(with: url)
        displayName.text = req.name
        addressLabel.text = req.address1
    }
}
