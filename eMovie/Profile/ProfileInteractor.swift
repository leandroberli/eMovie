//
//  ProfileInteractor.swift
//  eMovie
//
//  Created by Leandro Berli on 05/11/2022.
//

import Foundation

protocol ProfileInteractorProtocol: GetProvidersProcessDelegate {
    var httpClient: HTTPClient? { get set }
    var presenter: ProfilePresenterProtocol? { get set }
    var providersProcess: GetProvidersProcessProtocol? { get set }
    
    func getAccountDetail()
    func getFavoriteMovies()
    func getProvidersMovies(forMovies: [MovieWrapper])
    func deleteSessionToken()
}

class ProfileInteractor: ProfileInteractorProtocol {
    func providersDataReceived(_ data: [String : [ProviderPlataform]], forSection: Section) {
        presenter?.didReceivedProvidersMoviesData(data)
    }
    
    var providersProcess: GetProvidersProcessProtocol?
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
    
    func getProvidersMovies(forMovies: [MovieWrapper]) {
        providersProcess?.startProcess(forMovies: forMovies)
    }
    
    func getFavoriteMovies() {
        httpClient?.getFavoritedMovies { res, err in
            DispatchQueue.main.async {
                let data = self.generateMoviesWarappers(res ?? [], forSection: .recommended)
                self.presenter?.didReceivedFavoriteMoviesData(data.reversed())
            }
        }
    }
    
    func getAccountDetail() {
        httpClient?.getAccountDetails { account, error in
            DispatchQueue.main.async {
                self.presenter?.didReceivedAccountDetailsData(account)
            }
        }
    }
    
    func generateMoviesWarappers(_ movies: [Movie], forSection: Section) -> [MovieWrapper] {
        let wrappers = movies.map({ return MovieWrapper(section: forSection, movie: $0)})
        return wrappers
    }
}
