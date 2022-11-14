//
//  HomeViewControllerTests.swift
//  eMovieTests
//
//  Created by Leandro Berli on 12/11/2022.
//

import XCTest
@testable import eMovie

final class HomeViewControllerTests: XCTestCase {
    
    var router: HomeRouterProtocol!
    var sut: HomeViewController!
    var presenter: HomePresenterProtocol!
    var interactor: HomeInteractorProtocol!
    

    override func setUpWithError() throws {
        sut = HomeViewController()
        interactor = MockHomeInteractor()
        presenter = HomePresenter(view: sut, interactor: interactor, router: HomeRouter())
    }

    override func tearDownWithError() throws {
        sut = nil
        presenter = nil
        interactor = nil
        router = nil
    }

    func testExample() throws {
        /*sut.viewDidLoad()
        sut.snapshotForCurrentState()
        sut.updateCollectionData()
        sut.updateVisibleCells()*/
    }
}
