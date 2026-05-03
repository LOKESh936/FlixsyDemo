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
                    // Brief window before loadVideos() fires — stays black.
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
        // Sheet is driven by selectedVideo — set by openComments(for:) in the ViewModel.
        // presentationDragIndicator is hidden because CommentsSheetView draws its own handle.
        .sheet(item: $viewModel.selectedVideo) { video in
            CommentsSheetView(video: video)
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.hidden)
        }
    }

    // MARK: - Feed
    //
    // ScrollView + scrollTargetBehavior(.paging) gives native iOS 17+ vertical
    // paging — full-screen snap with momentum. Each cell is sized to fill
    // exactly the GeometryReader frame so paging lands on clean boundaries.

    private func feedView(size: CGSize) -> some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVStack(spacing: 0) {
                ForEach(viewModel.videos) { video in
                    VideoFeedCellView(
                        // currentVersion(of:) returns the live array entry so the cell
                        // always reflects the latest like/comment count after an update.
                        video:     viewModel.currentVersion(of: video),
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
        // Two-way binding: scroll changes currentVideoId, ViewModel changes can scroll to a position.
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
                // retryLoad() resets state to .idle then calls loadVideos().
                Task { await viewModel.retryLoad() }
            }
            .buttonStyle(.borderedProminent)
            .tint(Color(hex: "#FF315F"))
            .clipShape(Capsule())
        }
    }
}
