//
//  RequesToken.swift
//  eMovie
//
//  Created by Leandro Berli on 03/11/2022.
//

import Foundation

struct RequestTokenResponse: Codable {
    var success: Bool
    var expires_at: String
    var request_token: String
}
