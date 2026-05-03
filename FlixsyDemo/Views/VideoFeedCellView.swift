import SwiftUI

struct VideoFeedCellView: View {
    let video: VideoPost
    let isVisible: Bool
    let onLike: () -> Void
    let onComment: () -> Void

    @StateObject private var looper: PlayerLooper

    init(video: VideoPost, isVisible: Bool, onLike: @escaping () -> Void, onComment: @escaping () -> Void) {
        self.video = video
        self.isVisible = isVisible
        self.onLike = onLike
        self.onComment = onComment
        _looper = StateObject(wrappedValue: PlayerLooper(videoName: video.videoName))
    }

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VideoPlayerView(player: looper.player)
                .ignoresSafeArea()

            LinearGradient(
                colors: [.clear, .clear, .black.opacity(0.7)],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack {
                Spacer()
                HStack(alignment: .bottom, spacing: 0) {
                    videoInfo
                    Spacer(minLength: 12)
                    FeedActionButtonsView(
                        video: video,
                        onLike: onLike,
                        onComment: onComment
                    )
                    .padding(.trailing, 12)
                    .padding(.bottom, 4)
                }
                .padding(.bottom, 28)
                .padding(.leading, 16)
            }
        }
        .onChange(of: isVisible) { visible in
            visible ? looper.play() : looper.pause()
        }
        .onAppear   { if isVisible { looper.play() } }
        .onDisappear { looper.pause() }
    }

    private var videoInfo: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(video.userDisplayName)
                .font(.headline.weight(.bold))
                .foregroundStyle(.white)
            Text(video.username)
                .font(.subheadline.weight(.medium))
                .foregroundStyle(.white.opacity(0.75))
            Text(video.caption)
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.9))
                .lineLimit(2)
                .multilineTextAlignment(.leading)
            Label(video.audioTitle, systemImage: "music.note")
                .font(.caption)
                .foregroundStyle(.white.opacity(0.8))
        }
        .shadow(color: .black.opacity(0.5), radius: 4)
        .padding(.bottom, 4)
    }
}
