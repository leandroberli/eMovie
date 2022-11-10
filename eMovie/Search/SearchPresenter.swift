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
    
    func searchParam(_ string: String)
    func startFetchMovieProviders(forMovies: [MovieWrapper])
    func didReceivedSearchResult(data: ResultReponse<Movie>?)
    func didReceivedProvidersData(data: [ProviderPlataform]?)
    func didTapMovie(index: Int)
}

class SearchPresenter: SearchPresenterProtocol {

    var platforms: [String : Any] = [:]
    
    func startFetchMovieProviders(forMovies: [MovieWrapper]) {
        forMovies.forEach({
            getProvidedPlatforms(movie: $0)
        })
    }
    
    private func getProvidedPlatforms(movie: MovieWrapper) {
        interactor?.getMovieProviders(for: movie.movie.original_title ?? "")
    }
    
    func didReceivedProvidersData(data: [ProviderPlataform]?) {
        
    }
    
    var view: SearchView?
    var interactor: SearchInteractorProtocol?
    var router: SearchRouterProtocol?
    var searchData: ResultReponse<Movie>?
    var currentEntry = ""
    var isFetching = false
    
    
    init(view: SearchView, interactor: SearchInteractorProtocol, router: SearchRouterProtocol) {
        self.view = view
        self.interactor = interactor
        self.router = router
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
            searchData?.total_results = data?.total_results ?? 0
        }
        
        let wrappers = searchData?.results.map({ return MovieWrapper(section: .recommended, movie: $0)}) ?? []
        
        self.startFetchMovieProviders(forMovies: wrappers)
        
        self.view?.updateViewWithResults(data: searchData?.results ?? [])
    }
    
    
    func didTapMovie(index: Int) {
        router?.navigateToMovieDetail(from: self.view, movie: searchData!.results[index])
    }
}
