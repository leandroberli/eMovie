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
        mockView.presenter = sut
        mockInteractor.presenter = sut
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
    
    func testTopRatedDataDownloaded_ShouldUpdateCollection() throws {
        let exp = self.expectation(description: "Top movies data has received, then update collection view")
        mockView.expectation = exp
        
        sut.getTopRatedMovies()
        
        self.wait(for: [exp], timeout: 5)
        
        XCTAssertTrue(mockView.updateCollectionDataCalled)
    }
    
    func testTopRateMoviesDataDownloaded_ShouldGetProvidersAndUpdateCells() throws {
        let exp = self.expectation(description: "Top movies data received, then get each providers and update cell for show logos.")
        mockView.visibleCellsExp = exp
        
        sut.getTopRatedMovies()
        
        self.wait(for: [exp], timeout: 5)
        
        XCTAssertTrue(mockInteractor.getProvidersCalled)
        XCTAssertTrue(mockView.updateCollectionVisibleCellsCalled)
    }
    
}
