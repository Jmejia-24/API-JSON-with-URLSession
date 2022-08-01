//
//  ContentView.swift
//  API-JSON-with-URLSession
//
//  Created by Byron Mejia on 7/31/22.
//

import SwiftUI

struct HomeUserListView: View {
    @StateObject private var viewModel = UsersViewModel()
    @State private var error: UsersViewModel.UserError?
    @State private var hasError = false
    
    var body: some View {
        
        ZStack {
            if viewModel.isRefreshing {
                ProgressView()
            } else {
                NavigationView {
                    List{
                        ForEach(viewModel.users, id: \.id) { user in
                            UserInfoView(name: user.name)
                                .background(
                                    NavigationLink("", destination: UserDetailView(user: user))
                                        .opacity(0)
                                )
                        }
                        .listRowSeparator(.hidden)
                    }
                    .listStyle(.plain)
                    .navigationTitle("Users")
                }
            }
        }
        .task {
            await execute()
        }
        .alert(isPresented: $hasError,
               error: error) {
            Button {
                Task {
                    await execute()
                }
            } label: {
                Text("Retry")
            }
        }
    }
}

private extension HomeUserListView {
    func execute() async {
        do {
            try await viewModel.fetchUsers()
        } catch {
            if let userError = error as? UsersViewModel.UserError {
                self.hasError = true
                self.error = userError
            }
        }
    }
}
