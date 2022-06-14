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
    func fetchGenericData<T: Decodable>(urlString: String, type: T.Type, completion: @escaping (Swift.Result<T, Error>) -> ())
}


class FilmDataManager: NetWorkingProtocol {
    
    typealias completeClosure = ( _ data: Data?, _ error: Error?)->Void
    
    let session: URLSession
    
    init(urlSession: URLSession = .shared) {
        self.session = urlSession
    }
    
    func fetchGenericData<T: Decodable>(urlString: String, type: T.Type, completion: @escaping (Swift.Result<T, Error>) -> ()) {

        guard let url = URL(string: urlString)  else {
            completion(.failure(NetworkError.badURL))
            return
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
//        urlRequest.setValue("wordsapiv1.p.rapidapi.com", forHTTPHeaderField: "X-RapidAPI-Host")
//        urlRequest.setValue(apiKey, forHTTPHeaderField: "X-RapidAPI-Key")

        session.dataTask(with: urlRequest) { data, response, error in
            guard let data = data, error == nil else {
                completion(.failure(NetworkError.noDataReturned))
                return
            }

            do {
                let obj = try JSONDecoder().decode(T.self, from: data)
                completion(.success(obj))

            } catch {
                completion(.failure(error))
                print("Failed to convert \(error.localizedDescription)")
            }
        }.resume()
    }
}
