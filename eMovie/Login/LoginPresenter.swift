//
//  LoginPresenter.swift
//  eMovie
//
//  Created by Leandro Berli on 04/11/2022.
//

import Foundation

protocol LoginPresenterProtocol {
    var interactor: LoginInteractorProtocol? { get set }
    var view: LoginViewController? { get set }
    var router: LoginRouterProtocol? { get set }
    
    func didReceivedRequestToken(_ token: String)
    func didReceivedSessionToken(_ token: String)
    func didValidateLogin(requestToken: String)
    func getRequestToken()
    func validateLogin(witData: LoginRequest)
    func didTapLoginButton(usermane: String, password: String)
}

class LoginPresenter: LoginPresenterProtocol {
    var interactor: LoginInteractorProtocol?
    var view: LoginViewController?
    var router: LoginRouterProtocol?
    
    var username = ""
    var password = ""
    
    init(interactor: LoginInteractorProtocol, view: LoginViewController, router: LoginRouterProtocol) {
        self.interactor = interactor
        self.view = view
        self.router = router
    }
    
    func didTapLoginButton(usermane: String, password: String) {
        self.username = usermane
        self.password = password
        
        getRequestToken()
    }
    
    func getRequestToken() {
        interactor?.requestToken()
    }
    
    func didReceivedRequestToken(_ token: String) {
        let request = LoginRequest(username: username, password: password, request_token: token)
        validateLogin(witData: request)
    }
    
    func validateLogin(witData: LoginRequest) {
        interactor?.validateWithLogin(withData: witData)
    }
    
    func didValidateLogin(requestToken: String) {
        print("LoginValidate")
        let data = SessionTokenRequest(request_token: requestToken)
        interactor?.requestSessionToken(withData: data)
    }
    
    func didReceivedSessionToken(_ token: String) {
        router?.finishLoginProcess(fromView: self.view)
    }
  
}
