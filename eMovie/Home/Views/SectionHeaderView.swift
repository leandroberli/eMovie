//
//  SectionHeaderView.swift
//  eMovie
//
//  Created by Leandro Berli on 27/10/2022.
//

import UIKit

class SectionHeaderView: UICollectionReusableView {
    static let reuseIdentifier = "header-reuse-identifier"
    
    var label = UILabel()
    var imageView: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}

extension SectionHeaderView {
    
    func confiugreSection(_ section: HomeViewController.Section ) {
        label.text = section.title
        switch section {
        case .recommended:
            imageView.image = UIImage(systemName: "star.fill")
            return
        case .topRated:
            imageView.image = UIImage(systemName: "trophy.fill")
            return
        case .upcoming:
            imageView.image = UIImage(systemName: "timer")
            return
        }
    }
    
    func configure() {
        backgroundColor = .systemBackground
        
        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontForContentSizeCategory = true
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 8),
            label.topAnchor.constraint(equalTo: topAnchor, constant: 27),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20)
        ])
        
        imageView = UIImageView()
        addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([imageView.heightAnchor.constraint(equalToConstant: 18),
                                     imageView.widthAnchor.constraint(equalToConstant: 18),
                                     imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
                                     imageView.centerYAnchor.constraint(equalTo: label.centerYAnchor)
        ])
        imageView.tintColor = .white
    }
}

