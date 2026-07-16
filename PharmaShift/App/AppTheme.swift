import Observation
import SwiftUI

@MainActor
@Observable
final class AppTheme {
    let coral = Color(uiColor: UIColor { traits in
        traits.userInterfaceStyle == .dark
            ? UIColor(red: 0.85, green: 0.40, blue: 0.33, alpha: 1)
            : UIColor(red: 0.75, green: 0.27, blue: 0.20, alpha: 1)
    })
    let aqua = Color(uiColor: UIColor { traits in
        traits.userInterfaceStyle == .dark
            ? UIColor(red: 0.36, green: 0.66, blue: 0.65, alpha: 1)
            : UIColor(red: 0.09, green: 0.47, blue: 0.49, alpha: 1)
    })
    let ink = Color(uiColor: UIColor { traits in
        traits.userInterfaceStyle == .dark
            ? UIColor(red: 0.84, green: 0.89, blue: 0.94, alpha: 1)
            : UIColor(red: 0.08, green: 0.17, blue: 0.27, alpha: 1)
    })
    let inkSolid = Color(red: 0.08, green: 0.17, blue: 0.27)
    let saffron = Color(uiColor: UIColor { traits in
        traits.userInterfaceStyle == .dark
            ? UIColor(red: 0.95, green: 0.68, blue: 0.28, alpha: 1)
            : UIColor(red: 0.60, green: 0.36, blue: 0.05, alpha: 1)
    })

    let background = Color(uiColor: .systemGroupedBackground)
    let surface = Color(uiColor: .systemBackground)
    let card = Color(uiColor: .secondarySystemGroupedBackground)
    let raisedSurface = Color(uiColor: .tertiarySystemGroupedBackground)
    let separator = Color(uiColor: .separator)
    let warning = Color(uiColor: .systemRed)

    let primaryAction = Color(red: 0.75, green: 0.27, blue: 0.20)
    let secondaryAction = Color(red: 0.09, green: 0.47, blue: 0.49)

    var tint: Color { primaryAction }
    var softTint: Color { coral.opacity(0.11) }
    var softAqua: Color { aqua.opacity(0.12) }

    var orbitGradient: LinearGradient {
        LinearGradient(colors: [coral, aqua], startPoint: .topLeading, endPoint: .bottomTrailing)
    }

    func colors(for chapter: Chapter) -> [Color] {
        switch chapter {
        case .cardiovascular: [coral, Color.red]
        case .respiratory: [aqua, Color.cyan]
        case .endocrine: [Color.indigo, aqua]
        case .musculoskeletal: [Color.orange, saffron]
        case .eye: [Color.blue, aqua]
        case .earNoseOropharynx: [Color.pink, coral]
        case .gastrointestinal: [Color.green, aqua]
        case .dermatology: [coral, Color.orange]
        case .antibiotics: [aqua, Color.teal]
        case .otc: [saffron, Color.orange]
        case .vitaminsSupplements: [Color.green, saffron]
        case .other: [Color.secondary, ink]
        }
    }
}

enum RenlystLayout {
    static let pageInset: CGFloat = 18
    static let sectionSpacing: CGFloat = 24
    static let surfaceRadius: CGFloat = 16
    static let compactRadius: CGFloat = 12
    static let controlHeight: CGFloat = 48
}

enum RenlystMotion {
    static let press = Animation.easeOut(duration: 0.16)
    static let state = Animation.easeInOut(duration: 0.24)
    static let celebration = Animation.spring(response: 0.42, dampingFraction: 0.86)
}
