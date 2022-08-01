//
//  UserInfoView.swift
//  API-JSON-with-URLSession
//
//  Created by Byron Mejia on 8/1/22.
//

import SwiftUI

struct UserInfoView: View {
    let name: String

    var body: some View {
        VStack {
            Text(name)
                .bold()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(.gray.opacity(0.1),
                    in: RoundedRectangle(cornerRadius: 10, style: .continuous))
    }
}
