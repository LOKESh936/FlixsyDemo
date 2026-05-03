import Foundation

final class MockFeedService: FeedServiceProtocol {

    // In-memory store so added comments survive within a session
    private var commentStore: [String: [Comment]] = MockData.comments

    // MARK: - FeedServiceProtocol

    func fetchVideos() async throws -> [VideoPost] {
        try await delay(0.6)
        return MockData.videos
    }

    func toggleLike(videoId: String, isLiked: Bool) async throws -> Bool {
        try await delay(0.15)
        return isLiked
    }

    func fetchComments(videoId: String) async throws -> [Comment] {
        try await delay(0.4)
        return commentStore[videoId] ?? []
    }

    func addComment(videoId: String, text: String) async throws -> Comment {
        try await delay(0.3)
        let comment = Comment(
            id: UUID().uuidString,
            videoId: videoId,
            username: "@you",
            text: text,
            createdAt: Date()
        )
        commentStore[videoId, default: []].insert(comment, at: 0)
        return comment
    }

    // MARK: - Private

    private func delay(_ seconds: Double) async throws {
        try await Task.sleep(nanoseconds: UInt64(seconds * 1_000_000_000))
    }
}
