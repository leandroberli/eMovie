//
//  HTTPClient.swift
//  eMovie
//
//  Created by Leandro Berli on 27/10/2022.
//

import Foundation

protocol HTTPClientProtocol {
    func getUpcomingMovies(completion: @escaping ([Movie]?,MovieError?) -> Void)
    func getTopRatedMovies(completion: @escaping ([Movie]?,MovieError?) -> Void)
    func getDetailMovie(withId: Int, completion: @escaping (MovieDetail?,MovieError?) -> Void)
    func getMovieVideo(withId: Int, completion: @escaping ([Video]?,MovieError?) -> Void)
    func createRequestToken(completion: @escaping (RequestTokenResponse?,MovieError?) -> Void)
    func validateWithLogin(loginData: LoginRequest, completion: @escaping (LoginResponse?,MovieError?) -> Void)
    func createSessionToken(sessionTokenRequest: SessionTokenRequest, completion: @escaping (String?,MovieError?) -> Void)
    func getAccountDetails(completion: @escaping (Account?,MovieError?) -> Void)
}

class HTTPClient: HTTPClientProtocol {
    private let baseURL = "https://api.themoviedb.org/3/"
    
    enum ApiPath: String {
        case topRatedMovieList = "movie/top_rated"
        case upcomingMovieList = "movie/upcoming"
        case movieDetail = "movie/{movie_id}"
        case movieVideos = "movie/{movie_id}/videos"
        case createRequestToken = "authentication/token/new"
        case createLoginSession = "authentication/token/validate_with_login"
        case createSessionToken = "authentication/session/new"
        case account = "account"
    }
    
    //MARK: User services
    func getAccountDetails(completion: @escaping (Account?,MovieError?) -> Void) {
        guard let sessionToken = UserDefaults.standard.value(forKey: "sessionToken") as? String else {
            return
        }
        CoreHTTPClient.shared.request(url: baseURL + ApiPath.account.rawValue, params: ["session_id": sessionToken], responseType: Account.self) { res, error in
            completion(res,error)
        }
    }
    
    //MARK: Login services
    func createSessionToken(sessionTokenRequest: SessionTokenRequest, completion: @escaping (String?, MovieError?) -> Void) {
        let url = baseURL + ApiPath.createSessionToken.rawValue
        CoreHTTPClient.shared.request(url: url, data: sessionTokenRequest, responseType: SessionTokenResponse.self) { res, err in
            completion(res?.session_id, err)
        }
    }
    
    func validateWithLogin(loginData: LoginRequest, completion: @escaping (LoginResponse?,MovieError?) -> Void) {
        let url = baseURL + ApiPath.createLoginSession.rawValue
        CoreHTTPClient.shared.request(url: url, data: loginData, responseType: LoginResponse.self) { res, error in
            completion(res,error)
        }
    }
    
    func createRequestToken(completion: @escaping (RequestTokenResponse?,MovieError?) -> Void) {
        let urlString = baseURL + ApiPath.createRequestToken.rawValue
        CoreHTTPClient.shared.request(url: urlString, responseType: RequestTokenResponse.self) { res, error in
            completion(res,error)
        }
    }
   
    //MARK: Home services
    func getTopRatedMovies(completion: @escaping ([Movie]?, MovieError?) -> Void) {
        let urlString = baseURL + ApiPath.topRatedMovieList.rawValue
        CoreHTTPClient.shared.request(url: urlString, responseType: ResultReponse<Movie>.self) { res, error in
            completion(res?.results,error)
        }
    }
    
    func getUpcomingMovies(completion: @escaping ([Movie]?,MovieError?) -> Void) {
        let urlString = baseURL + ApiPath.upcomingMovieList.rawValue
        CoreHTTPClient.shared.request(url: urlString, responseType: ResultReponse<Movie>.self) { movies, error in
            completion(movies?.results, error)
        }
    }
    
    //MARK: Detail services
    func getDetailMovie(withId: Int, completion: @escaping (MovieDetail?,MovieError?) -> Void) {
        let urlString = baseURL + ApiPath.movieDetail.rawValue.replacingOccurrences(of: "{movie_id}", with: "\(withId)")
        CoreHTTPClient.shared.request(url: urlString, responseType: MovieDetail.self) { res, err in
            completion(res,err)
        }
    }
    
    func getMovieVideo(withId: Int, completion: @escaping ([Video]?,MovieError?) -> Void) {
        let url = baseURL + ApiPath.movieVideos.rawValue.replacingOccurrences(of: "{movie_id}", with: "\(withId)")
        CoreHTTPClient.shared.request(url: url, responseType: VideoResponse.self) { res, err in
            completion(res?.results,err)
        }
    }
}
