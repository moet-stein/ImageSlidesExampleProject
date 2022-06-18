//
//  FilmDataManager.swift
//  PracticeImageSlides
//
//  Created by Moe Steinmueller on 12.06.22.
//

import Foundation

enum NetworkError: Error {
    case badURL
    case noDataReturned
}

protocol NetWorkingProtocol {
    func fetchGenericData<T: Decodable>(endpoint: Endpoint?, type: T.Type, completion: @escaping (Swift.Result<T, Error>) -> ())
}


class FilmDataManager: NetWorkingProtocol {
    
    typealias completeClosure = ( _ data: Data?, _ error: Error?)->Void
    
    let session: URLSession
    
    init(urlSession: URLSession = .shared) {
        self.session = urlSession
    }
    
    func fetchGenericData<T: Decodable>(endpoint: Endpoint?, type: T.Type, completion: @escaping (Swift.Result<T, Error>) -> ()) {
        
        guard let endpoint = endpoint else {
            completion(.failure(NetworkError.badURL))
            return
        }
        
        var components = URLComponents()
        components.scheme = endpoint.scheme
        components.host = endpoint.baseURL
        components.path = endpoint.path
        components.queryItems = endpoint.parameters
        
        guard let url = components.url else {return}
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = endpoint.method
        
        let session = URLSession(configuration: .default)
        let dataTask = session.dataTask(with: urlRequest) { data, response, error in
            
            guard error == nil else {
                completion(.failure(NetworkError.noDataReturned))
                return
            }
            
            guard response != nil, let data = data else { return }
            
            DispatchQueue.main.async {
                if let responseObject = try? JSONDecoder().decode(T.self, from: data) {
                    completion(.success(responseObject))
                } else {
                    let error = NSError(domain: "", code: 200, userInfo: [NSLocalizedDescriptionKey: "Failed to decode response"])
                    completion(.failure(error))
                }
            }
        }
        
        dataTask.resume()

//        guard let url = URL(string: urlString)  else {
//            completion(.failure(NetworkError.badURL))
//            return
//        }
//
//        var urlRequest = URLRequest(url: url)
//        urlRequest.httpMethod = "GET"
//
//        session.dataTask(with: urlRequest) { data, response, error in
//            guard let data = data, error == nil else {
//                completion(.failure(NetworkError.noDataReturned))
//                return
//            }
//
//            do {
//                let obj = try JSONDecoder().decode(T.self, from: data)
//                completion(.success(obj))
//
//            } catch {
//                completion(.failure(error))
//                print("Failed to convert \(error.localizedDescription)")
//            }
//        }.resume()
    }
}
