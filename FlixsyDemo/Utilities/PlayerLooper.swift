import AVFoundation

final class PlayerLooper: ObservableObject {
    let player: AVQueuePlayer
    private var looper: AVPlayerLooper?

    init(url: URL) {
        let item = AVPlayerItem(url: url)
        player = AVQueuePlayer()
        looper = AVPlayerLooper(player: player, templateItem: item)
    }

    func play() { player.play() }
    func pause() { player.pause() }
}
