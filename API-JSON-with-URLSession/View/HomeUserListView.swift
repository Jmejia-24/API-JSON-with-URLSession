//
//  ContentView.swift
//  API-JSON-with-URLSession
//
//  Created by Byron Mejia on 7/31/22.
//

import SwiftUI

struct HomeUserListView: View {
    @StateObject private var viewModel = UsersViewModel()
    
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
            await viewModel.execute()
        }
        .alert(isPresented: $viewModel.hasError,
               error: viewModel.error) {
            Button {
                Task {
                    await viewModel.execute()
                }
            } label: {
                Text("Retry")
            }
        }
    }
}
