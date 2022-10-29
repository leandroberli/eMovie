//
//  MovieDetail.swift
//  eMovie
//
//  Created by Leandro Berli on 28/10/2022.
//

import Foundation

struct MovieDetail: Codable {
    var id: Int?
    //var spoken_languages: [Language]
    var release_date: String?
    var poster_path: String?
    var adult: Bool?
    var overview: String?
    var original_language: String?
    var original_title: String?
    var vote_average: Float?
    var genres: [Genre]?
    
    func getPosterURL() -> String {
        return "https://image.tmdb.org/t/p/w1280" + (poster_path ?? "")
    }
    
    func getReleaseYear() -> Int {
        //\"1994-09-10\"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        guard let dateStr = self.release_date, let date = dateFormatter.date(from: dateStr) else {
            return 0
        }
        
        let calendar = Calendar.current
        let comps = calendar.dateComponents([.year], from: date)
        let year = comps.year
        return year ?? 0
    }
    
    func getGenresString() -> String {
        if let genres = genres {
            var str = ""
            var count = 1
            genres.forEach({
                str += $0.name
                count != genres.count ? str.append(" - ") : ()
                count += 1
            })
            return str
        }
        return ""
    }
}

struct Genre: Codable {
    var id: Int
    var name: String
}

struct Language: Codable {
    var iso_639_1: String
    var name: String
}
