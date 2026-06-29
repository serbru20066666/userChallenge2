//
//  Validator.swift
//  UsuariosTest
//
//  Created by: Bruno Cardenas.
//

import Foundation

enum ValidationRule {
    case required(String)
    case email(String)
    case phone(String)
}

struct Validator {
    static func firstError(_ value: String, rules: [ValidationRule]) -> String? {
        let trimmed = value.trimmingCharacters(in: .whitespacesAndNewlines)
        for rule in rules {
            switch rule {
            case .required(let message) where trimmed.isEmpty:
                return message
            case .email(let message) where !trimmed.isEmpty && !trimmed.containsEmailShape:
                return message
            case .phone(let message) where !trimmed.isEmpty && trimmed.filter(\.isNumber).count < 7:
                return message
            default:
                continue
            }
        }
        return nil
    }
}

private extension String {
    var containsEmailShape: Bool {
        range(of: #"^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}$"#, options: [.regularExpression, .caseInsensitive]) != nil
    }
}
