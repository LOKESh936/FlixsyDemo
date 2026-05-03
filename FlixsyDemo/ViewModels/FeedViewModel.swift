import Foundation
import Combine

// MARK: - Feed state

enum FeedState {
    case idle
    case loading
    case loaded
    case failed(String)
}

// MARK: - FeedViewModel

@MainActor
final class FeedViewModel: ObservableObject {

    // MARK: - Published state

    @Published private(set) var state: FeedState = .idle
    @Published private(set) var videos: [VideoPost] = []
    @Published var selectedVideo: VideoPost?   // non-nil = comments sheet open
    @Published var currentVideoId: String?     // bound to scrollPosition

    // MARK: - Dependencies

    private let service: FeedServiceProtocol

    init(service: FeedServiceProtocol = MockFeedService()) {
        self.service = service
    }

    // MARK: - Feed

    func retryLoad() async {
        state = .idle
        await loadVideos()
    }

    func loadVideos() async {
        guard case .idle = state else { return }
        state = .loading

        do {
            videos = try await service.fetchVideos()
            currentVideoId = videos.first?.id
            state = .loaded
        } catch {
            state = .failed(error.localizedDescription)
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

    // MARK: - Helpers

    /// Returns the live version of a video from the array so cells always
    /// reflect the latest like/comment state after an optimistic update.
    func currentVersion(of video: VideoPost) -> VideoPost {
        videos.first(where: { $0.id == video.id }) ?? video
    }
}
