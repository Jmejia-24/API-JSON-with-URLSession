//
//  ContentView.swift
//  API-JSON-with-URLSession
//
//  Created by Byron Mejia on 7/31/22.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = UsersViewModel()
    @State private var error: UsersViewModel.UserError?
    @State private var hasError = false
    
    var body: some View {
        NavigationView {
            ZStack {
                if viewModel.isRefreshing {
                    ProgressView()
                } else {
                    List{
                        ForEach(viewModel.users, id: \.id) { user in
                            UserView(user: user)
                                .listRowSeparator(.hidden)
                        }
                    }
                    .listStyle(.plain)
                    .navigationTitle("Users")
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
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

private extension ContentView {
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
