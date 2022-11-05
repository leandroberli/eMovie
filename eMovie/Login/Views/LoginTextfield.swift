//
//  LoginTextfield.swift
//  eMovie
//
//  Created by Leandro Berli on 05/11/2022.
//

import Foundation
import UIKit

class LoginTextfield: UITextField {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func configure() {
        self.backgroundColor = .systemGray4
        self.layer.cornerRadius = 4
        self.clipsToBounds = true
        self.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        self.clearButtonMode = .whileEditing
        self.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: 8))
        self.leftViewMode = .always
        self.autocapitalizationType = .none
    }
}
