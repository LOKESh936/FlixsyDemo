import SwiftUI

struct FeedView: View {
    @StateObject private var viewModel = FeedViewModel()

    var body: some View {
        GeometryReader { geo in
            ZStack {
                Color.black.ignoresSafeArea()

                if viewModel.isLoading {
                    ProgressView()
                        .tint(.white)
                        .scaleEffect(1.4)
                } else if let error = viewModel.errorMessage, viewModel.videos.isEmpty {
                    errorView(message: error)
                } else {
                    verticalFeed(size: geo.size)
                }
            }
        }
        .ignoresSafeArea()
        .task { await viewModel.loadVideos() }
        .sheet(item: $viewModel.selectedVideo) { video in
            CommentsSheetView(videoId: video.id)
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.visible)
        }
    }

    // MARK: - Vertical paging feed
    //
    // Uses ScrollView + scrollTargetBehavior(.paging) — the native iOS 17+
    // vertical pager. No rotation hack, no UIScreen.main, works on iOS 26.

    private func verticalFeed(size: CGSize) -> some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVStack(spacing: 0) {
                ForEach(viewModel.videos) { video in
                    VideoFeedCellView(
                        video: viewModel.videos[videoIndex(video)],
                        isVisible: viewModel.currentVideoId == video.id,
                        onLike: { viewModel.toggleLike(for: video) },
                        onComment: { viewModel.openComments(for: video) }
                    )
                    .frame(width: size.width, height: size.height)
                    .id(video.id)
                }
            }
            .scrollTargetLayout()
        }
        .scrollTargetBehavior(.paging)
        .scrollPosition(id: $viewModel.currentVideoId)
        .ignoresSafeArea()
    }

    // MARK: - Helpers

    /// Returns the current index of a video in the array so the cell always
    /// reads the latest like/comment state after an optimistic update.
    private func videoIndex(_ video: VideoPost) -> Int {
        viewModel.videos.firstIndex(where: { $0.id == video.id }) ?? 0
    }

    // MARK: - Error state

    private func errorView(message: String) -> some View {
        VStack(spacing: 16) {
            Image(systemName: "wifi.exclamationmark")
                .font(.system(size: 52))
                .foregroundStyle(.white.opacity(0.6))
            Text(message)
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.8))
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            Button("Try Again") {
                Task { await viewModel.loadVideos() }
            }
            .buttonStyle(.bordered)
            .tint(.white)
        }
    }
}
