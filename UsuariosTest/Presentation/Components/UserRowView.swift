//
//  UserRowView.swift
//  UsuariosTest
//
//  Created by: Bruno Cardenas.
//

import SwiftUI

struct UserRowView: View {
    let user: User

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "person.crop.circle.fill")
                .font(.system(size: 42))
                .foregroundStyle(.orange)
            VStack(alignment: .leading, spacing: 4) {
                Text(user.name).font(.headline)
                Text("@\(user.username) • \(user.city)").font(.subheadline).foregroundStyle(.secondary)
                Text(user.email).font(.caption).foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 6)
    }
}
