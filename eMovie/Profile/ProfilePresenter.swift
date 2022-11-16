//
//  ProfilePresenter.swift
//  eMovie
//
//  Created by Leandro Berli on 05/11/2022.
//

import Foundation

protocol ProfilePresenterProtocol {
    var view: ProfileViewController? { get set }
    var interactor: ProfileInteractorProtocol? { get set }
    var router: ProfileRouterProtocol? { get set }
    var providers: [String : [ProviderPlataform]]? { get set }
    
    func didTapLogoutButton()
    func didTapFavoriteItem(at index: Int)
    func didReceivedDeleteSessionData()
    func didReceivedFavoriteMoviesData(_ data: [MovieWrapper])
    func didReceivedAccountDetailsData(_ data: Account?)
    func didReceivedProvidersMoviesData(_ data:  [String : [ProviderPlataform]]?)
    func getAccountDetails()
    func getFavoriteMovies()
}

class ProfilePresenter: ProfilePresenterProtocol {
    var providers: [String : [ProviderPlataform]]?
    
    func didReceivedProvidersMoviesData(_ data:  [String : [ProviderPlataform]]?) {
        self.providers = data
        self.view?.updateCellsForProvidersData(data: nil)
    }
    
    func didTapFavoriteItem(at index: Int) {
        let movie = favorites[index]
        self.router?.navigateToMovieDetail(fromView: self.view, movie: movie.movie)
    }
    
    func didReceivedFavoriteMoviesData(_ data: [MovieWrapper]) {
        self.favorites = data
        self.view?.updateFavoriteMovies(data: data)
        self.interactor?.getProvidersMovies(forMovies: data)
    }
    
    var view: ProfileViewController?
    var interactor: ProfileInteractorProtocol?
    var router: ProfileRouterProtocol?
    var favorites: [MovieWrapper] = []
    
    init(view: ProfileViewController, interactor: ProfileInteractorProtocol, router: ProfileRouterProtocol) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
    
    func getAccountDetails() {
        self.interactor?.getAccountDetail()
    }
    
    func getFavoriteMovies() {
        self.interactor?.getFavoriteMovies()
    }
    
    func didTapLogoutButton() {
        interactor?.deleteSessionToken()
    }
    
    func didReceivedDeleteSessionData() {
        router?.navigateAfterLogoutAction(fromView: self.view)
    }
    
    func didReceivedAccountDetailsData(_ data: Account?) {
        self.view?.updateAccountDetail(withData: data)
    }
}
