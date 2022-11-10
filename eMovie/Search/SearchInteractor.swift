//
//  SearchInteractor.swift
//  eMovie
//
//  Created by Leandro Berli on 05/11/2022.
//

import Foundation

protocol SearchInteractorProtocol {
    var presenter: SearchPresenterProtocol? { get set }
    var httpClient: HTTPClientProtocol? { get set }
    
    func searchQuery(param: String, page: Int)
    func getMovieProviders(for movieName: String)
}

class SearchInteractor: SearchInteractorProtocol {
    
    func getMovieProviders(for movieName: String) {
        MovieProviderClient().getMovieProvider(movieName: movieName ) { itemProvider, error in
            let providersArray = itemProvider?.platforms ?? []
            DispatchQueue.main.async {
                self.presenter?.platforms.updateValue(providersArray, forKey: movieName)
                self.presenter?.didReceivedProvidersData(data: providersArray)
            }
        }
    }
    
    var presenter: SearchPresenterProtocol?
    
    var httpClient: HTTPClientProtocol?
    
    init(httpClient: HTTPClientProtocol) {
        self.httpClient = httpClient
    }
    
    func searchQuery(param: String, page: Int) {
        httpClient?.searchMoviesWithParams(param: param, page: page) { res, err in
            DispatchQueue.main.async {
                self.presenter?.didReceivedSearchResult(data: res)
            }
        }
    }
    
    
}
