//
//  MockDetailView.swift
//  eMovieTests
//
//  Created by Leandro Berli on 14/11/2022.
//

import Foundation
import XCTest
@testable import eMovie

class MockMovieDetailView: MovieDetailView {
    var presenter: eMovie.MovieDetailPresenterProtocol?
    var updateViewWithMovieDataCalled = false
    var updateTrailerWebviewCalled = false
    var updateProvidersCalled = false
    var expectation: XCTestExpectation?
    
    func updateViewWithMovie(data: eMovie.MovieDetail?) {
        updateViewWithMovieDataCalled = true
        expectation?.fulfill()
    }
    
    func updateTrailerWebview(withURLRequest: URLRequest) {
        updateTrailerWebviewCalled = true
        expectation?.fulfill()
    }
    
    func updateMovieProviders(data: eMovie.ItemMovieProvider?) {
        updateProvidersCalled = true
        expectation?.fulfill()
    }
}
