//
//  RequesToken.swift
//  eMovie
//
//  Created by Leandro Berli on 03/11/2022.
//

import Foundation

struct RequestToken: Codable {
//    "success": true,
//    "expires_at": "2022-11-04 02:00:41 UTC",
//    "request_token": "4ad7164f97bf78f265e4653be6b92d02e834704f"
    var success: Bool
    var expires_at: String
    var request_token: String
}

struct NewSessionResponse: Codable {
    var request_token: String
}

struct LoginRequest: Codable {
    var username: String
    var password: String
    var request_token: String
}

struct LoginResponse: Codable {
//    {"success":true,"expires_at":"2022-11-04 12:47:20 UTC","request_token":"8a2fdeef65f7aca221308c8bbe803271f8cc3953"}
    var success: Bool
    var expires_at: String
    var request_token: String
}

struct SessionTokenData: Codable {
    var request_token: String
}

struct SessionTokenResponse: Codable {
    var session_id: String
}

struct Account: Codable {
    var id: Int
}
