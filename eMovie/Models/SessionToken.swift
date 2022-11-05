//
//  SessionToken.swift
//  eMovie
//
//  Created by Leandro Berli on 05/11/2022.
//

import Foundation

struct SessionTokenRequest: Codable {
    var request_token: String
}

struct SessionTokenResponse: Codable {
    var session_id: String
}
