//
//  HTTPClient.swift
//  eMovie
//
//  Created by Leandro Berli on 27/10/2022.
//

import Foundation

protocol HTTPClientProtocol {
    func getUpcomingMovies(page: Int,completion: @escaping (ResultReponse<Movie>?,MovieError?) -> Void)
    func getTopRatedMovies(page: Int,completion: @escaping (ResultReponse<Movie>?,MovieError?) -> Void)
    func getDetailMovie(withId: Int, completion: @escaping (MovieDetail?,MovieError?) -> Void)
    func getMovieVideo(withId: Int, completion: @escaping ([Video]?,MovieError?) -> Void)
    func createRequestToken(completion: @escaping (RequestTokenResponse?,MovieError?) -> Void)
    func validateWithLogin(loginData: LoginRequest, completion: @escaping (LoginResponse?,MovieError?) -> Void)
    func createSessionToken(sessionTokenRequest: SessionTokenRequest, completion: @escaping (String?,MovieError?) -> Void)
    func getAccountDetails(completion: @escaping (Account?,MovieError?) -> Void)
    func markAsFavorite(favoriteData: MarkFavoriteRequest, completion: @escaping (ApiResponseError?) -> Void)
    func getFavoritedMovies(completion: @escaping ([Movie]?,MovieError?) -> Void)
    func searchMoviesWithParams(param: String, page: Int, completion: @escaping (ResultReponse<Movie>?,MovieError?) -> Void)
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
        case favorite = "account/{account_id}/favorite"
        case getFavoriteMovies = "account/{account_id}/favorite/movies"
        case search = "search/movie"
    }
    
    //MARK: Search
    func searchMoviesWithParams(param: String, page: Int, completion: @escaping (ResultReponse<Movie>?, MovieError?) -> Void) {
        let params = ["query": param, "page": "\(page)"]
        let url = baseURL + ApiPath.search.rawValue
        CoreHTTPClient.shared.request(url: url, params: params, responseType: ResultReponse<Movie>.self) { res, err in
            completion(res,err)
        }
    }
    
    //MARK: User services
    func getFavoritedMovies(completion: @escaping ([Movie]?, MovieError?) -> Void) {
        let url = baseURL + ApiPath.getFavoriteMovies.rawValue.replacingOccurrences(of: "{account_id}", with: "8872462")
        CoreHTTPClient.shared.request(url: url, responseType: ResultReponse<Movie>.self) { res, err in
            completion(res?.results, err)
        }
    }
    
    func markAsFavorite(favoriteData: MarkFavoriteRequest, completion: @escaping (ApiResponseError?) -> Void) {
        let url = baseURL + ApiPath.favorite.rawValue.replacingOccurrences(of: "{account_id}", with: "8872462")
        CoreHTTPClient.shared.request(url: url, data: favoriteData, responseType: ApiResponseError.self) { res, err in
            completion(res)
        }
    }
    
    func getAccountDetails(completion: @escaping (Account?,MovieError?) -> Void) {
        CoreHTTPClient.shared.request(url: baseURL + ApiPath.account.rawValue, responseType: Account.self) { res, error in
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
    func getTopRatedMovies(page: Int, completion: @escaping (ResultReponse<Movie>?, MovieError?) -> Void) {
        let urlString = baseURL + ApiPath.topRatedMovieList.rawValue
        let params = ["page": "\(page)"]
        CoreHTTPClient.shared.request(url: urlString,params: params, responseType: ResultReponse<Movie>.self) { res, error in
            completion(res,error)
        }
    }
    
    func getUpcomingMovies(page: Int,completion: @escaping (ResultReponse<Movie>?,MovieError?) -> Void) {
        let urlString = baseURL + ApiPath.upcomingMovieList.rawValue
        let params = ["page": "\(page)"]
        CoreHTTPClient.shared.request(url: urlString,params: params, responseType: ResultReponse<Movie>.self) { movies, error in
            completion(movies, error)
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
