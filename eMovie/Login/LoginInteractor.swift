//
//  LoginInteractor.swift
//  eMovie
//
//  Created by Leandro Berli on 04/11/2022.
//

import Foundation

protocol LoginInteractorProtocol {
    var httpClient: HTTPClientProtocol? { get set }
    var presenter: LoginPresenterProtocol? { get set}
    
    func requestToken()
    func validateWithLogin(withData: LoginRequest)
    func requestSessionToken(withData: SessionTokenRequest)
}

class LoginInteractor: LoginInteractorProtocol {
    var presenter: LoginPresenterProtocol?
    var httpClient: HTTPClientProtocol?
    
    init(httpClient: HTTPClientProtocol?) {
        self.httpClient = httpClient
    }
    
    //First. We request a "request token". Then we validate the token with login.
    func requestToken() {
        httpClient?.createRequestToken { res, err in
            if let e = err {
                print(e.localizedDescription)
                return
            }
            DispatchQueue.main.async {
                self.presenter?.didReceivedRequestToken(res?.request_token ?? "")
            }
        }
    }
    
    //Second. Validate the request token received with username and password.
    func validateWithLogin(withData: LoginRequest) {
        httpClient?.validateWithLogin(loginData: withData) { res, error in
            if let e = error {
                print(e.localizedDescription)
                return
            }
            DispatchQueue.main.async {
                self.presenter?.didValidateLogin(requestToken: res?.request_token ?? "" )
            }
        }
    }
    
    //Third and finally. We ask for session token sending "request token". We'll use session token
    //For authenticated requests.
    func requestSessionToken(withData: SessionTokenRequest) {
        httpClient?.createSessionToken(sessionTokenRequest: withData) { token, error in
            UserDefaults.standard.set(token, forKey: "sessionToken")
            DispatchQueue.main.async {
                self.presenter?.didReceivedSessionToken(token ?? "")
            }
        }
    }
    
}
