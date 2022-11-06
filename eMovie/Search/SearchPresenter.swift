//
//  SearchPresenter.swift
//  eMovie
//
//  Created by Leandro Berli on 06/11/2022.
//

import Foundation

protocol SearchPresenterProtocol {
    var view: SearchView? { get set }
    var interactor: SearchInteractorProtocol? { get set }
    var router: SearchRouterProtocol? { get set }
    var searchResults: [Movie] { get set }
    
    func searchParam(_ string: String)
    func didReceivedSearchResults(data: [Movie])
    func didTapMovie(index: Int)
}

class SearchPresenter: SearchPresenterProtocol {
    var searchResults: [Movie] = []
    
    func searchParam(_ string: String) {
        interactor?.searchQuery(param: string)
    }
    
    func didReceivedSearchResults(data: [Movie]) {
        searchResults = data
        self.view?.updateViewWithResults(data: data)
    }
    
    func didTapMovie(index: Int) {
        router?.navigateToMovieDetail(from: self.view, movie: searchResults[index])
    }
    
    var view: SearchView?
    var interactor: SearchInteractorProtocol?
    var router: SearchRouterProtocol?
    
    init(view: SearchView, interactor: SearchInteractorProtocol, router: SearchRouterProtocol) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}
