import SwiftUI
import AVFoundation

struct VideoPlayerView: UIViewRepresentable {
    let player: AVQueuePlayer

    func makeUIView(context: Context) -> PlayerUIView {
        let view = PlayerUIView()
        view.setPlayer(player)
        return view
    }

    func updateUIView(_ uiView: PlayerUIView, context: Context) {}
}

// UIView subclass that uses AVPlayerLayer as its backing layer
final class PlayerUIView: UIView {
    override class var layerClass: AnyClass { AVPlayerLayer.self }

    private var playerLayer: AVPlayerLayer { layer as! AVPlayerLayer }

    func setPlayer(_ player: AVPlayer) {
        playerLayer.player = player
        playerLayer.videoGravity = .resizeAspectFill
        backgroundColor = .black
    }
}
