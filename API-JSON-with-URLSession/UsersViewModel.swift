//
//  UsersViewModel.swift
//  API-JSON-with-URLSession
//
//  Created by Byron Mejia on 7/31/22.
//

import Foundation
import Combine

final class UsersViewModel: ObservableObject {
    @Published private(set) var isRefreshing = false
    @Published var hasError = false
    @Published var users = [User]()
    @Published var error: UserError?
    private var bag = Set<AnyCancellable>()
    
    func fetchUsers() {
        let usersUrlString = "https://jsonplaceholder.typicode.com/users"
        
        if let url = URL(string: usersUrlString) {
            isRefreshing = true
            hasError = false
            
            URLSession
                .shared
                .dataTaskPublisher(for: url)
                .receive(on: DispatchQueue.main)
                .tryMap { res in
                    guard let response = res.response as? HTTPURLResponse,
                          response.statusCode >= 200 && response.statusCode <= 300 else {
                              throw UserError.invalidStatusCode
                          }
                    let decoder = JSONDecoder()
                    guard let users = try? decoder.decode([User].self, from: res.data) else {
                        throw UserError.failedToDecode
                    }
                    
                    return users
                }
                .sink { [weak self] res in
                    defer { self?.isRefreshing = false }
                    switch res {
                    case .failure(let error):
                        self?.hasError = false
                        self?.error = UserError.custom(error: error)
                    default: break
                    }
                } receiveValue: { [weak self] users in
                    self?.users = users
                }
                .store(in: &bag)
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
