//
//  GhibliapiEndpoint.swift
//  PracticeImageSlides
//
//  Created by Moe Steinmueller on 18.06.22.
//

import Foundation

//"https://ghibliapi.herokuapp.com/films"
enum GhibliapiEndpoint: Endpoint {
    case getSearchResults
    
    var scheme: String {
        switch self {
        default:
            return "https"
        }
    }
    
    var baseURL: String {
        switch self {
        default:
            return "ghibliapi.herokuapp.com"
        }
    }
    
    var path: String {
        switch self {
        case .getSearchResults:
            return "/films"
        }
    }
    
    var parameters: [URLQueryItem] {
//        let apiKey = ""
        switch self {
        case .getSearchResults:
            return []
        }
    }
    
    var method: String {
        switch self {
        case .getSearchResults:
            return "GET"
        }
    }
    
    
}
