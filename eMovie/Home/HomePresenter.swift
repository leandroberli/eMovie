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
    var interactor: HomeInteractorProtocol? { get set }
    
    func getUpcomingMovies()
    func getTopRatedMovies()
    func getRecommendedMovies()
    func handleFilterOption(_ option: FilterButton.FilterOption)
    func navigateToMovieDetail(movieIndex: Int, fromSection: HomeViewController.Section)
}

class HomePresenter: HomePresenterProtocol {
    
    weak var view: HomeViewProtocol?
    var httpClient: HTTPClientProtocol?
    var interactor: HomeInteractorProtocol?
    var upcomingMovies: [MovieWrapper] = []
    var topRatedMovies: [MovieWrapper] = []
    var recommendedMovies: [MovieWrapper] = []
    var movieDetails: [MovieDetail] = []
    //Set year and langague values for filter.
    //Change string labels from RecommendedHeaderView.
    var selectedDate = 2020
    var selectedLang = "ja"

    init(view: HomeViewProtocol, httpClient: HTTPClient) {
        self.view = view
        self.httpClient = httpClient
    }
    
    //Próximos estrenos
    func getUpcomingMovies() {
        interactor?.getUpcomingMovies { movies, error in
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
        interactor?.getTopRatedMovies { movies, error in
            self.topRatedMovies = movies ?? []
            self.updateCollectionViewData()
        }
    }
    
    func getRecommendedMovies() {
        interactor?.getRecommendedMovies { movies, error in
            self.recommendedMovies = movies ?? []
            self.updateCollectionViewData()
        }
    }
    
    private func generateReccomendedMoviesByLang() {
        self.filterMoviesByLang(selectedLang)
    }
    
    private func filterMoviesByLang(_ lang: String) {
        let filtredArray = self.recommendedMovies.filter({ $0.movie.original_language == lang })
        self.recommendedMovies = Array(filtredArray.suffix(6))
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
    
    private func generateRecommendedMoviesByYear() {
        self.filterMoviesByYear(self.selectedDate)
    }
    
    private func filterMoviesByYear(_ year: Int) {
        let filtredMovies = self.topRatedMovies.filter({ $0.movie.getReleaseYear() == year })
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
