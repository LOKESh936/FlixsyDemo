import SwiftUI

struct FeedView: View {
    @StateObject private var viewModel = FeedViewModel()

    // Capture screen size once; avoids deprecated UIScreen.main inside view body
    private let screen = UIScreen.main.bounds.size

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            if viewModel.isLoading {
                ProgressView()
                    .tint(.white)
                    .scaleEffect(1.4)
            } else if let error = viewModel.errorMessage, viewModel.posts.isEmpty {
                errorView(message: error)
            } else {
                verticalFeed
            }
        }
        .ignoresSafeArea()
        .task { await viewModel.loadVideos() }
    }

    // MARK: - Vertical paging feed
    //
    // SwiftUI TabView pages horizontally. We rotate the TabView 90° CCW and
    // counter-rotate each cell 90° CW so content stays upright — giving us
    // native vertical paging with momentum and rubber-banding on iOS 16+.

    private var verticalFeed: some View {
        TabView(selection: $viewModel.currentIndex) {
            ForEach(Array(viewModel.posts.enumerated()), id: \.element.id) { index, post in
                VideoFeedCellView(
                    post: viewModel.posts[index],
                    isVisible: viewModel.currentIndex == index,
                    onLike: { viewModel.toggleLike(for: post) }
                )
                .rotationEffect(.degrees(-90))
                .frame(width: screen.width, height: screen.height)
                .tag(index)
            }
        }
        .frame(width: screen.height, height: screen.width)
        .rotationEffect(.degrees(90), anchor: .topLeading)
        .offset(x: screen.width)
        .tabViewStyle(.page(indexDisplayMode: .never))
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
