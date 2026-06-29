//
//  UserFormView.swift
//  UsuariosTest
//
//  Created by: Bruno Cardenas.
//

import SwiftUI

struct UserFormView: View {
    @StateObject var viewModel: UserFormViewModel
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                FormFieldView(title: "field_name", text: $viewModel.name)
                FormFieldView(title: "field_email", text: $viewModel.email, keyboard: .emailAddress)
                FormFieldView(title: "field_phone", text: $viewModel.phone, keyboard: .phonePad)

                Button { Task { await viewModel.obtainLocation() } } label: {
                    Label("get_location", systemImage: "location.fill")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 8))
                }

                if let coordinate = viewModel.coordinate {
                    Label("\(coordinate.latitude), \(coordinate.longitude)", systemImage: "mappin.circle")
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }

                PrimaryButton(title: "create_user", systemImage: "person.badge.plus", isLoading: viewModel.isLoading) {
                    Task { await viewModel.save() }
                }
            }
            .padding()
        }
        .navigationTitle("create_title")
        .onChange(of: viewModel.didSave) { saved in
            if saved { dismiss() }
        }
        .alert("app_message", isPresented: .constant(viewModel.message != nil)) {
            Button("ok") { viewModel.message = nil }
        } message: {
            Text(viewModel.message ?? "")
        }
    }
}
