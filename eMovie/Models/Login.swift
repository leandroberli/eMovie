//
//  Login.swift
//  eMovie
//
//  Created by Leandro Berli on 05/11/2022.
//

import Foundation

struct LoginRequest: Codable {
    var username: String
    var password: String
    var request_token: String
}

struct LoginResponse: Codable {
    var success: Bool
    var expires_at: String
    var request_token: String
}
