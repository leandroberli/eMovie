//
//  MockHomeRouter.swift
//  eMovieTests
//
//  Created by Leandro Berli on 01/11/2022.
//

import Foundation
import XCTest
@testable import eMovie

class MockHomeRouter: HomeRouterProtocol {
    var navigateMovieDetailCalled = false
    var selectedMovie: Movie?
    var expectation: XCTestExpectation?
    
    static func createHomeModule() -> UIViewController {
        return UIViewController()
    }
    
    func navigateMovieDetailScreen(from view: UIViewController, andMovie: eMovie.Movie) {
        selectedMovie = andMovie
        navigateMovieDetailCalled = true
        expectation?.fulfill()
    }
}
