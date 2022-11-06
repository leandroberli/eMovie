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
    
    func searchQuery(param: String)
}

class SearchInteractor: SearchInteractorProtocol {
    var presenter: SearchPresenterProtocol?
    
    var httpClient: HTTPClientProtocol?
    
    init(httpClient: HTTPClientProtocol) {
        self.httpClient = httpClient
    }
    
    func searchQuery(param: String) {
        httpClient?.searchMoviesWithParams(param: param) { res, err in
            DispatchQueue.main.async {
                self.presenter?.didReceivedSearchResults(data: res ?? [])
            }
        }
    }
    
    
}
