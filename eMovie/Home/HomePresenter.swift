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
    //Dict with movie name as key. value is a platforms available array.
    var platformsTopRated: [String:Any] { get set }
    var platformsRecommended: [String: Any] { get set }
    
    func getUpcomingMovies()
    func getTopRatedMovies()
    func getRecommendedMovies()
    func startFetchMovieProviders(forMovies: [MovieWrapper])
    func handleFilterOption(_ option: FilterButton.FilterOption)
    func navigateToMovieDetail(movieIndex: Int, fromSection: HomeViewController.Section)
}

class HomePresenter: HomePresenterProtocol {
    weak var view: HomeViewProtocol?
    var interactor: HomeInteractorProtocol?
    var router: HomeRouterProtocol?
    
    var upcomingMovies: [MovieWrapper] = []
    var topRatedMovies: [MovieWrapper] = []
    
    //Filtred movies comes from all movies applying filter.
    //Collection view shows filtred movies
    var allRecommendedMovies: [MovieWrapper] = []
    var filtredRecommendedMovies: [MovieWrapper] = []
    
    //Set year and langague values for filter.
    //Change string labels from RecommendedHeaderView.
    var selectedDate = 2019
    var selectedLang = "en"
    
    //Platforms availables for top rated movies.
    //Dictionary with movie name as key and platforms array as value.
    var platformsTopRated: [String : Any] = [:]
    var platformsRecommended: [String: Any] = [:]
    var i = 0

    init(view: HomeViewProtocol, interactor: HomeInteractorProtocol, router: HomeRouterProtocol) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
    
    private func updateCollectionViewData() {
        DispatchQueue.main.async {
            self.view?.updateCollectionData()
        }
    }
    
    //MARK: Upcoming movies
    func getUpcomingMovies() {
        interactor?.getUpcomingMovies(page: Int.random(in: 1..<10)) { res, error in
            let movies = res?.results ?? []
            self.upcomingMovies = (self.interactor?.generateMoviesWarappers(movies, forSection: .upcoming)) ?? []
            self.updateCollectionViewData()
        }
    }
    
    //MARK: Top rated
    func getTopRatedMovies() {
        interactor?.getTopRatedMovies(page: Int.random(in: 1..<10)) { res, error in
            //self.topRatedMovies = movies ?? []
            let movies = res?.results ?? []
            let wrappers = self.interactor?.generateMoviesWarappers(movies, forSection: .topRated) ?? []
            self.topRatedMovies = wrappers
            self.updateCollectionViewData()
            self.startFetchMovieProviders(forMovies: self.topRatedMovies)
            //self.startFetchTopRatedMovieProviders()
        }
    }
    
    func startFetchMovieProviders(forMovies: [MovieWrapper]) {
        forMovies.forEach({
            getProvidedPlatforms(movie: $0)
        })
    }
    
    private func getProvidedPlatforms(movie: MovieWrapper) {
        interactor?.getMovieProviders(for: movie.movie.original_title ?? "") { platforms, error in
            guard let platforms = platforms else {
                return
            }
            if movie.section == .recommended {
                self.platformsRecommended.updateValue(platforms, forKey: movie.movie.original_title ?? "")
            } else {
                self.platformsTopRated.updateValue(platforms, forKey: movie.movie.original_title ?? "")
            }
            
            //Realod first 3 items.
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                if self.i < 4 {
                    self.view?.updateTopRatedVisibleCells(index: IndexPath(item: self.i, section: 1))
                }
                self.i += 1
            }
        }
    }
    
    //MARK: Recommended movies
    func getRecommendedMovies() {
        interactor?.getRecommendedMovies(page: Int.random(in: 1..<10)) { res, error in
            let movies = res?.results ?? []
            let wraperrs = self.interactor?.generateMoviesWarappers(movies, forSection: .recommended) ?? []
            self.allRecommendedMovies = wraperrs
            self.filtredRecommendedMovies = wraperrs
            //self.filtredRecommendedMovies = self.filterMoviesBy(lang: self.selectedLang, movies: self.allRecommendedMovies)
            self.startFetchMovieProviders(forMovies: self.filtredRecommendedMovies)
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
        return Array(filtredArray)
    }
    
    private func filterMoviesBy(year: Int, movies: [MovieWrapper]) -> [MovieWrapper] {
        let filtredMovies = movies.filter({ $0.movie.getReleaseYear() == year })
        return Array(filtredMovies)
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
