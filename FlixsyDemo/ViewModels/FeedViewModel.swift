import Foundation

@MainActor
final class FeedViewModel: ObservableObject {

    // MARK: - Published state

    @Published private(set) var videos: [VideoPost] = []
    @Published private(set) var isLoading = false
    @Published private(set) var errorMessage: String?
    @Published var selectedVideo: VideoPost?  // non-nil = comments sheet open
    @Published var currentIndex = 0

    // MARK: - Dependencies

    private let service: FeedServiceProtocol

    init(service: FeedServiceProtocol = MockFeedService()) {
        self.service = service
    }

    // MARK: - Feed

    func loadVideos() async {
        guard !isLoading else { return }
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            videos = try await service.fetchVideos()
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    // MARK: - Like

    /// Instantly flips the like state in the local array (optimistic), then
    /// confirms with the service. Rolls back if the call fails.
    func toggleLike(for video: VideoPost) {
        guard let index = videos.firstIndex(where: { $0.id == video.id }) else { return }

        let wasLiked  = videos[index].isLiked
        let prevCount = videos[index].likeCount

        // Optimistic update — keep likeCount ≥ 0
        videos[index].isLiked  = !wasLiked
        videos[index].likeCount = max(0, prevCount + (wasLiked ? -1 : 1))

        Task {
            do {
                let confirmed = try await service.toggleLike(videoId: video.id, isLiked: !wasLiked)
                // Sync with server-confirmed value (handles edge cases like double-tap race)
                videos[index].isLiked = confirmed
            } catch {
                // Network failed — rollback both fields
                videos[index].isLiked   = wasLiked
                videos[index].likeCount = prevCount
            }
        }
    }

    // MARK: - Comments

    /// Sets `selectedVideo` to open the comments sheet for the given video.
    func openComments(for video: VideoPost) {
        selectedVideo = video
    }

    /// Clears `selectedVideo` to dismiss the comments sheet.
    func closeComments() {
        selectedVideo = nil
    }
}
