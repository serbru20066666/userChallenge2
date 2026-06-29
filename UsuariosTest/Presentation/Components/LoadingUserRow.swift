//
//  LoadingUserRow.swift
//  UsuariosTest
//
//  Created by: Bruno Cardenas.
//

import Shimmer
import SwiftUI

struct LoadingUserRow: View {
    var body: some View {
        HStack(spacing: 12) {
            Circle().fill(.gray.opacity(0.18)).frame(width: 44, height: 44)
            VStack(alignment: .leading, spacing: 8) {
                Capsule().fill(.gray.opacity(0.18)).frame(width: 170, height: 14)
                Capsule().fill(.gray.opacity(0.18)).frame(width: 240, height: 12)
            }
        }
        .padding(.vertical, 6)
        .shimmering()
    }
}
