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
    func updateVisibleCells() {
        updateCollectionVisibleCellsCalled = true
        visibleCellsExp?.fulfill()
        return
    }
    
    var presenter: eMovie.HomePresenterProtocol?
    var visibleCellsExp: XCTestExpectation?
    var expectation: XCTestExpectation?
    var updateCollectionDataCalled = false
    var updateCollectionVisibleCellsCalled = false
    
    func updateCollectionData() {
        updateCollectionDataCalled = true
        expectation?.fulfill()
    }
}
