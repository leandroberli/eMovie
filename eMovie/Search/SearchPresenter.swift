//
//  SearchPresenter.swift
//  eMovie
//
//  Created by Leandro Berli on 06/11/2022.
//

import Foundation

protocol SearchPresenterProtocol {
    var view: SearchView? { get set }
    var interactor: SearchInteractorProtocol? { get set }
    var router: SearchRouterProtocol? { get set }
    var searchData: ResultReponse<Movie>? { get set }
    var platforms: [String : Any] { get set }
    var recentsMoviesViewed: [Movie] { get set }
    
    func searchParam(_ string: String)
    func getProvidersMovies(forMovies: [MovieWrapper])
    func movieProvidersDataReceived(_ data:  [String : [ProviderPlataform]])
    func didReceivedSearchResult(data: ResultReponse<Movie>?)
    func didTapMovie(index: Int)
    func getRecentsMoviesViewed()
}

class SearchPresenter: SearchPresenterProtocol {
    
    func getRecentsMoviesViewed() {
        recentsMoviesViewed = RecentMoviesViewedHandler.shared.movies.reversed()
        self.view?.updateRecentMoviesView()
    }
    
    var platforms: [String : Any] = [:]
    var view: SearchView?
    var interactor: SearchInteractorProtocol?
    var router: SearchRouterProtocol?
    var searchData: ResultReponse<Movie>?
    var currentEntry = ""
    var isFetching = false
    var recentsMoviesViewed = RecentMoviesViewedHandler.shared.movies
    
    init(view: SearchView, interactor: SearchInteractorProtocol, router: SearchRouterProtocol) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
    
    func movieProvidersDataReceived(_ data:  [String : [ProviderPlataform]]) {
        for (movieName, providers) in data {
            platforms.updateValue(providers, forKey: movieName)
        }
    }
    
    func getProvidersMovies(forMovies: [MovieWrapper]) {
        interactor?.getMovieProviders(forMovies: forMovies)
    }
    
    func searchParam(_ string: String) {
        guard !isFetching else { return }
        isFetching = true
        var currentPage = 0
        //Still same string param ? -> is scrolling
        //Use page from api response for get last page loaded.
        if string == currentEntry {
            currentPage = searchData?.page ?? 0
        }
        interactor?.searchQuery(param: string, page: currentPage + 1)
        currentEntry = string
    }
    
    func didReceivedSearchResult(data: ResultReponse<Movie>?) {
        isFetching = false
        //var searchData is nil at first data received.
        //data.page is the latest page data received.
        //data.page must be greater than the out updated searchData.
        if searchData == nil || (data?.page ?? 0 <= searchData?.page ?? 0) {
            searchData = data
        } else {
            searchData?.page = data?.page ?? 0
            searchData?.results.append(contentsOf: data?.results ?? [])
            searchData?.totalResults = data?.totalResults ?? 0
        }
        let wrappers = searchData?.results.map({ return MovieWrapper(section: .recommended, movie: $0)}) ?? []
        self.getProvidersMovies(forMovies: wrappers)
        self.view?.updateViewWithResults(data: searchData?.results ?? [])
    }
    
    
    func didTapMovie(index: Int) {
        router?.navigateToMovieDetail(from: self.view, movie: searchData!.results[index])
    }
}
