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
    func providersDataReceived(_ data: [String : [eMovie.ProviderPlataform]], forSection: eMovie.Section) {
        
    }
    
    var providersProcess: eMovie.GetProvidersProcessProtocol?
    
    func generateMoviesWarappers(_ movies: [eMovie.Movie], forSection: eMovie.Section) -> [eMovie.MovieWrapper] {
        return []
    }
    
    var providerClient: eMovie.MovieProviderClient?
    var presenter: eMovie.HomePresenterProtocol?
    
    func getTopRatedMovies(page: Int) {
        guard let movies = loadJson(filename: "movies") else { return }
        let wrapers = movies.map({ return MovieWrapper(section: .topRated, movie: $0)})
        presenter?.didReceivedTopRatedMovies(data: .success(wrapers))
    }
    
    func getUpcomingMovies(page: Int) {
        guard let movies = loadJson(filename: "movies") else { return }
        let wrapers = movies.map({ return MovieWrapper(section: .upcoming, movie: $0)})
        presenter?.didReceivedUpcomingMovies(data: .success(wrapers))
    }
    
    func getRecommendedMovies(page: Int) {
        guard let movies = loadJson(filename: "movies") else { return }
        let wrapers = movies.map({ return MovieWrapper(section: .recommended, movie: $0)})
        presenter?.didReceivedRecommendedMovies(data: .success(wrapers))
    }
    
    var getProvidersCalled = false
    
    func getProviders(forMovies: [eMovie.MovieWrapper]) {
        let result: Result<[String: [ProviderPlataform]],Error> = .success([:])
        getProvidersCalled = true
        presenter?.didReceivedProvidersData(data: result, fromSection: forMovies.first?.section ?? .upcoming)
       //expectation?.fulfill()
    }
    
    var httpClient: eMovie.HTTPClient?
    var expectation: XCTestExpectation?
    var simulateError = false
    
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
