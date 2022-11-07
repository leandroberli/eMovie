//
//  PlataformProviderView.swift
//  eMovie
//
//  Created by Leandro Berli on 06/11/2022.
//

import Foundation
import UIKit

class PlatfromProviderView: UIView {
    
    var label: UILabel!
    var imageView: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func configure() {
        self.backgroundColor = .systemGray6
        imageView = UIImageView()
        self.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 30).isActive = true
        imageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        imageView.image = UIImage(named: "hbo-go-icon")
        
        label = UILabel()
        label.text = "Netflix"
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        self.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 8).isActive = true
        label.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
}
