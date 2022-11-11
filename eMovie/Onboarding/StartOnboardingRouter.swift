//
//  StartOnboardingRouter.swift
//  eMovie
//
//  Created by Leandro Berli on 10/11/2022.
//

import Foundation
import UIKit

protocol StartOnboardingRouterProtocol {
    static func generateOnboardingModule() -> UIViewController
    func navigateToApp(viewController: StartOnboardingView?)
    func navigateToLogin(viewController: StartOnboardingView?)
}

class StartOnboardingRouter: StartOnboardingRouterProtocol {
    static func generateOnboardingModule() -> UIViewController {
        var firstController: StartOnboardingView = StartOnboardingViewController()
        let router: StartOnboardingRouterProtocol = StartOnboardingRouter()
        let presenter: StartOnboardingPresenterProtocol? = StartOnboardingPresenter(view: firstController, router: router)
        
        let nav = UINavigationController(rootViewController: firstController)
        
        firstController.presenter = presenter
        return nav
    }
    
    func navigateToLogin(viewController: StartOnboardingView?) {
        guard let loginNav = LoginRouter.createLoginModule() as? UINavigationController,
        let loginController = loginNav.viewControllers[0] as? LoginViewController else {
            return
        }
        loginController.presenter?.fromOnboarding = true
        viewController?.navigationController?.pushViewController(loginController , animated: true)
    }
    
    func navigateToApp(viewController: StartOnboardingView?) {
        let tabBar = TabBarRouter.createTabBarModule()
        tabBar.modalPresentationStyle = .overFullScreen
        viewController?.present(tabBar, animated: true)
    }
    
}
