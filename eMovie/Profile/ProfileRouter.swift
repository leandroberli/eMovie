//
//  ProfileRouter.swift
//  eMovie
//
//  Created by Leandro Berli on 05/11/2022.
//

import Foundation
import UIKit

protocol ProfileRouterProtocol {
    static func createProfileModule() -> UIViewController
    func navigateAfterLogoutAction(fromView: UIViewController?)
}

class ProfileRouter: ProfileRouterProtocol {
    static func createProfileModule() -> UIViewController {
        let viewController: ProfileViewController = ProfileViewController()
        var interactor: ProfileInteractorProtocol = ProfileInteractor()
        let router: ProfileRouterProtocol = ProfileRouter()
        let presenter = ProfilePresenter(view: viewController, interactor: interactor, router: router)
        viewController.presenter = presenter
        interactor.presenter = presenter
        
        let item3 = UITabBarItem(title: "Profile", image: UIImage(systemName: "person"), selectedImage: UIImage(systemName: "person.fill"))
        viewController.tabBarItem = item3
        
        return viewController
    }
    
    func navigateAfterLogoutAction(fromView: UIViewController?) {
        let loginModule = LoginRouter.createLoginModule()
        
        fromView?.tabBarController?.viewControllers?.append(loginModule)
        fromView?.tabBarController?.viewControllers?.removeAll(where: { $0 == fromView })
        
        fromView?.navigationController?.pushViewController(loginModule, animated: true)
    }
    
}
