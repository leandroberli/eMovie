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
    
    func getMovieProviders(for movieName: String, callback: @escaping ([eMovie.ProviderPlataform]?, Error?) -> Void) {
        
    }
    
    func generateMoviesWarappers(_ movies: [eMovie.Movie], forSection: eMovie.HomeViewController.Section) -> [eMovie.MovieWrapper] {
        let wrappers = movies.map({ return MovieWrapper(section: forSection, movie: $0)})
        return wrappers
    }
    
    var httpClient: eMovie.HTTPClient?
    var expectation: XCTestExpectation?
    var simulateError = false
    
    func getTopRatedMovies(page: Int, completion: @escaping (eMovie.ResultReponse<eMovie.Movie>?, Error?) -> Void) {
        if !simulateError {
            let movies = loadJson(filename: "movies")
            let response = ResultReponse<Movie>(page: 1, results: movies ?? [], total_pages: 10, total_results: 100)
            
            completion(response, nil)
        }
    }
    
    func getUpcomingMovies(page: Int, completion: @escaping (eMovie.ResultReponse<eMovie.Movie>?, Error?) -> Void) {
        if !simulateError {
            let movies = loadJson(filename: "movies")
            //let wrappers = movies?.map({ return MovieWrapper(section: .upcoming, movie: $0)})
            let response = ResultReponse<Movie>(page: 1, results: movies ?? [], total_pages: 10, total_results: 100)
            
            completion(response, nil)
        }
    }
    
    func getRecommendedMovies(page: Int, completion: @escaping (eMovie.ResultReponse<eMovie.Movie>?, Error?) -> Void) {
        if !simulateError {
            let movies = loadJson(filename: "movies")
            let response = ResultReponse<Movie>(page: 1, results: movies ?? [], total_pages: 10, total_results: 100)
            
            completion(response, nil)
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
