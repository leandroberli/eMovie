//
//  MovieProviderClient.swift
//  eMovie
//
//  Created by Leandro Berli on 06/11/2022.
//

import Foundation
import UIKit

protocol MovieProviderClientProtocol {
    var core: CoreHTTPClient? { get set }
    
    func getMovieProvider(movieName: String, completion: @escaping (ItemMovieProvider?, Error?) -> Void)
}


class MovieProviderClient: MovieProviderClientProtocol {
    var core: CoreHTTPClient? = CoreHTTPClient()
    let baseURL = "https://www.buscala.tv/api/"
    
    enum APIPath: String {
        case search = "search"
    }
    
    func getMovieProvider(movieName: String, completion: @escaping (ItemMovieProvider?, Error?) -> Void) {
        let params = ["title": movieName]
        let url = baseURL + APIPath.search.rawValue
        core?.request(url: url ,params: params, responseType: SearchMovieProvidersResponse.self) { res, err in
            if let items = res?.results?.first {
                //Use only providers wich has logo image resource.
                //Logo images should set at ProvidersLogo enum.
                let filtredITems = items.platforms?.filter({
                    for itemConfigured in ProviderPlataform.ProviderLogos.allCases {
                        if itemConfigured.rawValue == $0.name?.lowercased() {
                            return true
                        }
                    }
                    return false
                })
                var newRes = res?.results?.first
                newRes?.platforms = filtredITems
                completion(newRes,nil)
                return
            }
            completion(nil,nil)
        }
    }
}

struct SearchMovieProvidersResponse: Codable {
    var results: [ItemMovieProvider]?
}

struct ItemMovieProvider: Codable {
    var name: String?
    var platforms: [ProviderPlataform]?
}

struct ProviderPlataform: Codable {
    var name: String?
    var url: String?
    
    func getImage() -> UIImage? {
        for logo in ProviderLogos.allCases {
            if logo.rawValue == self.name?.lowercased() {
                return logo.image
            }
        }
        //Default image
        let img = UIImage(systemName: "play.cirecle.fill")
        return img
    }
    
    enum ProviderLogos: String, CaseIterable {
        case amazon = "amazon prime video"
        case google = "google play movies"
        case hbo = "hbo max"
        case netflix = "netflix"
        case itunes = "apple itunes"
        case claroVideo = "claro video"
        case starPlus = "star plus"
        case qubitTv = "qubittv"
        case paramount = "paramount plus"
        case filmbox = "filmbox+"
        case movistar = "movistar play"
        case disney = "disney plus"
        case appleTv = "apple tv plus"
        
        var image: UIImage? {
            switch self {
            case .amazon:
                return UIImage(named: "prime-video-icon")
            case .hbo:
                return UIImage(named: "hbo-go-icon")
            case .netflix:
                return UIImage(named: "netflix_icon")
            case .itunes:
                return UIImage(named: "icons8-itunes")
            case .paramount:
                return UIImage(named: "icons8-paramount-plus-64")
            case .starPlus:
                return UIImage(named: "star-plus")
            case .google:
                return UIImage(named: "google-play-movies-tv")
            case .movistar:
                return UIImage(named: "movistar-play")
            case .disney:
                return UIImage(named: "icons8-disney-plus-64")
            default:
                return UIImage(systemName: "play.circle.fill")
            }
        }
    }
}
