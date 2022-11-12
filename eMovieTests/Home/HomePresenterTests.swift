//
//  HomePresenterTests.swift
//  eMovieTests
//
//  Created by Leandro Berli on 29/10/2022.
//

import XCTest
@testable import eMovie

final class HomePresenterTests: XCTestCase {
    
    var sut: HomePresenter!
    var mockView: MockHomeView!
    var mockInteractor: MockHomeInteractor!
    var router: MockHomeRouter!

    override func setUpWithError() throws {
        mockView = MockHomeView()
        mockInteractor = MockHomeInteractor()
        router = MockHomeRouter()
        sut = HomePresenter(view: mockView, interactor: mockInteractor, router: router)
    }

    override func tearDownWithError() throws {
        sut = nil
        mockView = nil
        mockInteractor = nil
        router = nil
    }
    
    func testFilterByYearFunct_ShouldReturnFiltredArray() throws {
        sut.getRecommendedMovies()
        
        sut.handleFilterOption(.date)
        
        sut.filtredRecommendedMovies.forEach({
            XCTAssertTrue($0.movie.getReleaseYear() == sut.selectedDate)
        })
    }
    
    func testFilterByLangFunct_ShouldReturnFiltredArrayWithLangConfig() throws {
        sut.getRecommendedMovies()
        
        sut.handleFilterOption(.lang)
        
        sut.filtredRecommendedMovies.forEach({
            XCTAssertTrue($0.movie.original_language == sut.selectedLang)
        })
    }
    
    func testDidSelectUpcomingMovie_shouldNavigateToMovieDetail() throws {
        let exp = self.expectation(description: "Expect navigate to upcoming movie detail.")
        let index = 4
        router.expectation = exp
        
        sut.getUpcomingMovies()
        sut.navigateToMovieDetail(movieIndex: index, fromSection: .upcoming)
        
        self.wait(for: [exp], timeout: 5)
        
        XCTAssertTrue(router.selectedMovie?.id == sut.upcomingMovies[index].movie.id)
        XCTAssertTrue(router.navigateMovieDetailCalled)
    }
    
    func testTopRatedLoadData_shouldLoadMoviesAndProviders() throws {
        let exp = self.expectation(description: "Expected load movies and platforms for top rated movies")
        mockInteractor.expectation = exp
        
        sut.getTopRatedMovies()
    
        self.wait(for: [exp], timeout: 10)
        
        sut.topRatedMovies.forEach({
            XCTAssertNotNil(sut.platformsTopRated[$0.movie.original_title!])
        })
    }
}
