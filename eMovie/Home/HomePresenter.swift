//
//  HomePresenter.swift
//  eMovie
//
//  Created by Leandro Berli on 27/10/2022.
//

import Foundation
import UIKit

struct MovieWrapper: Hashable {
    var section: Section
    var movie: Movie
}

protocol HomePresenterProtocol: AnyObject {
    var view: HomeView? { get set }
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
    func didReceivedUpcomingMovies(data: Result<[MovieWrapper],Error>)
    func getTopRatedMovies()
    func didReceivedTopRatedMovies(data: Result<[MovieWrapper], Error>)
    func getRecommendedMovies()
    func didReceivedRecommendedMovies(data: Result<[MovieWrapper], Error>)
    func executeGetProvidersRequests(forMovies: [MovieWrapper])
    func didReceivedProvidersData(data: Result<[String: [ProviderPlataform]], Error>, fromSection: Section)
    
    func handleFilterOption(_ option: FilterButton.FilterOption)
    func navigateToMovieDetail(movieIndex: Int, fromSection: Section)
}

class HomePresenter: HomePresenterProtocol {
    weak var view: HomeView?
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

    init(view: HomeView, interactor: HomeInteractorProtocol, router: HomeRouterProtocol) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }

    //MARK: Upcoming movies
    func getUpcomingMovies() {
        interactor?.getUpcomingMovies(page: Int.random(in: 1..<10))
    }
    
    func didReceivedUpcomingMovies(data: Result<[MovieWrapper], Error>) {
        switch data {
        case .success(let data):
            self.upcomingMovies = data
            DispatchQueue.main.async {
                self.view?.updateCollectionData()
            }
        case .failure:
            return
        }
    }
    
    //MARK: Top rated
    func getTopRatedMovies() {
        interactor?.getTopRatedMovies(page: Int.random(in: 1..<10))
    }
    
    func didReceivedTopRatedMovies(data: Result<[MovieWrapper], Error>) {
        switch data {
        case .success(let data):
            self.topRatedMovies = data
            self.executeGetProvidersRequests(forMovies: data)
            DispatchQueue.main.async {
                self.view?.updateCollectionData()
            }
        case .failure:
            return
        }
    }

    func executeGetProvidersRequests(forMovies: [MovieWrapper]) {
        interactor?.getProviders(forMovies: forMovies)
    }
    
    func didReceivedProvidersData(data: Result<[String: [ProviderPlataform]], Error>, fromSection: Section) {
        switch data {
        case .success(let data):
            if fromSection == .topRated {
                self.platformsTopRated = data
            } else {
                self.platformsRecommended = data
            }
            self.view?.updateVisibleCells()
        case .failure:
            return
        }
    }
    
    //MARK: Recommended movies
    func getRecommendedMovies() {
        interactor?.getRecommendedMovies(page: Int.random(in: 1..<10))
    }
    
    func didReceivedRecommendedMovies(data: Result<[MovieWrapper], Error>) {
        switch data {
        case .success(let data):
            self.allRecommendedMovies = data
            self.filtredRecommendedMovies = data
            self.executeGetProvidersRequests(forMovies: data)
            DispatchQueue.main.async {
                self.view?.updateCollectionData()
            }
        case .failure:
            return
        }
    }
    
    func handleFilterOption(_ option: FilterButton.FilterOption) {
        switch option {
        case .date:
            self.filtredRecommendedMovies = self.filterMoviesBy(year: selectedDate, movies: allRecommendedMovies)
        case .lang:
            self.filtredRecommendedMovies = self.filterMoviesBy(lang: selectedLang, movies: allRecommendedMovies)
        }
        self.view?.updateCollectionData()
    }
    
    private func filterMoviesBy(lang: String, movies: [MovieWrapper]) -> [MovieWrapper] {
        let filtredArray = movies.filter({ $0.movie.original_language == lang })
        return Array(filtredArray)
    }
    
    private func filterMoviesBy(year: Int, movies: [MovieWrapper]) -> [MovieWrapper] {
        let filtredMovies = movies.filter({ $0.movie.getReleaseYear() == year })
        return Array(filtredMovies)
    }
    
    func navigateToMovieDetail(movieIndex: Int, fromSection: Section) {
        guard let viewController = self.view else {
            return
        }
        let movie = getMovie(withIndex: movieIndex, andSection: fromSection)
        router?.navigateMovieDetailScreen(from: viewController, andMovie: movie)
    }
    
    private func getMovie(withIndex: Int, andSection: Section) -> Movie {
        switch andSection {
        case .recommended:
            return filtredRecommendedMovies[withIndex].movie
        case .topRated:
            return topRatedMovies[withIndex].movie
        case .upcoming:
            return upcomingMovies[withIndex].movie
        default:
            return filtredRecommendedMovies[withIndex].movie
        }
    }
}
