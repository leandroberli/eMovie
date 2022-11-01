//
//  MovieDetailInteractor.swift
//  eMovie
//
//  Created by Leandro Berli on 01/11/2022.
//

import Foundation

protocol MovieDetailInteractorProtocol {
    var httpClient: HTTPClientProtocol? { get set }
    
    func getMovieDetail(withId: Int, completion: @escaping (MovieDetail?, Error?) -> Void)
    func getMovieVideoTrailer(withId: Int, completion: @escaping (Video?,Error?) -> Void)
}

class MovieDetailInteractor: MovieDetailInteractorProtocol {
    var httpClient: HTTPClientProtocol?
    
    init(httpClient: HTTPClientProtocol) {
        self.httpClient = httpClient
    }
    
    func getMovieDetail(withId: Int, completion: @escaping (MovieDetail?, Error?) -> Void) {
        httpClient?.getDetailMovie(withId: withId) { detail, error in
            DispatchQueue.main.async {
                completion(detail, error)
            }
        }
    }
    
    func getMovieVideoTrailer(withId: Int, completion: @escaping (Video?,Error?) -> Void) {
        httpClient?.getMovieVideo(withId: withId) { videos, error in
            guard let trailer = videos?.first(where: { $0.type == "Trailer" }) else {
                completion(nil, nil)
                return
            }
            completion(trailer,nil)
        }
    }
}
