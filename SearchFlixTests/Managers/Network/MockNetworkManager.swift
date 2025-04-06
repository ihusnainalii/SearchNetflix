//
//  MockNetworkManager.swift
//  SearchFlixTests
//
//  Created by Husnian Ali on 27.02.2025.
//

import Foundation
@testable import SearchFlix


final class MockNetworkManager: NetworkManagerProtocol {
    // MARK: - Test Flags
    var makeRequestCalled = false
    var shouldReturnError = false

    // MARK: - Properties
    var mockData: Data?

    // MARK: - Methods
    func makeRequest<T: Decodable>(endpoint: Endpoint, type: T.Type, completed: @escaping (Result<T, SFError>) -> Void) {
        makeRequestCalled = true

        if shouldReturnError {
            completed(.failure(.unableToComplete))
            return
        }

        guard let data = mockData else {
            completed(.failure(.invalidData))
            return
        }

        do {
            let decodedObject = try JSONDecoder().decode(T.self, from: data)
            completed(.success(decodedObject))
        } catch {
            completed(.failure(.invalidData))
        }
    }
}
