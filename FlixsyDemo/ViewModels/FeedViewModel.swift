import Foundation

@MainActor
final class FeedViewModel: ObservableObject {
    @Published var posts: [VideoPost] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var currentIndex = 0

    private let service: FeedServiceProtocol

    init(service: FeedServiceProtocol = MockFeedService()) {
        self.service = service
    }

    func loadVideos() async {
        isLoading = true
        defer { isLoading = false }
        do {
            posts = try await service.fetchVideos()
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func toggleLike(for post: VideoPost) {
        guard let index = posts.firstIndex(where: { $0.id == post.id }) else { return }
        let wasLiked = posts[index].isLiked
        // Optimistic update
        posts[index].isLiked.toggle()
        posts[index].likeCount += wasLiked ? -1 : 1

        Task {
            do {
                let confirmed = try await service.toggleLike(videoId: post.id, isLiked: !wasLiked)
                posts[index].isLiked = confirmed
            } catch {
                // Revert on failure
                posts[index].isLiked = wasLiked
                posts[index].likeCount += wasLiked ? 1 : -1
            }
        }
    }
}
