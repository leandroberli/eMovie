//
//  RecentMoviesViewedHandler.swift
//  eMovie
//
//  Created by Leandro Berli on 16/11/2022.
//

import Foundation

class RecentMoviesViewedHandler {
    var movies: [Movie] = []
    
    static let shared = RecentMoviesViewedHandler()
    
    public func addViewed(movie: Movie) {
        if !movies.contains(movie) {
            movies.append(movie)
        }
    }
}
