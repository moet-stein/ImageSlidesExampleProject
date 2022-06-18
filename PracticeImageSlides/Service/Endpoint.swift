//
//  Endpoint.swift
//  PracticeImageSlides
//
//  Created by Moe Steinmueller on 18.06.22.
//

import Foundation

protocol Endpoint {
    var scheme: String { get }
    
    var baseURL: String { get }
    
    var path: String { get }
    
    var parameters: [URLQueryItem] { get }
    
    var method: String { get }
}
