//
//  Video.swift
//  eMovie
//
//  Created by Leandro Berli on 28/10/2022.
//

import Foundation

struct VideoResponse: Codable {
    var id: Int
    var results: [Video]
}

struct Video: Codable {
    var name: String
    var key: String
    var site: String
    var type: String
    
    func getVideoURL() -> String {
        return "https://www.youtube.com/embed/" + key
    }
    
    func getVideoURLRequest() -> URLRequest? {
        let str = getVideoURL()
        guard let url = URL(string: str) else {
            return nil
        }
        return URLRequest(url: url)
    }
}
