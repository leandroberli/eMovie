//
//  MockDetailInteractor.swift
//  eMovieTests
//
//  Created by Leandro Berli on 14/11/2022.
//

import Foundation
@testable import eMovie

class MockDetailInteractor: MovieDetailInteractorProtocol {
    var httpClient: eMovie.HTTPClientProtocol?
    
    var getMovieDetailCalled = false
    func getMovieDetail(withId: Int, completion: @escaping (eMovie.MovieDetail?, Error?) -> Void) {
        httpClient?.getDetailMovie(withId: withId) { res, err in
            self.getMovieDetailCalled = true
            completion(res,err)
        }
    }
    
    var getMovieVideoTrailerCalled = false
    
    func getMovieVideoTrailer(withId: Int, completion: @escaping (eMovie.Video?, Error?) -> Void) {
        httpClient?.getMovieVideo(withId: withId) { res, err in
            self.getMovieVideoTrailerCalled = true
            completion(res?.first,nil)
        }
    }
    
    func markAsFavorite(favorite: Bool, movieId: Int) {
        
    }
    
    var getPlatformsCalled = false
    
    func getAvailablePlataforms(movieName: String, completion: @escaping (eMovie.ItemMovieProvider?, Error?) -> Void) {
        getPlatformsCalled = true
        var data = ItemMovieProvider()
        data.name = "Netflix"
        data.platforms = []
        completion(data,nil)
    }
}
