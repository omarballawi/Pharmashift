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
}
