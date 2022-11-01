//
//  MockHomeView.swift
//  eMovieTests
//
//  Created by Leandro Berli on 01/11/2022.
//

import Foundation
@testable import eMovie

class MockHomeView: HomeViewProtocol {
    var presenter: eMovie.HomePresenterProtocol?
    
    func updateCollectionData() {
        
    }
}
