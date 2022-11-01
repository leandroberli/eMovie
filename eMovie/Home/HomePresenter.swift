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
    var interactor: HomeInteractorProtocol? { get set }
    var router: HomeRouterProtocol? { get set }
    
    var upcomingMovies: [MovieWrapper] { get set }
    var topRatedMovies: [MovieWrapper] { get set }
    var allRecommendedMovies: [MovieWrapper] { get set }
    var filtredRecommendedMovies: [MovieWrapper] { get set }
    
    func getUpcomingMovies()
    func getTopRatedMovies()
    func getRecommendedMovies()
    func handleFilterOption(_ option: FilterButton.FilterOption)
    func navigateToMovieDetail(movieIndex: Int, fromSection: HomeViewController.Section)
}

class HomePresenter: HomePresenterProtocol {
    
    weak var view: HomeViewProtocol?
    var interactor: HomeInteractorProtocol?
    var router: HomeRouterProtocol?
    
    var upcomingMovies: [MovieWrapper] = []
    var topRatedMovies: [MovieWrapper] = []
    var allRecommendedMovies: [MovieWrapper] = []
    var filtredRecommendedMovies: [MovieWrapper] = []
    //Set year and langague values for filter.
    //Change string labels from RecommendedHeaderView.
    var selectedDate = 2020
    var selectedLang = "ja"

    init(view: HomeViewProtocol, interactor: HomeInteractorProtocol, router: HomeRouterProtocol) {
        self.view = view
        self.interactor = interactor
        self.router = router
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
    
    //Recomendados
    func getRecommendedMovies() {
        interactor?.getRecommendedMovies { movies, error in
            self.allRecommendedMovies = movies ?? []
            self.filtredRecommendedMovies = self.filterMoviesBy(lang: self.selectedLang, movies: self.allRecommendedMovies)
            self.updateCollectionViewData()
        }
    }
    
    func handleFilterOption(_ option: FilterButton.FilterOption) {
        switch option {
        case .date:
            self.filtredRecommendedMovies = self.filterMoviesBy(year: selectedDate, movies: allRecommendedMovies)
        case .lang:
            self.filtredRecommendedMovies = self.filterMoviesBy(lang: selectedLang, movies: allRecommendedMovies)
        }
        updateCollectionViewData()
    }
    
    private func filterMoviesBy(lang: String, movies: [MovieWrapper]) -> [MovieWrapper] {
        let filtredArray = movies.filter({ $0.movie.original_language == lang })
        return Array(filtredArray.suffix(6))
    }
    
    private func filterMoviesBy(year: Int, movies: [MovieWrapper]) -> [MovieWrapper] {
        let filtredMovies = movies.filter({ $0.movie.getReleaseYear() == year })
        return Array(filtredMovies.suffix(6))
    }
    
    func navigateToMovieDetail(movieIndex: Int, fromSection: HomeViewController.Section) {
        guard let viewController = self.view as? UIViewController else {
            return
        }
        let movie = getMovie(withIndex: movieIndex, andSection: fromSection)
        router?.navigateMovieDetailScreen(from: viewController, andMovie: movie)
    }
    
    private func getMovie(withIndex: Int, andSection: HomeViewController.Section) -> Movie {
        switch andSection {
        case .recommended:
            return filtredRecommendedMovies[withIndex].movie
        case .topRated:
            return topRatedMovies[withIndex].movie
        case .upcoming:
            return upcomingMovies[withIndex].movie
        }
    }
}
