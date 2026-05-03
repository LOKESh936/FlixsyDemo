import AVFoundation
import Combine

final class PlayerLooper: ObservableObject {
    let player: AVQueuePlayer
    private var looper: AVPlayerLooper?

    /// Loads a video by its bundle resource name (no extension). Falls back
    /// gracefully — player simply won't play if the file isn't in the bundle yet.
    init(videoName: String) {
        let url = Bundle.main.url(forResource: videoName, withExtension: "mp4")
        player = AVQueuePlayer()
        if let url {
            let item = AVPlayerItem(url: url)
            looper = AVPlayerLooper(player: player, templateItem: item)
        }
    }

    func play()  { player.play() }
    func pause() { player.pause() }
}
