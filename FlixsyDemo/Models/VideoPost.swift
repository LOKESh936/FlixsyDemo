import Foundation

struct VideoPost: Identifiable, Equatable {
    let id: String
    let videoURL: URL
    let username: String
    let description: String
    var likeCount: Int
    let commentCount: Int
    var isLiked: Bool

    static func == (lhs: VideoPost, rhs: VideoPost) -> Bool {
        lhs.id == rhs.id
    }
}
