import SwiftUI

@main
struct DecksyApp: App {
    @StateObject private var store = CardStore()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(store)
                .tint(DecksyTheme.teal)
                .preferredColorScheme(.light)
        }
    }
}
