import SwiftUI

enum DecksyTheme {
    static let midnight = Color(red: 0.118, green: 0.102, blue: 0.184) // #1E1A2F
    static let navy = Color(red: 0.169, green: 0.145, blue: 0.263) // #2B2543
    static let violet = Color(red: 0.486, green: 0.302, blue: 1.000) // #7C4DFF
    static let electricBlue = Color(red: 0.278, green: 0.431, blue: 1.000) // #476EFF
    static let lavender = Color(red: 0.686, green: 0.596, blue: 1.000) // #AF98FF
    static let graphite = Color(red: 0.416, green: 0.435, blue: 0.553) // #6A6F8D
    static let textOnDark = Color(red: 0.953, green: 0.941, blue: 1.000) // #F3F0FF
    static let textOnCard = Color(red: 0.094, green: 0.078, blue: 0.145) // #181425
    static let subtleText = Color(red: 0.680, green: 0.655, blue: 0.800) // #ADA7CC

    static let background = midnight
    static let card = Color(red: 0.985, green: 0.984, blue: 0.992)

    static let deepTeal = textOnCard
    static let teal = violet
    static let slateGreen = subtleText
    static let olive = lavender
    static let leaf = electricBlue
}

extension View {
    func decksyNavigationChrome() -> some View {
        self
            .toolbarBackground(DecksyTheme.background, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
    }
}
