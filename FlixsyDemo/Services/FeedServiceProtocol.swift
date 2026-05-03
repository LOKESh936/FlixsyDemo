import Foundation

protocol FeedServiceProtocol {
    /// Fetch the paginated video feed.
    func fetchVideos() async throws -> [VideoPost]

    /// Toggle like state server-side. Returns the confirmed `isLiked` value.
    func toggleLike(videoId: String, isLiked: Bool) async throws -> Bool

    /// Fetch all comments for a given video.
    func fetchComments(videoId: String) async throws -> [Comment]

    /// Post a new comment and return the persisted `Comment` from the server.
    func addComment(videoId: String, text: String) async throws -> Comment
}
