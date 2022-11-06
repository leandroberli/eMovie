//
//  LoginRouter.swift
//  eMovie
//
//  Created by Leandro Berli on 04/11/2022.
//

import Foundation
import UIKit

protocol LoginRouterProtocol {
    static func createLoginModule() -> UIViewController
    func finishLoginProcess(fromView: LoginViewController?)
}

class LoginRouter: LoginRouterProtocol {
    static func createLoginModule() -> UIViewController {
        let loginController = LoginViewController()
        let interactor = LoginInteractor(httpClient: HTTPClient())
        let router = LoginRouter()
        let presenter = LoginPresenter(interactor: interactor, view: loginController, router: router)
        
        loginController.presenter = presenter
        interactor.presenter = presenter
        
        let item3 = UITabBarItem(title: "Profile", image: UIImage(systemName: "person"), selectedImage: UIImage(systemName: "person.fill"))
        loginController.tabBarItem = item3
        
        let nav = UINavigationController(rootViewController: loginController)
        
        return nav
    }
    
    func finishLoginProcess(fromView: LoginViewController?) {
        let profileModule = ProfileRouter.createProfileModule()
        
        fromView?.tabBarController?.viewControllers?.append(profileModule)
        fromView?.tabBarController?.viewControllers?.remove(at: 1)
        
    }
}
