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
    func requestSessionToken(withData: SessionTokenData)
}

class LoginInteractor: LoginInteractorProtocol {
    func requestSessionToken(withData: SessionTokenData) {
        httpClient?.createSessionToken(sessionTokenRequest: withData) { token, error in
            UserDefaults.standard.set(token, forKey: "sessionToken")
        }
    }
    
    var presenter: LoginPresenterProtocol?
    
    var httpClient: HTTPClientProtocol?
    
    init(httpClient: HTTPClientProtocol?) {
        self.httpClient = httpClient
    }
    
    func requestToken() {
        httpClient?.createRequestToken { res, err in
            if let e = err {
                print(e.localizedDescription)
                return
            }
            self.presenter?.didReceivedRequestToken(res?.request_token ?? "")
        }
    }
    
    func validateWithLogin(withData: LoginRequest) {
        httpClient?.validateWithLogin(loginData: withData) { res, error in
            if let e = error {
                print(e.localizedDescription)
                return
            }
            self.presenter?.didValidateLogin(requestToken: res?.request_token ?? "" )
        }
    }
    
}
