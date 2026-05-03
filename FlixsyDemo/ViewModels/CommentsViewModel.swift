import Foundation

@MainActor
final class CommentsViewModel: ObservableObject {
    @Published var comments: [Comment] = []
    @Published var isLoading = false
    @Published var newCommentText = ""

    private let postID: String
    private let service: FeedServiceProtocol

    init(postID: String, service: FeedServiceProtocol = MockFeedService()) {
        self.postID = postID
        self.service = service
    }

    func loadComments() async {
        isLoading = true
        defer { isLoading = false }
        do {
            comments = try await service.fetchComments(for: postID)
        } catch {
            // no-op for demo
        }
    }

    func submitComment() {
        let text = newCommentText.trimmingCharacters(in: .whitespaces)
        guard !text.isEmpty else { return }
        let new = Comment(id: UUID().uuidString, username: "@you", text: text, timestamp: Date())
        comments.insert(new, at: 0)
        newCommentText = ""
    }
}
