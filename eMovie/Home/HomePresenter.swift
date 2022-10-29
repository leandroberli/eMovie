//
//  HomePresenter.swift
//  eMovie
//
//  Created by Leandro Berli on 27/10/2022.
//

import Foundation
import UIKit

struct MovieWrapper: Hashable {
    var section: HomeViewController.Section
    var movie: Movie
}

protocol HomePresenterProtocol: AnyObject {
    var view: HomeViewProtocol? { get set }
    var httpClient: HTTPClientProtocol? { get set }
    var upcomingMovies: [MovieWrapper] { get set }
    var topRatedMovies: [MovieWrapper] { get set }
    var recommendedMovies: [MovieWrapper] { get set }
    
    func getUpcomingMovies()
    func getTopRatedMovies()
    func handleFilterOption(_ option: FilterButton.FilterOption)
    func navigateToMovieDetail(movieIndex: Int, fromSection: HomeViewController.Section)
}

class HomePresenter: HomePresenterProtocol {
    
    weak var view: HomeViewProtocol?
    var httpClient: HTTPClientProtocol?
    var upcomingMovies: [MovieWrapper] = []
    var topRatedMovies: [MovieWrapper] = []
    var recommendedMovies: [MovieWrapper] = []
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
            self.upcomingMovies = self.generateMoviesWarappers(movies ?? [], forSection: .upcoming)
            self.updateCollectionViewData()
        }
    }
    
    private func generateMoviesWarappers(_ movies: [Movie], forSection: HomeViewController.Section) -> [MovieWrapper] {
        var wrappers: [MovieWrapper] = []
        for m in movies {
            wrappers.append(MovieWrapper(section: forSection, movie: m))
        }
        return wrappers
    }
    
    private func updateCollectionViewData() {
        DispatchQueue.main.async {
            self.view?.updateCollectionData()
        }
    }
    
    //Tendencia
    func getTopRatedMovies() {
        httpClient?.getTopRatedMovies { movies, error in
            self.topRatedMovies = self.generateMoviesWarappers(movies ?? [], forSection: .topRated)
            self.generateReccomendedMoviesByLang()
        }
    }
    
    func generateReccomendedMoviesByLang() {
        self.filterMoviesByLang(self.selectedLang)
    }
    
    func filterMoviesByLang(_ lang: String) {
        var movieWrappers = self.topRatedMovies.map({ return MovieWrapper(section: .recommended, movie: $0.movie) })
        self.recommendedMovies = Array(movieWrappers.suffix(6))
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
        var filtredMovies = self.topRatedMovies.filter({ $0.movie.getReleaseYear() == year })
        self.recommendedMovies = filtredMovies.suffix(6).map({ MovieWrapper(section: .recommended, movie: $0.movie) })
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
            return recommendedMovies[withIndex].movie
        case .topRated:
            return topRatedMovies[withIndex].movie
        case .upcoming:
            return upcomingMovies[withIndex].movie
        }
    }
}
