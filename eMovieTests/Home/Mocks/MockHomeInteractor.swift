//
//  MockHomeInteractor.swift
//  eMovieTests
//
//  Created by Leandro Berli on 01/11/2022.
//

import Foundation
import XCTest
@testable import eMovie

class MockHomeInteractor: HomeInteractorProtocol {
    var httpClient: eMovie.HTTPClient?
    var expectation: XCTestExpectation?
    var simulateError = false
    
    func getTopRatedMovies(completion: @escaping ([eMovie.MovieWrapper]?, Error?) -> Void) {
        if !simulateError {
            let movies = loadJson(filename: "movies")
            let wrappers = movies?.map({ return MovieWrapper(section: .topRated, movie: $0)})
            completion(wrappers, nil)
        }
    }
    
    func getUpcomingMovies(completion: @escaping ([eMovie.MovieWrapper]?, Error?) -> Void) {
        if !simulateError {
            let movies = loadJson(filename: "movies")
            let wrappers = movies?.map({ return MovieWrapper(section: .upcoming, movie: $0)})
            completion(wrappers, nil)
        }
    }
    
    func getRecommendedMovies(completion: @escaping ([eMovie.MovieWrapper]?, Error?) -> Void) {
        if !simulateError {
            let movies = loadJson(filename: "movies")
            let wrappers = movies?.map({ return MovieWrapper(section: .recommended, movie: $0)})
            completion(wrappers, nil)
        }
    }
    
    func loadJson(filename fileName: String) -> [Movie]? {
        guard let pathString = Bundle(for: type(of: self)).path(forResource: "movies", ofType: "json") else {
            fatalError("movies.json not found")
        }
        guard let jsonString = try? String(contentsOfFile: pathString, encoding: .utf8) else {
            fatalError("Unable to convert UnitTestData.json to String")
        }
        guard let jsonData = jsonString.data(using: .utf8) else {
            fatalError("Unable to convert UnitTestData.json to Data")
        }
        
        do {
            let decoder = JSONDecoder()
            let jsonData = try decoder.decode(ResultReponse<Movie>.self, from: jsonData)
            return jsonData.results
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    
}
