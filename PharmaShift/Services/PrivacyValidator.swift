import Foundation

enum PrivacyValidator {
    static func containsObviousIdentifier(_ text: String) -> Bool {
        let email = #"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}"#
        let phone = #"(?<!\d)(?:\+?964|0)?7\d{9}(?!\d)"#
        return text.range(of: email, options: .regularExpression) != nil
            || text.range(of: phone, options: .regularExpression) != nil
    }
}
