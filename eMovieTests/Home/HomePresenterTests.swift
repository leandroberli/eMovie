//
//  HomePresenterTests.swift
//  eMovieTests
//
//  Created by Leandro Berli on 29/10/2022.
//

import XCTest
@testable import eMovie

class MockHomeView: HomeViewProtocol {
    var presenter: eMovie.HomePresenterProtocol?
    
    func updateCollectionData() {
        
    }
}

final class HomePresenterTests: XCTestCase {
    
    var sut: HomePresenter!
    var mockView: HomeViewProtocol!
    var httpClient: HTTPClient!

    override func setUpWithError() throws {
        mockView = MockHomeView()
        httpClient = HTTPClient()
        sut = HomePresenter(view: mockView, httpClient: httpClient)
    }

    override func tearDownWithError() throws {
        sut = nil
        mockView = nil
        httpClient = nil
    }
    
    func testFilterByYearFunct_ShouldReturnFiltredArray() throws {
        let movies = loadJson(filename: "movies")
        let wrappers = sut.generateMoviesWarappers(movies!, forSection: .recommended)
        //Recommended movies are top rated data.
        sut.topRatedMovies = wrappers
        
        sut.handleFilterOption(.date)
        
        sut.recommendedMovies.forEach({
            XCTAssertTrue($0.movie.getReleaseYear() == sut.selectedDate)
        })
    }
    
    func testFilterByLangFunct_ShouldReturnFiltredArrayWithLangConfig() throws {
        let movies = loadJson(filename: "movies")
        let wrappers = sut.generateMoviesWarappers(movies!, forSection: .recommended)
        //Recommended movies are top rated data.
        sut.topRatedMovies = wrappers
        
        sut.handleFilterOption(.lang)
        
        sut.recommendedMovies.forEach({
            XCTAssertTrue($0.movie.original_language == sut.selectedLang)
        })
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
