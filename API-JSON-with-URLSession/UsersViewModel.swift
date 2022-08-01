//
//  UsersViewModel.swift
//  API-JSON-with-URLSession
//
//  Created by Byron Mejia on 7/31/22.
//

import Foundation

final class UsersViewModel: ObservableObject {
    @Published private(set) var isRefreshing = false
    @Published var users = [User]()
    
    @MainActor
    func fetchUsers() async throws {
        let usersUrlString = "https://jsonplaceholder.typicode.com/users"
        if let url = URL(string: usersUrlString) {
            isRefreshing = true
            
            defer { isRefreshing = false }
            
            do {
                let (data, response) = try await URLSession.shared.data(from: url)
                
                guard let response = response as? HTTPURLResponse,
                      response.statusCode >= 200 && response.statusCode <= 299 else {
                          throw UserError.invalidStatusCode
                      }
                
                let decoder = JSONDecoder()
                guard let users = try? decoder.decode([User].self, from: data) else {
                    throw UserError.failedToDecode
                }
                self.users = users
            } catch {
                throw UserError.custom(error: error)
            }
        }
    }
}

extension UsersViewModel {
    enum UserError: LocalizedError {
        case custom(error: Error)
        case failedToDecode
        case invalidStatusCode
        
        var errorDescription: String? {
            switch self {
            case .custom(let error):
                return error.localizedDescription
            case .failedToDecode:
                return "Failed to decode response"
            case .invalidStatusCode:
                return "Request falls within an invalid range"
            }
        }
    }
}
