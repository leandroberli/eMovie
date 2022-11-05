//
//  LoginRouter.swift
//  eMovie
//
//  Created by Leandro Berli on 04/11/2022.
//

import Foundation
import UIKit

protocol LoginRouterProtocol {
   // static func createMovieDetailModule(forMovie: Movie) -> UIViewController
    static func createLoginModule() -> UIViewController
}

class LoginRouter: LoginRouterProtocol {
    static func createLoginModule() -> UIViewController {
        let loginController = LoginViewController()
        let interactor = LoginInteractor(httpClient: HTTPClient())
        let router = LoginRouter()
        let presenter = LoginPresenter(interactor: interactor, view: loginController, router: router)
        
        loginController.presenter = presenter
        interactor.presenter = presenter
        return loginController
    }
}
