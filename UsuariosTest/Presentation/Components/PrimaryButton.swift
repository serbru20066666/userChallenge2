//
//  PrimaryButton.swift
//  UsuariosTest
//
//  Created by: Bruno Cardenas.
//

import SwiftUI

struct PrimaryButton: View {
    let title: LocalizedStringKey
    let systemImage: String
    let isLoading: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                if isLoading { ProgressView().tint(.white) }
                Image(systemName: systemImage)
                Text(title).fontWeight(.semibold)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(.orange, in: RoundedRectangle(cornerRadius: 8))
            .foregroundStyle(.white)
        }
        .disabled(isLoading)
    }
}
