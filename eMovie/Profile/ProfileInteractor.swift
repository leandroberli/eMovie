//
//  ProfileInteractor.swift
//  eMovie
//
//  Created by Leandro Berli on 05/11/2022.
//

import Foundation

protocol ProfileInteractorProtocol {
    var httpClient: HTTPClient? { get set }
    var presenter: ProfilePresenterProtocol? { get set }
    
    func getAccountDetail()
    func deleteSessionToken()
}

class ProfileInteractor: ProfileInteractorProtocol {
    var presenter: ProfilePresenterProtocol?
    var httpClient: HTTPClient? = HTTPClient()
    
    func deleteSessionToken() {
        print(#function)
        UserDefaults.standard.removeObject(forKey: "sessionToken")
        print("SessionTokenDelete")
        DispatchQueue.main.async {
            self.presenter?.didReceivedDeleteSessionData()
        }
    }
    
    func getAccountDetail() {
        httpClient?.getAccountDetails { account, error in
            DispatchQueue.main.async {
                self.presenter?.didReceivedAccountDetailsData(account)
            }
        }
    }
}
