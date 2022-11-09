//
//  MockHomeView.swift
//  eMovieTests
//
//  Created by Leandro Berli on 01/11/2022.
//

import Foundation
import XCTest
@testable import eMovie

class MockHomeView: UIViewController, HomeViewProtocol {
    func updateTopRatedVisibleCells(index: IndexPath) {
        return
    }
    
    var presenter: eMovie.HomePresenterProtocol?
    var expectation: XCTestExpectation?
    var updateCollectionDataCalled = false
    
    func updateCollectionData() {
        updateCollectionDataCalled = true
        expectation?.fulfill()
    }
}
