//
//  LoginViewController.swift
//  eMovie
//
//  Created by Leandro Berli on 04/11/2022.
//

import UIKit

protocol LoginViewProtocol {
    var presenter: LoginPresenterProtocol? { get set }
}

class LoginViewController: UIViewController, LoginViewProtocol {
    
    var presenter: LoginPresenterProtocol?
    let inputsTypes = ["username", "password"]
    
    var stackView: UIStackView!
    var header: SectionHeaderView!

    override func viewDidLoad() {
        super.viewDidLoad()
        generateHeader()
        generateForm()
    }
    
    func generateHeader() {
        header = SectionHeaderView()
        header.label.text = "Login"
        self.view.addSubview(header)
        header.translatesAutoresizingMaskIntoConstraints = false
        header.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        header.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 12).isActive = true
        header.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: 12).isActive = true
    }
    
    func generateForm() {
        stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        self.view.addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.topAnchor.constraint(equalTo: self.header.bottomAnchor, constant: 0).isActive = true
        stackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        stackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
        
        inputsTypes.forEach({
            let textfield = LoginTextfield()
            textfield.accessibilityIdentifier = $0
            textfield.placeholder = $0
            stackView.addArrangedSubview(textfield)
            textfield.translatesAutoresizingMaskIntoConstraints = false
            textfield.heightAnchor.constraint(equalToConstant: 40).isActive = true
        })
        stackView.setCustomSpacing(22, after: stackView.subviews.last!)
        
        let button = LoginButton()
        button.setTitle("Access", for: .normal)
        button.addTarget(self, action: #selector(loginAction), for: .touchUpInside)
        stackView.addArrangedSubview(button)
        button.heightAnchor.constraint(equalToConstant: 44).isActive = true
    }
    
    @objc func loginAction(_ sender: Any) {
        var username = ""
        if let usernameTextfield = stackView.subviews.first(where: { $0.accessibilityIdentifier == "username"}) as? UITextField {
            username = usernameTextfield.text ?? ""
        }
        
        var password = ""
        if let passwordTextfield = stackView.subviews.first(where: { $0.accessibilityIdentifier == "password" }) as? UITextField {
            password = passwordTextfield.text ?? ""
        }
        
        presenter?.didTapLoginButton(usermane: username, password: password)
    }

}
