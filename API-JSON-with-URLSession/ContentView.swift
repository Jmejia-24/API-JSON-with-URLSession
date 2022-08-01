//
//  ContentView.swift
//  API-JSON-with-URLSession
//
//  Created by Byron Mejia on 7/31/22.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = UsersViewModel()
    
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
            .onAppear(perform: viewModel.fetchUsers)
            .alert(isPresented: $viewModel.hasError, error: viewModel.error) {
                Button(action: viewModel.fetchUsers) {
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
