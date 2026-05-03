import SwiftUI

/// App entry point.
/// FeedView is the root — no navigation stack needed for a single-feed demo.
/// Dark color scheme is locked so the video feed always looks correct.
@main
struct FlixsyDemoApp: App {
    var body: some Scene {
        WindowGroup {
            FeedView()
                .preferredColorScheme(.dark)
        }
    }
}
