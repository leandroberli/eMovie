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
}

class HTTPClient: HTTPClientProtocol {
    func getTopRatedMovies(completion: @escaping ([Movie]?, Error?) -> Void) {
        guard let url = URL(string: "https://api.themoviedb.org/3/movie/top_rated?api_key=08d44b3e7e0dbcc89da8843aad55d48b&language=en-US&page=1") else {
            return
        }
        
        URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
            if let err = error {
                print(err.localizedDescription)
                completion(nil,err)
                return
            }
            if let data = data, let s = String(data: data, encoding: .utf8) {
                //print(#function, "URLRequest: \(request.url!.absoluteURL)")
                print(s)
                do {
                    let response = try JSONDecoder().decode(ResultReponse<Movie>.self, from: data)
                    completion(response.results,nil)
                } catch {
                    print("JSON Error: ", error.localizedDescription)
                }
            }
        }.resume()
    }
    
    
    func getUpcomingMovies(completion: @escaping ([Movie]?,Error?) -> Void) {
        guard let url = URL(string: "https://api.themoviedb.org/3/movie/upcoming?api_key=08d44b3e7e0dbcc89da8843aad55d48b&language=en-US&page=1") else {
            return
        }
        
        URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
            if let err = error {
                print(err.localizedDescription)
                completion(nil,err)
                return
            }
            if let data = data, let s = String(data: data, encoding: .utf8) {
                //print(#function, "URLRequest: \(request.url!.absoluteURL)")
                print(s)
                do {
                    let response = try JSONDecoder().decode(ResultReponse<Movie>.self, from: data)
                    completion(response.results,nil)
                } catch {
                    print("JSON Error: ", error.localizedDescription)
                }
            }
        }.resume()
    }
    
}
