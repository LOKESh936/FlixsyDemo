import SwiftUI

@main
struct FlixsyDemoApp: App {
    var body: some Scene {
        WindowGroup {
            FeedView()
                .preferredColorScheme(.dark)
        }
    }
}
