//
//  MovieDetailPresenterTests.swift
//  eMovieTests
//
//  Created by Leandro Berli on 13/11/2022.
//

import XCTest
@testable import eMovie

final class MovieDetailPresenterTests: XCTestCase {
    var sut: MovieDetailPresenter!
    var mockView: MockMovieDetailView!
    var interactor: MovieDetailInteractorProtocol!
    var router: MovieDetailRouterProtocol!

    override func setUpWithError() throws {
        let movies = loadJson(filename: "movies")!
        let movie = movies.first
        mockView = MockMovieDetailView()
        interactor = MockDetailInteractor()
        router = MovieDetailRouter()
        sut = MovieDetailPresenter(movie: movie!, view: mockView, interactor: interactor, router: router)
        mockView.presenter = sut
    }

    override func tearDownWithError() throws {
        mockView = nil
        interactor = nil
        router = nil
        sut = nil
    }

    func testGetAvailablesPlatforms_shouldUpdateView() throws {
        let exp = self.expectation(description: "Should update providers view")
        mockView.expectation = exp
        sut.getAvailablePlatfroms()
        self.wait(for: [exp], timeout: 5)
        XCTAssertTrue(mockView.updateProvidersCalled)
    }
    
    func testGetMovieDetail_ShouldUpdateView() throws {
        let exp = self.expectation(description: "Should update detail view")
        mockView.expectation = exp
        interactor.httpClient = HTTPClient()
        sut.getMovieDetail()
        self.wait(for: [exp], timeout: 5)
        XCTAssertTrue(mockView.updateViewWithMovieDataCalled)
    }
    
    func testGetMovieTrailer_ShouldUpdateWebview() throws {
        let exp = self.expectation(description: "Should update webview")
        mockView.expectation = exp
        interactor.httpClient = HTTPClient()
        sut.getMovieVideoTrailer()
        self.wait(for: [exp], timeout: 5)
        XCTAssertTrue(mockView.updateTrailerWebviewCalled)
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
