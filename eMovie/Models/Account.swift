//
//  Account.swift
//  eMovie
//
//  Created by Leandro Berli on 05/11/2022.
//

import Foundation

struct Account: Codable {
    var id: Int
    var name: String
    var username: String
    var avatar: Avatar
}

struct Avatar: Codable {
    var gravatar: Gravatar
    var tmdb: TMDBAvatarProp
}

struct Gravatar: Codable {
    var hash: String?
}

struct TMDBAvatarProp: Codable {
    var avatar_path: String?
}
