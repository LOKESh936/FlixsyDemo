import SwiftUI

struct FeedView: View {

    // MARK: - State

    @StateObject private var viewModel = FeedViewModel()

    // MARK: - Body

    var body: some View {
        GeometryReader { geo in
            ZStack {
                Color.black.ignoresSafeArea()

                switch viewModel.state {
                case .idle:
                    EmptyView()

                case .loading:
                    loadingView

                case .loaded:
                    feedView(size: geo.size)

                case .failed(let message):
                    errorView(message: message)
                }
            }
            .ignoresSafeArea()
        }
        .ignoresSafeArea()
        .task { await viewModel.loadVideos() }
        .sheet(item: $viewModel.selectedVideo) { video in
            CommentsSheetView(video: video)
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.visible)
        }
    }

    // MARK: - Feed

    private func feedView(size: CGSize) -> some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVStack(spacing: 0) {
                ForEach(viewModel.videos) { video in
                    VideoFeedCellView(
                        video: viewModel.currentVersion(of: video),
                        isVisible: viewModel.currentVideoId == video.id,
                        onLike:    { viewModel.toggleLike(for: video) },
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

    // MARK: - Loading

    private var loadingView: some View {
        ProgressView()
            .tint(.white)
            .scaleEffect(1.4)
    }

    // MARK: - Error

    private func errorView(message: String) -> some View {
        VStack(spacing: 16) {
            Image(systemName: "wifi.exclamationmark")
                .font(.system(size: 52))
                .foregroundStyle(.white.opacity(0.6))

            Text(message)
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.8))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)

            Button("Try Again") {
                Task { await viewModel.retryLoad() }
            }
            .buttonStyle(.bordered)
            .tint(.white)
        }
    }
}
