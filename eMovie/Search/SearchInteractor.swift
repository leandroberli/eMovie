//
//  SearchInteractor.swift
//  eMovie
//
//  Created by Leandro Berli on 05/11/2022.
//

import Foundation

protocol SearchInteractorProtocol: GetProvidersProcessDelegate {
    var presenter: SearchPresenterProtocol? { get set }
    var httpClient: HTTPClientProtocol? { get set }
    var providersProcess: GetProvidersProcessProtocol? { get set }
    
    func searchQuery(param: String, page: Int)
    func getMovieProviders(forMovies: [MovieWrapper])
}

class SearchInteractor: SearchInteractorProtocol {
    
    var providersProcess: GetProvidersProcessProtocol?
    var presenter: SearchPresenterProtocol?
    var httpClient: HTTPClientProtocol?
    
    func getMovieProviders(forMovies: [MovieWrapper]) {
        providersProcess?.startProcess(forMovies: forMovies)
    }
    
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

extension SearchInteractor: GetProvidersProcessDelegate {
    func providersDataReceived(_ data: [String : [ProviderPlataform]], forSection: Section) {
        self.presenter?.movieProvidersDataReceived(data)
    }
}
