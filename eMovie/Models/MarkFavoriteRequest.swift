//
//  MarkFavoriteRequest.swift
//  eMovie
//
//  Created by Leandro Berli on 05/11/2022.
//

import Foundation

struct MarkFavoriteRequest: Codable {
    var media_type: String = "movie"
    var media_id: Int = 614939
    var favorite: Bool = true
}
