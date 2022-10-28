//
//  HomePresenter.swift
//  eMovie
//
//  Created by Leandro Berli on 27/10/2022.
//

import Foundation

protocol HomePresenterProtocol: AnyObject {
    var view: HomeViewProtocol? { get set }
    var httpClient: HTTPClientProtocol? { get set }
    var upcomingMovies: [Movie] { get set }
    var topRatedMovies: [Movie] { get set }
    var recommendedMovies: [Movie] { get set }
    
    func getUpcomingMovies()
    func getTopRatedMovies()
    func handleFilterOption(_ option: FilterButton.FilterOption)
}

class HomePresenter: HomePresenterProtocol {
    
    weak var view: HomeViewProtocol?
    var httpClient: HTTPClientProtocol?
    var upcomingMovies: [Movie] = []
    var topRatedMovies: [Movie] = []
    var recommendedMovies: [Movie] = []
    var movieDetails: [MovieDetail] = []
    var selectedDate = 2003
    var selectedLang = "en"

    init(view: HomeViewProtocol, httpClient: HTTPClient) {
        self.view = view
        self.httpClient = httpClient
    }
    
    func getUpcomingMovies() {
        httpClient?.getUpcomingMovies { movies, error in
            self.upcomingMovies = movies ?? []
            DispatchQueue.main.async {
                self.view?.updateCollectionData()
            }
        }
    }
    
    func getTopRatedMovies() {
        httpClient?.getTopRatedMovies { movies, error in
            self.topRatedMovies = movies ?? []
            self.generateReccomendedMoviesByLang()
        }
    }
    
    func handleFilterOption(_ option: FilterButton.FilterOption) {
        switch option {
        case .date:
            self.generateRecommendedMoviewByYear()
        case .lang:
            self.selectedLang = "en"
            generateReccomendedMoviesByLang()
        }
    }
    
    func generateReccomendedMoviesByLang() {
        self.filterMoviesByLang(self.selectedLang)
    }
    
    func generateRecommendedMoviewByYear() {
        self.filterMoviesByYear(self.selectedDate)
    }
    
    func filterMoviesByYear(_ year: Int) {
        self.recommendedMovies = self.topRatedMovies.filter({ $0.getReleaseYear() == year })
        self.recommendedMovies = Array(self.recommendedMovies.suffix(6))
        DispatchQueue.main.async {
            self.view?.updateCollectionData()
        }
    }
    
    func filterMoviesByLang(_ lang: String) {
        self.recommendedMovies = self.topRatedMovies.filter({ $0.original_language == lang })
        self.recommendedMovies = Array(self.recommendedMovies.suffix(6))
        DispatchQueue.main.async {
            self.view?.updateCollectionData()
        }
    }
}
