//
//  HTTPClient.swift
//  eMovie
//
//  Created by Leandro Berli on 27/10/2022.
//

import Foundation

struct ApiResponseError: Codable {
    var success: Bool
    var status_code: Bool
    var status_message: String
}

protocol HTTPClientProtocol {
    func getUpcomingMovies(completion: @escaping ([Movie]?,Error?) -> Void)
    func getTopRatedMovies(completion: @escaping ([Movie]?,Error?) -> Void)
    func getDetailMovie(withId: Int, completion: @escaping (MovieDetail?,Error?) -> Void)
    func getMovieVideo(withId: Int, completion: @escaping ([Video]?,Error?) -> Void)
    
    func createRequestToken(completion: @escaping (RequestTokenResponse?,Error?) -> Void)
    func validateWithLogin(loginData: LoginRequest, completion: @escaping (LoginResponse?,Error?) -> Void)
    func createSessionToken(sessionTokenRequest: SessionTokenRequest, completion: @escaping (String?,Error?) -> Void)
    
    
    func getAccountDetails(completion: @escaping (Account?,Error?) -> Void)
}

class HTTPClient: HTTPClientProtocol {
    func createSessionToken(sessionTokenRequest: SessionTokenRequest, completion: @escaping (String?, Error?) -> Void) {
        let url = baseURL + ApiPath.createSessionToken.rawValue
        CoreHTTPClient.shared.request(url: url, data: sessionTokenRequest, responseType: SessionTokenResponse.self) { res, err in
            completion(res?.session_id, err)
        }
    }
    
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
    
    func getAccountDetails(completion: @escaping (Account?,Error?) -> Void) {
        let sessionToken = UserDefaults.standard.value(forKey: "sessionToken") as! String
        CoreHTTPClient.shared.request(url: baseURL + ApiPath.account.rawValue, params: ["session_id": sessionToken], responseType: Account.self) { res, error in
            completion(res,error)
        }
    }
    
    func validateWithLogin(loginData: LoginRequest, completion: @escaping (LoginResponse?,Error?) -> Void) {
        let url = baseURL + ApiPath.createLoginSession.rawValue
        CoreHTTPClient.shared.request(url: url, data: loginData, responseType: LoginResponse.self) { res, error in
            completion(res,error)
        }
    }
    
    func createRequestToken(completion: @escaping (RequestTokenResponse?,Error?) -> Void) {
        let urlString = baseURL + ApiPath.createRequestToken.rawValue
        CoreHTTPClient.shared.request(url: urlString, responseType: RequestTokenResponse.self) { res, error in
            completion(res,error)
        }
    }
   
    func getTopRatedMovies(completion: @escaping ([Movie]?, Error?) -> Void) {
        let urlString = baseURL + ApiPath.topRatedMovieList.rawValue
        CoreHTTPClient.shared.request(url: urlString, responseType: ResultReponse<Movie>.self) { res, error in
            completion(res?.results,error)
        }
    }
    
    func getUpcomingMovies(completion: @escaping ([Movie]?,Error?) -> Void) {
        let urlString = baseURL + ApiPath.upcomingMovieList.rawValue
        CoreHTTPClient.shared.request(url: urlString, responseType: ResultReponse<Movie>.self) { movies, error in
            completion(movies?.results, error)
        }
    }
    
    func getDetailMovie(withId: Int, completion: @escaping (MovieDetail?,Error?) -> Void) {
        let urlString = baseURL + ApiPath.movieDetail.rawValue.replacingOccurrences(of: "{movie_id}", with: "\(withId)")
        CoreHTTPClient.shared.request(url: urlString, responseType: MovieDetail.self) { res, err in
            completion(res,err)
        }
    }
    
    func getMovieVideo(withId: Int, completion: @escaping ([Video]?,Error?) -> Void) {
        let url = baseURL + ApiPath.movieVideos.rawValue.replacingOccurrences(of: "{movie_id}", with: "\(withId)")
        CoreHTTPClient.shared.request(url: url, responseType: VideoResponse.self) { res, err in
            completion(res?.results,err)
        }
    }
}

class CoreHTTPClient {
    
    static let shared = CoreHTTPClient()
    private let apiKey = "08d44b3e7e0dbcc89da8843aad55d48b"
    
    func request<T: Codable>(url: String,
                             params: [String: String]? = nil,
                             data: Codable? = nil,
                             responseType: T.Type,
                             completion: @escaping (T?,Error?) -> Void) {
        
        guard let url = URL(string: url) else {
            print(#function, "Error creating URL for Request")
            return
        }
        
        let request = generateURLRequest(with: url, andQuery: params, bodyData: data)
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let err = error {
                print(err.localizedDescription)
                completion(nil,err)
                return
            }
            if let data = data, let res = response as? HTTPURLResponse {
                let dataString = String(data: data, encoding: .utf8)
                print("-----URL REQUEST: ", request.url?.absoluteURL ?? "")
                print(" DATA RESPONSE: ", dataString ?? "")
                if (200...299).contains(res.statusCode) {
                    do {
                        let data = try JSONDecoder().decode(responseType.self, from: data)
                        completion(data, nil)
                    } catch {
                        print("JSON Error: ", error.localizedDescription)
                        completion(nil, error)
                    }
                } else {
                    //TODO: Handle server error
                    completion(nil, nil)
                }
            }
        }.resume()
    }
    
    
    //Generate query parameteres
    func generateURLRequest(with url: URL, andQuery params: [String: String]? = nil, bodyData: Codable? = nil) -> URLRequest {
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        var queryItems: [URLQueryItem] = []
        let apiQuery = URLQueryItem(name: "api_key", value: apiKey)
        queryItems.append(apiQuery)
        
        if let queryDict = params {
            queryDict.forEach({
                queryItems.append(URLQueryItem(name: $0.key, value: $0.value))
            })
        }
        
        if let data = bodyData {
            let encoder = JSONEncoder()
            let data = try? encoder.encode(data)
            print("HTTP BODY: ", String(data: data!, encoding: .utf8))
            request.httpBody = data
            request.httpMethod = "POST"
        }
    
        let connectionAvailable = NetworkStatusHandler.shared.connectionAvailable
        request.url?.append(queryItems: queryItems)
        request.cachePolicy = connectionAvailable ? .reloadIgnoringLocalCacheData : .returnCacheDataDontLoad
        
        return request
    }
}
