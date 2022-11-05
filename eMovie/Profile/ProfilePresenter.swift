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
    
    func didTapLogoutButton()
    func didReceivedDeleteSessionData()
    func didReceivedAccountDetailsData(_ data: Account?)
    func getAccountDetails()
}

class ProfilePresenter: ProfilePresenterProtocol {
    var view: ProfileViewController?
    var interactor: ProfileInteractorProtocol?
    var router: ProfileRouterProtocol?
    
    init(view: ProfileViewController, interactor: ProfileInteractorProtocol, router: ProfileRouterProtocol) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
    
    func getAccountDetails() {
        self.interactor?.getAccountDetail()
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
