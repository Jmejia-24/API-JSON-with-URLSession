//
//  UsersViewModel.swift
//  API-JSON-with-URLSession
//
//  Created by Byron Mejia on 7/31/22.
//

import Foundation

final class UsersViewModel: ObservableObject {
    @Published private(set) var isRefreshing = false
    @Published private(set) var users = [User]()
    @Published var error: ApiCall.UserError?
    @Published var hasError = false

    func execute() async {
        isRefreshing = true
        do {
            try await ApiCall().fetchUsers { users in
                DispatchQueue.main.async {
                    self.users = users
                    self.isRefreshing = false
                }
            }
        } catch {
            if let userError = error as? ApiCall.UserError {
                DispatchQueue.main.async {
                    self.hasError = true
                    self.error = userError
                }
            }
        }
    }
}
