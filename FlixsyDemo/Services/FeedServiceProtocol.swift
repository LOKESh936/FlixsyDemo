import Foundation

protocol FeedServiceProtocol {
    func fetchFeed() async throws -> [VideoPost]
    func fetchComments(for postID: String) async throws -> [Comment]
    func likePost(id: String) async throws
    func unlikePost(id: String) async throws
}
