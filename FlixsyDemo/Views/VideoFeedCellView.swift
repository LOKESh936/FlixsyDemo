import SwiftUI

struct VideoFeedCellView: View {
    let post: VideoPost
    let isVisible: Bool
    let onLike: () -> Void

    @StateObject private var looper: PlayerLooper
    @State private var showComments = false

    init(post: VideoPost, isVisible: Bool, onLike: @escaping () -> Void) {
        self.post = post
        self.isVisible = isVisible
        self.onLike = onLike
        _looper = StateObject(wrappedValue: PlayerLooper(url: post.videoURL))
    }

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VideoPlayerView(player: looper.player)
                .ignoresSafeArea()

            // Bottom fade for readability
            LinearGradient(
                colors: [.clear, .clear, .black.opacity(0.7)],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack {
                Spacer()
                HStack(alignment: .bottom, spacing: 0) {
                    postInfo
                    Spacer(minLength: 12)
                    FeedActionButtonsView(
                        post: post,
                        onLike: onLike,
                        onComment: { showComments = true }
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
        .onAppear { if isVisible { looper.play() } }
        .onDisappear { looper.pause() }
        .sheet(isPresented: $showComments) {
            CommentsSheetView(postID: post.id)
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.visible)
        }
    }

    private var postInfo: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(post.username)
                .font(.headline.weight(.bold))
                .foregroundStyle(.white)
            Text(post.description)
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.9))
                .lineLimit(2)
                .multilineTextAlignment(.leading)
        }
        .shadow(color: .black.opacity(0.5), radius: 4)
        .padding(.bottom, 4)
    }
}
