//
//  MovieProviderClient.swift
//  eMovie
//
//  Created by Leandro Berli on 06/11/2022.
//

import Foundation

protocol MovieProviderClientProtocol {
    var core: CoreHTTPClient? { get set }
    
    func getMovieProvider(movieName: String, completion: @escaping (ItemMovieProvider?, Error?) -> Void)
}


class MovieProviderClient: MovieProviderClientProtocol {
    var core: CoreHTTPClient? = CoreHTTPClient()
    let baseURL = "https://www.buscala.tv/api/"
    
    enum APIPath: String {
        case search = "search"
    }
    
    func getMovieProvider(movieName: String, completion: @escaping (ItemMovieProvider?, Error?) -> Void) {
        let params = ["title": movieName]
        let url = baseURL + APIPath.search.rawValue
        core?.request(url: url ,params: params, responseType: SearchMovieProvidersResponse.self) { res, err in
            if let items = res?.results?.first {
                completion(items,nil)
            }
            completion(nil,nil)
        }
    }
}

struct SearchMovieProvidersResponse: Codable {
    var results: [ItemMovieProvider]?
}

struct ItemMovieProvider: Codable {
    var name: String?
    var platforms: [ProviderPlataform]?
}

struct ProviderPlataform: Codable {
    var name: String?
    var url: String?
}
