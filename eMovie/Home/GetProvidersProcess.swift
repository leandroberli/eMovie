//
//  ProvidersInteractor.swift
//  eMovie
//
//  Created by Leandro Berli on 15/11/2022.
//

import Foundation


protocol GetProvidersProcessDelegate {
    func providersDataReceived(_ data:  [String: [ProviderPlataform]], forSection: Section)
}

/// Defines process for get providers for each movie.
/// The delegate handle the received data. Usually the interactor module.
protocol GetProvidersProcessProtocol {
    var providerClient: MovieProviderClientProtocol? { get set }
    var delegate: GetProvidersProcessDelegate? { get set }
    func startProcess(forMovies: [MovieWrapper])
}

class GetProvidersProcess: GetProvidersProcessProtocol {
    var delegate: GetProvidersProcessDelegate?
    var providerClient: MovieProviderClientProtocol? = MovieProviderClient()
    
    /// Make concurrent request for each movie and wait all responses.
    /// Generate dictionary with movie name as key and providers array as value and then call delegate.
    /// - Parameter forMovies: Movies to get providers
    func startProcess(forMovies: [MovieWrapper]) {
        let section = forMovies.first?.section ?? .topRated
        let group = DispatchGroup()
        var providers: [String: [ProviderPlataform]] = [:]
        
        forMovies.forEach({
            group.enter()
            let movieName = $0.movie.original_title ?? ""
            providerClient?.getMovieProvider(movieName: movieName) { res, err in
                if let provs = res?.platforms {
                    providers.updateValue(provs, forKey: movieName)
                }
                group.leave()
            }
        })
        
        group.notify(queue: .main) {
            print("ALL PROVIDER REQUEST FROM SECTION \(section.title) FINISHED")
            self.delegate?.providersDataReceived(providers, forSection: section)
        }
    }
}
