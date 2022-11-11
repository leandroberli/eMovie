//
//  StartOnboardingPresenter.swift
//  eMovie
//
//  Created by Leandro Berli on 10/11/2022.
//

import Foundation

protocol StartOnboardingPresenterProtocol {
    var view: StartOnboardingView? { get set }
    var router: StartOnboardingRouterProtocol? { get set }
    
    func startAppIfUserIsAuthenticated()
    func navigateToLogin()
    func navigateToApp()
}

class StartOnboardingPresenter: StartOnboardingPresenterProtocol {
    var view: StartOnboardingView?
    var router: StartOnboardingRouterProtocol?
    
    init(view: StartOnboardingView, router: StartOnboardingRouterProtocol) {
        self.view = view
        self.router = router
    }
    
    func startAppIfUserIsAuthenticated() {
        if let _ = UserDefaults.standard.value(forKey: "sessionToken") as? String {
            navigateToApp()
        }
    }
    
    func navigateToLogin() {
        self.router?.navigateToLogin(viewController: self.view)
    }
    
    func navigateToApp() {
        self.router?.navigateToApp(viewController: self.view)
    }
}
