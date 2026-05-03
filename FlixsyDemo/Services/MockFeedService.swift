import Foundation

final class MockFeedService: FeedServiceProtocol {

    func fetchFeed() async throws -> [VideoPost] {
        try await Task.sleep(nanoseconds: 600_000_000)
        return MockData.videos
    }

    func fetchComments(for postID: String) async throws -> [Comment] {
        try await Task.sleep(nanoseconds: 300_000_000)
        return MockData.comments[postID] ?? []
    }

    func likePost(id: String) async throws {
        try await Task.sleep(nanoseconds: 100_000_000)
    }

    func unlikePost(id: String) async throws {
        try await Task.sleep(nanoseconds: 100_000_000)
    }
}
