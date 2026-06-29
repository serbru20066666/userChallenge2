//
//  FormFieldView.swift
//  UsuariosTest
//
//  Created by: Bruno Cardenas.
//

import SwiftUI

struct FormFieldView: View {
    let title: LocalizedStringKey
    @Binding var text: String
    var keyboard: UIKeyboardType = .default
    var error: String?

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title).font(.caption).foregroundStyle(.secondary)
            TextField(title, text: $text)
                .textInputAutocapitalization(keyboard == .emailAddress ? .never : .words)
                .keyboardType(keyboard)
                .autocorrectionDisabled(keyboard == .emailAddress)
                .padding(12)
                .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 8))
            if let error { Text(error).font(.caption).foregroundStyle(.red) }
        }
    }
}
