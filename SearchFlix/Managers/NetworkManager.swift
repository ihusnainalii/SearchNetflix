//
//  NetworkManager.swift
//  SearchFlix
//
//  Created by Husnian Ali on 17.02.2025.
//

import Foundation

protocol NetworkManagerProtocol {
    func makeRequest<T: Decodable>(endpoint: Endpoint, type: T.Type, completed: @escaping (Result<T, SFError>) -> Void)
}

final class NetworkManager: NetworkManagerProtocol {
    static let shared = NetworkManager()

    func makeRequest<T: Decodable>(endpoint: Endpoint, type: T.Type, completed: @escaping (Result<T, SFError>) -> Void) {
        guard let url = endpoint.url else {
            completed(.failure(.invalidKeyword))
            return
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let _ = error {
                completed(.failure(.unableToComplete))
                return
            }
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.invalidResponse))
                return
            }
            guard let data else {
                completed(.failure(.invalidData))
                return
            }
            do {
                let decoder = JSONDecoder()
                let decodedObject = try decoder.decode(T.self, from: data)
                completed(.success(decodedObject))
            } catch {
                completed(.failure(.invalidData))
            }
        }.resume()
    }
}
