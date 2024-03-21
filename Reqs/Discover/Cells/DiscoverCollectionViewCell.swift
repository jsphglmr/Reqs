//
//  DiscoverCollectionViewCell.swift
//  Reqs
//
//  Created by Joseph Gilmore on 6/7/22.
//

import UIKit

class DiscoverCollectionViewCell: UICollectionViewCell {
    static let identifier = "DiscoverCollectionViewCell"
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = true
        label.backgroundColor = .systemBackground
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        contentView.addSubview(label)
    }
    
    required init(coder: NSCoder) {
        fatalError()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = contentView.bounds
        imageView.layer.cornerRadius = 15
        
        let labelConstraints = [
            label.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: imageView.bottomAnchor, constant: -20),
            label.widthAnchor.constraint(equalTo: imageView.widthAnchor)
        ]
        
        NSLayoutConstraint.activate(labelConstraints)
    }
    
    func set(discoverCell: Business) {
        DispatchQueue.main.async {
            let url = URL(string: discoverCell.imageUrl)
            self.imageView.kf.setImage(with: url)
            self.label.text = discoverCell.name
        }
    }
}
