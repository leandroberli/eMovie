//
//  LoginPresenter.swift
//  eMovie
//
//  Created by Leandro Berli on 04/11/2022.
//

import Foundation

protocol LoginPresenterProtocol {
    var interactor: LoginInteractorProtocol? { get set }
    var view:LoginViewProtocol? { get set }
    var router: LoginRouterProtocol? { get set }
    
    func didReceivedRequestToken(_ token: String)
    func didValidateLogin(requestToken: String)
    func getRequestToken()
    func validateLogin(witData: LoginRequest)
    func didTapLogin(usermane: String, password: String)
}

class LoginPresenter: LoginPresenterProtocol {
    var interactor: LoginInteractorProtocol?
    var view: LoginViewProtocol?
    var router: LoginRouterProtocol?
    
    var username = ""
    var password = ""
    
    init(interactor: LoginInteractorProtocol, view: LoginViewProtocol, router: LoginRouterProtocol) {
        self.interactor = interactor
        self.view = view
        self.router = router
    }
    
    func didTapLogin(usermane: String, password: String) {
        self.username = usermane
        self.password = password
        
        getRequestToken()
    }
    
    func didReceivedRequestToken(_ token: String) {
        let request = LoginRequest(username: username, password: password, request_token: token)
        validateLogin(witData: request)
    }
    
    func didValidateLogin(requestToken: String) {
        print("LoginValidate")
        let data = SessionTokenData(request_token: requestToken)
        HTTPClient().createSessionToken(sessionTokenRequest: data) { _, _ in }
    }
    
    //1
    func getRequestToken() {
        interactor?.requestToken()
    }
    
    func validateLogin(witData: LoginRequest) {
        interactor?.validateWithLogin(withData: witData)
    }
}
