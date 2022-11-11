//
//  StartOnboardingViewController.swift
//  eMovie
//
//  Created by Leandro Berli on 10/11/2022.
//

import UIKit

protocol StartOnboardingViewProtocol {
    var presenter: StartOnboardingPresenterProtocol? { get set }
    
}

typealias StartOnboardingView = UIViewController & StartOnboardingViewProtocol

class StartOnboardingViewController: StartOnboardingView {
    var presenter: StartOnboardingPresenterProtocol?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        generateViews()
        presenter?.startAppIfUserIsAuthenticated()
    }
    
    private func generateViews() {
        let stackview = UIStackView()
        stackview.axis = .vertical
        self.view.addSubview(stackview)
        stackview.translatesAutoresizingMaskIntoConstraints = false
        stackview.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        stackview.centerYAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerYAnchor).isActive = true
        
        let button = UIButton()
        button.setTitle("Later", for: .normal)
        button.addTarget(self, action: #selector(startApp), for: .touchUpInside)
        let button2 = UIButton()
        button2.setTitle("Login", for: .normal)
        button2.addTarget(self, action: #selector(startLogin), for: .touchUpInside)
        
        stackview.addArrangedSubview(button)
        stackview.addArrangedSubview(button2)
    }
    
    @objc func startApp() {
        presenter?.navigateToApp()
    }
    
    @objc func startLogin() {
        presenter?.navigateToLogin()
    }

}
