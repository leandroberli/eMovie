//
//  HTTPClient.swift
//  eMovie
//
//  Created by Leandro Berli on 27/10/2022.
//

import Foundation

protocol HTTPClientProtocol {
    func getUpcomingMovies(completion: @escaping ([Movie]?,Error?) -> Void)
    func getTopRatedMovies(completion: @escaping ([Movie]?,Error?) -> Void)
    func getDetailMovie(withId: Int, completion: @escaping (MovieDetail?,Error?) -> Void)
}

class HTTPClient: HTTPClientProtocol {
    
    private let baseURL = "https://api.themoviedb.org/3/"
    
    enum ApiPath: String {
        case topRatedMovieList = "movie/top_rated"
        case upcomingMovieList = "movie/upcoming"
        case movieDetail = "movie/{movie_id}"
    }
    
    private let apiKey = "08d44b3e7e0dbcc89da8843aad55d48b"
   
    func getTopRatedMovies(completion: @escaping ([Movie]?, Error?) -> Void) {
        let urlString = baseURL + ApiPath.topRatedMovieList.rawValue
        CoreHTTPClient.shared.getData(url: urlString, responseType: ResultReponse<Movie>.self) { res, error in
            completion(res?.results,error)
        }
    }
    
    func getUpcomingMovies(completion: @escaping ([Movie]?,Error?) -> Void) {
        let urlString = baseURL + ApiPath.upcomingMovieList.rawValue
        CoreHTTPClient.shared.getData(url: urlString, responseType: ResultReponse<Movie>.self) { movies, error in
            completion(movies?.results, error)
        }
    }
    
    func getDetailMovie(withId: Int, completion: @escaping (MovieDetail?,Error?) -> Void) {
        let urlString = baseURL + ApiPath.movieDetail.rawValue.replacingOccurrences(of: "{movie_id}", with: "\(withId)")
        CoreHTTPClient.shared.getData(url: urlString, responseType: MovieDetail.self) { res, err in
            completion(res,err)
        }
    }
}

class CoreHTTPClient {
    
    static let shared = CoreHTTPClient()
    private let apiKey = "08d44b3e7e0dbcc89da8843aad55d48b"
    
    func getData<T: Codable>(url: String,
                             params: [String: String]? = nil,
                             responseType: T.Type,
                             completion: @escaping (T?,Error?) -> Void) {
        
        guard let url = URL(string: url) else {
            print(#function, "Error creating URL for GET Request")
            return
        }
        
        let request = generateURLRequest(with: url, andQuery: params)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let err = error {
                print(err.localizedDescription)
                completion(nil,err)
                return
            }
            if let data = data, let res = response as? HTTPURLResponse {
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
    func generateURLRequest(with url: URL, andQuery params: [String: String]? = nil) -> URLRequest {
        var request = URLRequest(url: url)
        var queryItems: [URLQueryItem] = []
        
        let apiQuery = URLQueryItem(name: "api_key", value: apiKey)
        queryItems.append(apiQuery)
        
        if let queryDict = params {
            queryDict.forEach({
                print($0)
                queryItems.append(URLQueryItem(name: $0.key, value: $0.value))
            })
        }
        
        request.url?.append(queryItems: queryItems)
        return request
    }
}
