//
//  HomePresenter.swift
//  eMovie
//
//  Created by Leandro Berli on 27/10/2022.
//

import Foundation
import UIKit

protocol HomePresenterProtocol: AnyObject {
    var view: HomeViewProtocol? { get set }
    var httpClient: HTTPClientProtocol? { get set }
    var upcomingMovies: [Movie] { get set }
    var topRatedMovies: [Movie] { get set }
    var recommendedMovies: [Movie] { get set }
    
    func getUpcomingMovies()
    func getTopRatedMovies()
    func handleFilterOption(_ option: FilterButton.FilterOption)
    func navigateToMovieDetail(movieIndex: Int, fromSection: HomeViewController.Section)
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
    
    //Próximos estrenos
    func getUpcomingMovies() {
        httpClient?.getUpcomingMovies { movies, error in
            self.upcomingMovies = movies ?? []
            self.updateCollectionViewData()
        }
    }
    
    private func updateCollectionViewData() {
        DispatchQueue.main.async {
            self.view?.updateCollectionData()
        }
    }
    
    //Tendencia
    func getTopRatedMovies() {
        httpClient?.getTopRatedMovies { movies, error in
            self.topRatedMovies = movies ?? []
            self.generateReccomendedMoviesByLang()
        }
    }
    
    func generateReccomendedMoviesByLang() {
        self.filterMoviesByLang(self.selectedLang)
    }
    
    func filterMoviesByLang(_ lang: String) {
        self.recommendedMovies = self.topRatedMovies.filter({ $0.original_language == lang })
        self.recommendedMovies = Array(self.recommendedMovies.suffix(6))
        self.updateCollectionViewData()
    }
    
    func handleFilterOption(_ option: FilterButton.FilterOption) {
        switch option {
        case .date:
            self.generateRecommendedMoviesByYear()
        case .lang:
            self.generateReccomendedMoviesByLang()
        }
    }
    
    func generateRecommendedMoviesByYear() {
        self.filterMoviesByYear(self.selectedDate)
    }
    
    func filterMoviesByYear(_ year: Int) {
        self.recommendedMovies = self.topRatedMovies.filter({ $0.getReleaseYear() == year })
        self.recommendedMovies = Array(self.recommendedMovies.suffix(6))
        self.updateCollectionViewData()
    }
    
    func navigateToMovieDetail(movieIndex: Int, fromSection: HomeViewController.Section) {
        guard let homeController = self.view as? UIViewController else {
            return
        }
        let movie = getMovie(withIndex: movieIndex, andSection: fromSection)
        let detail = MovieDetailViewController()
        let presenter = MovieDetailPresenter(movie: movie, view: detail, httpClient: HTTPClient())
        detail.presenter = presenter
        homeController.navigationController?.pushViewController(detail, animated: true)
    }
    
    private func getMovie(withIndex: Int, andSection: HomeViewController.Section) -> Movie {
        switch andSection {
        case .recommended:
            return recommendedMovies[withIndex]
        case .topRated:
            return topRatedMovies[withIndex]
        case .upcoming:
            return upcomingMovies[withIndex]
        }
    }
}
