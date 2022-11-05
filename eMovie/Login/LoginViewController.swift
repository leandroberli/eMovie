//
//  LoginViewController.swift
//  eMovie
//
//  Created by Leandro Berli on 04/11/2022.
//

import UIKit

protocol LoginViewProtocol {
    
}

class LoginViewController: UIViewController, LoginViewProtocol {
    
    var presenter: LoginPresenterProtocol?
    let inputsTypes = ["username", "password"]
    
    var stackView: UIStackView!

    override func viewDidLoad() {
        super.viewDidLoad()
        generateForm()
    }
    
    func generateForm() {
        stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        self.view.addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        stackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 20).isActive = true
        
        inputsTypes.forEach({
            let textfield = UITextField()
            textfield.accessibilityIdentifier = $0
            textfield.placeholder = $0
            textfield.backgroundColor = UIColor.systemGray3
            stackView.addArrangedSubview(textfield)
        })
        
        let button = UIButton(type: .custom)
        button.setTitle("Access", for: .normal)
        button.addTarget(self, action: #selector(loginAction), for: .touchUpInside)
        stackView.addArrangedSubview(button)
    }
    
    @objc func loginAction(_ sender: Any) {
        var username = ""
        if let usernameTextfield = stackView.subviews.first(where: { $0.accessibilityIdentifier == "username"}) as? UITextField {
            username = usernameTextfield.text ?? ""
            username = "leandroberli"
        }
        
        var password = ""
        if let passwordTextfield = stackView.subviews.first(where: { $0.accessibilityIdentifier == "password" }) as? UITextField {
            password = passwordTextfield.text ?? ""
            password = "g4t0r4d309"
        }
        
        presenter?.didTapLoginButton(usermane: username, password: password)
    }

}
