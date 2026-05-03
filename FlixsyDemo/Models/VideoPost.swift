import Foundation

struct VideoPost: Identifiable, Equatable {
    let id: String
    let videoName: String           // bundle resource name — e.g. "sample1" (no extension)
    let username: String            // @handle shown in feed
    let userDisplayName: String     // full display name shown on profile row
    let caption: String
    let audioTitle: String
    var likeCount: Int
    var commentCount: Int
    var isLiked: Bool

    static func == (lhs: VideoPost, rhs: VideoPost) -> Bool {
        lhs.id == rhs.id
    }
}
