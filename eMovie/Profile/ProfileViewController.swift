//
//  ProfileViewController.swift
//  eMovie
//
//  Created by Leandro Berli on 03/11/2022.
//

import UIKit
import WebKit

protocol ProfileViewProtocol {
    var presenter: ProfilePresenterProtocol? { get set }
    
    func updateAccountDetail(withData: Account?)
}

class ProfileViewController: UIViewController, ProfileViewProtocol {
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    
    var presenter: ProfilePresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        generateLogoutButton()
        
        presenter?.getAccountDetails()
    }
    
    func updateAccountDetail(withData: Account?) {
        usernameLabel.text = withData?.username ?? ""
    }
    
    private func generateLogoutButton() {
        let button = UIButton()
        button.setTitle("Logout", for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.addTarget(self, action: #selector(logoutAction), for: .touchUpInside)
        self.view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        button.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
    }
    
    @objc func logoutAction(_ sender: Any) {
        presenter?.didTapLogoutButton()
    }
    
}


