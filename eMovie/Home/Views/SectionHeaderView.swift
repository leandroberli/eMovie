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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}

extension SectionHeaderView {
    func configure() {
        backgroundColor = .systemBackground
        
        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontForContentSizeCategory = true
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 8),
            label.topAnchor.constraint(equalTo: topAnchor, constant: 27),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20)
        ])
       
    }
}

