//
//  CoreHTTPClient.swift
//  eMovie
//
//  Created by Leandro Berli on 05/11/2022.
//

import Foundation

class CoreHTTPClient {
    
    static let shared = CoreHTTPClient()
    private let apiKey = "08d44b3e7e0dbcc89da8843aad55d48b"
    
    func request<T: Codable>(url: String,
                             params: [String: String]? = nil,
                             data: Codable? = nil,
                             responseType: T.Type,
                             completion: @escaping (T?,MovieError?) -> Void) {
        
        guard let url = URL(string: url) else {
            print(#function, "Error creating URL for Request")
            return
        }
        
        let request = generateURLRequest(with: url, andQuery: params, bodyData: data)
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let err = error {
                print(err.localizedDescription)
                completion(nil,.serverError)
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
                        completion(nil, .parseError)
                    }
                } else {
                    do {
                        let data = try JSONDecoder().decode(ApiResponseError.self, from: data)
                        let error = MovieError(rawValue: data.status_code ?? 0) ?? .unknownError
                        completion(nil,error)
                    } catch {
                        print("JSON Error: ", error.localizedDescription)
                        completion(nil, .parseError)
                    }
                }
            }
        }.resume()
    }
    
    
    //Generate query parameteres and body data
    func generateURLRequest(with url: URL, andQuery params: [String: String]? = nil, bodyData: Codable? = nil) -> URLRequest {
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        var queryItems: [URLQueryItem] = []
        let apiQuery = URLQueryItem(name: "api_key", value: apiKey)
        queryItems.append(apiQuery)
        
        if let sessionToken = UserDefaults.standard.value(forKey: "sessionToken") as? String {
            let sessionTokenItem = URLQueryItem(name: "session_id", value: sessionToken)
            queryItems.append(sessionTokenItem)
        }
        
        if let queryDict = params {
            queryDict.forEach({
                queryItems.append(URLQueryItem(name: $0.key, value: $0.value))
            })
        }
        
        if let data = bodyData {
            let encoder = JSONEncoder()
            let data = try? encoder.encode(data)
            print("HTTP BODY: ", String(data: data!, encoding: .utf8)!)
            request.httpBody = data
            request.httpMethod = "POST"
        }
    
        let connectionAvailable = NetworkStatusHandler.shared.connectionAvailable
        request.url?.append(queryItems: queryItems)
        request.cachePolicy = connectionAvailable ? .reloadIgnoringLocalCacheData : .returnCacheDataDontLoad
        
        return request
    }
}
