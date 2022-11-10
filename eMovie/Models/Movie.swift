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
    var poster_path: String?
    var adult: Bool?
    var overview: String?
    var release_date: String?
    var original_language: String?
    var genre_ids: [Int]?
    var id: Int?
    var original_title: String?
    var vote_average: Float?
    
    func getPosterURL() -> String {
        return "https://image.tmdb.org/t/p/w1280" + (poster_path ?? "")
    }
    
    func getVoteAverageToString() -> String {
        return "\(vote_average ?? 0.0)"
    }
    
    func getReleaseYear() -> Int {
        //\"1994-09-10\"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        guard let date = dateFormatter.date(from: (self.release_date ?? "")) else {
            return 0
        }
        
        let calendar = Calendar.current
        let comps = calendar.dateComponents([.year], from: date)
        let year = comps.year
        return year ?? 0
    }
}
