//
//  UserDetailView.swift
//  UsuariosTest
//
//  Created by: Bruno Cardenas.
//

import SwiftUI

struct UserDetailView: View {
    @StateObject var viewModel: UserDetailViewModel

    var body: some View {
        ScrollView {
            VStack(spacing: 18) {
                Image(systemName: "person.crop.circle.fill")
                    .font(.system(size: 110))
                    .foregroundStyle(.orange)
                VStack(alignment: .leading, spacing: 12) {
                    FormFieldView(title: "field_name", text: $viewModel.name)
                    FormFieldView(title: "field_email", text: $viewModel.email, keyboard: .emailAddress)
                    info("person.text.rectangle", viewModel.user.username)
                    info("phone", viewModel.user.phone)
                    info("mappin.and.ellipse", viewModel.user.city)
                    if let lat = viewModel.user.latitude, let lng = viewModel.user.longitude {
                        info("location", "\(lat), \(lng)")
                    }
                }
                PrimaryButton(title: "save_changes", systemImage: "checkmark", isLoading: viewModel.isLoading) {
                    Task { await viewModel.save() }
                }
            }
            .padding()
        }
        .navigationTitle("detail_title")
        .task { await viewModel.load() }
        .alert("app_message", isPresented: .constant(viewModel.message != nil)) {
            Button("ok") { viewModel.message = nil }
        } message: {
            Text(viewModel.message ?? "")
        }
    }

    private func info(_ icon: String, _ text: String) -> some View {
        Label(text.isEmpty ? "-" : text, systemImage: icon)
            .frame(maxWidth: .infinity, alignment: .leading)
            .foregroundStyle(.secondary)
    }
}
