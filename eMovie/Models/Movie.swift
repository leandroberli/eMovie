//
//  Moview.swift
//  eMovie
//
//  Created by Leandro Berli on 26/10/2022.
//

import Foundation

struct ResultReponse<Result: Codable>: Codable {
    var page: Int
    var results: [Result]
    var total_pages: Int
    var total_results: Int
}

struct Movie: Codable, Hashable {
    var poster_path: String
    var adult: Bool
    var overview: String
    var release_date: String
    var genre_ids: [Int]
    var id: Int
    var original_title: String
    
    func getPosterURL() -> String {
        return "https://image.tmdb.org/t/p/w1280" + poster_path
    }
}
