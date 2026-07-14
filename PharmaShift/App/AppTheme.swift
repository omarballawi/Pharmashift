import Observation
import SwiftUI

@MainActor
@Observable
final class AppTheme {
    let tint = Color(red: 0.02, green: 0.48, blue: 0.43)
    let softTint = Color(red: 0.88, green: 0.96, blue: 0.94)
    let background = Color(uiColor: .systemGroupedBackground)
    let card = Color(uiColor: .secondarySystemGroupedBackground)
    let warning = Color.red
    let crystalCyan = Color(red: 0.30, green: 0.91, blue: 0.90)
    let crystalViolet = Color(red: 0.51, green: 0.30, blue: 0.95)
    let crystalInk = Color(red: 0.035, green: 0.055, blue: 0.095)

    var crystalGradient: LinearGradient {
        LinearGradient(
            colors: [
                Color(red: 0.04, green: 0.30, blue: 0.34),
                Color(red: 0.20, green: 0.13, blue: 0.43),
                crystalInk
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    func colors(for chapter: Chapter) -> [Color] {
        switch chapter {
        case .cardiovascular: [Color(red: 0.96, green: 0.28, blue: 0.36), Color(red: 0.72, green: 0.08, blue: 0.23)]
        case .respiratory: [Color(red: 0.14, green: 0.70, blue: 0.76), Color(red: 0.03, green: 0.42, blue: 0.60)]
        case .endocrine: [Color(red: 0.65, green: 0.40, blue: 0.94), Color(red: 0.39, green: 0.20, blue: 0.72)]
        case .musculoskeletal: [Color(red: 0.96, green: 0.58, blue: 0.20), Color(red: 0.82, green: 0.30, blue: 0.11)]
        case .eye: [Color(red: 0.22, green: 0.58, blue: 0.96), Color(red: 0.13, green: 0.32, blue: 0.78)]
        case .earNoseOropharynx: [Color(red: 0.91, green: 0.42, blue: 0.67), Color(red: 0.65, green: 0.18, blue: 0.47)]
        case .gastrointestinal: [Color(red: 0.22, green: 0.68, blue: 0.45), Color(red: 0.04, green: 0.42, blue: 0.28)]
        case .dermatology: [Color(red: 0.94, green: 0.55, blue: 0.47), Color(red: 0.72, green: 0.28, blue: 0.24)]
        case .antibiotics: [Color(red: 0.17, green: 0.55, blue: 0.55), Color(red: 0.03, green: 0.34, blue: 0.38)]
        case .otc: [Color(red: 0.95, green: 0.70, blue: 0.18), Color(red: 0.83, green: 0.45, blue: 0.05)]
        case .vitaminsSupplements: [Color(red: 0.47, green: 0.72, blue: 0.22), Color(red: 0.20, green: 0.50, blue: 0.12)]
        case .other: [Color(red: 0.45, green: 0.48, blue: 0.58), Color(red: 0.25, green: 0.28, blue: 0.38)]
        }
    }
}
