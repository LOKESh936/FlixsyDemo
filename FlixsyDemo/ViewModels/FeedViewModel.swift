import Foundation
import Combine

@MainActor
final class FeedViewModel: ObservableObject {

    // MARK: - Published state

    @Published private(set) var videos: [VideoPost] = []
    @Published private(set) var isLoading = false
    @Published private(set) var errorMessage: String?
    @Published var selectedVideo: VideoPost?   // non-nil = comments sheet open
    @Published var currentVideoId: String?     // tracks which cell is visible; bound to scrollPosition

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
            // Auto-select first video so play/pause fires correctly on launch
            currentVideoId = videos.first?.id
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    // MARK: - Like

    /// Instantly flips the like state in the local array (optimistic), then
    /// confirms with the service. Rolls back both fields if the call fails.
    func toggleLike(for video: VideoPost) {
        guard let index = videos.firstIndex(where: { $0.id == video.id }) else { return }

        let wasLiked  = videos[index].isLiked
        let prevCount = videos[index].likeCount

        // Optimistic update — keep likeCount ≥ 0
        videos[index].isLiked   = !wasLiked
        videos[index].likeCount = max(0, prevCount + (wasLiked ? -1 : 1))

        Task {
            do {
                let confirmed = try await service.toggleLike(videoId: video.id, isLiked: !wasLiked)
                // Sync with server-confirmed value (guards against rapid double-tap race)
                videos[index].isLiked = confirmed
            } catch {
                // Network failed — restore exact snapshot
                videos[index].isLiked   = wasLiked
                videos[index].likeCount = prevCount
            }
        }
    }

    // MARK: - Comments

    func openComments(for video: VideoPost) {
        selectedVideo = video
    }

    func closeComments() {
        selectedVideo = nil
    }
}
