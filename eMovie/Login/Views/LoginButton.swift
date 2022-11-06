//
//  LoginButton.swift
//  eMovie
//
//  Created by Leandro Berli on 05/11/2022.
//

import Foundation
import UIKit

class LoginButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func configure() {
        //self.buttonType = .custom
        self.backgroundColor = .systemBlue
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
        self.setTitleColor(.white, for: .normal)
        self.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .bold)
    }
}
