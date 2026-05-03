import SwiftUI
import AVFoundation

// MARK: - VideoPlayerView

/// Self-contained video player. Loads a bundled .mp4 by name, loops it,
/// plays/pauses based on `isVisible`, and shows a gradient placeholder when
/// the file is not yet in the bundle.
struct VideoPlayerView: View {
    let videoName: String
    let isVisible: Bool

    var body: some View {
        if let url = Bundle.main.url(forResource: videoName, withExtension: "mp4") {
            PlayerLayerView(url: url, isVisible: isVisible)
                .ignoresSafeArea()
        } else {
            placeholderView
        }
    }

    // MARK: - Placeholder

    private var placeholderView: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(hex: "#1C1C2E"),
                    Color(hex: "#2D1B4E"),
                    Color(hex: "#1A1A3E")
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 14) {
                Image(systemName: "play.circle.fill")
                    .font(.system(size: 56))
                    .foregroundStyle(.white.opacity(0.25))

                Text("Video Preview")
                    .font(.subheadline.weight(.medium))
                    .foregroundStyle(.white.opacity(0.35))
                    .tracking(0.5)
            }
        }
    }
}

// MARK: - PlayerLayerView (UIViewRepresentable)

/// Wraps AVQueuePlayer in a UIView whose backing layer is AVPlayerLayer.
/// The Coordinator owns the player and looper for the duration of the view's life.
private struct PlayerLayerView: UIViewRepresentable {
    let url: URL
    let isVisible: Bool

    // MARK: UIViewRepresentable

    func makeCoordinator() -> Coordinator {
        Coordinator(url: url)
    }

    func makeUIView(context: Context) -> PlayerUIView {
        let view = PlayerUIView()
        view.configure(with: context.coordinator.player)
        return view
    }

    func updateUIView(_ uiView: PlayerUIView, context: Context) {
        // Called on initial render and every time isVisible changes
        if isVisible {
            context.coordinator.player.play()
        } else {
            context.coordinator.player.pause()
        }
    }

    static func dismantleUIView(_ uiView: PlayerUIView, coordinator: Coordinator) {
        // Safety: stop playback when the view is removed from the hierarchy
        coordinator.player.pause()
    }

    // MARK: - Coordinator

    final class Coordinator: NSObject {
        let player: AVQueuePlayer
        private var looper: AVPlayerLooper?

        init(url: URL) {
            let item = AVPlayerItem(url: url)
            player   = AVQueuePlayer()
            player.isMuted = true          // muted by default for demo
            looper   = AVPlayerLooper(player: player, templateItem: item)
        }
    }
}

// MARK: - PlayerUIView

/// UIView subclass whose backing CALayer is AVPlayerLayer.
/// Using layerClass avoids an extra sublayer and keeps layout automatic.
private final class PlayerUIView: UIView {
    override class var layerClass: AnyClass { AVPlayerLayer.self }

    private var playerLayer: AVPlayerLayer { layer as! AVPlayerLayer }

    func configure(with player: AVPlayer) {
        playerLayer.player       = player
        playerLayer.videoGravity = .resizeAspectFill
        backgroundColor          = .black
    }
}

// MARK: - Color(hex:)

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let r = Double((int >> 16) & 0xFF) / 255
        let g = Double((int >> 8)  & 0xFF) / 255
        let b = Double(int         & 0xFF) / 255
        self.init(red: r, green: g, blue: b)
    }
}
