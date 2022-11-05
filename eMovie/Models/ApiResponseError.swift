//
//  ApiResponseError.swift
//  eMovie
//
//  Created by Leandro Berli on 05/11/2022.
//

import Foundation

struct ApiResponseError: Codable {
    var success: Bool
    var status_code: Int
    var status_message: String
}

enum MovieError: Int, Error, LocalizedError {
    case unknownError
    case emailNotVerified = 32
    case loginInfoRequired = 26
    case invalidUsernameOrPassword = 30
    case resourceNotFound = 34
    case parseError
    case serverError
    
    public var errorDescription: String? {
        switch self {
        case .emailNotVerified:
            return NSLocalizedString("Email not verified", comment: "")
        case .invalidUsernameOrPassword:
            return NSLocalizedString("Your email or password are wrong.", comment: "")
        case .parseError:
            return NSLocalizedString("Something went wrong. Try later.", comment: "")
        case .serverError:
            return NSLocalizedString("Something went wrong. Try later.", comment: "")
        case .loginInfoRequired:
            return NSLocalizedString("Please provide username and password", comment: "")
        case .resourceNotFound:
            return NSLocalizedString("Something went wrong. Try later.", comment: "")
        default:
            return NSLocalizedString("Something went wrong. Try later.", comment: "")
        }
    }
}
