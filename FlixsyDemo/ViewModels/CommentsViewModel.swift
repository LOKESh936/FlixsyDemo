import Foundation
import Combine

@MainActor
final class CommentsViewModel: ObservableObject {
    @Published var comments: [Comment] = []
    @Published var isLoading = false
    @Published var isSubmitting = false
    @Published var newCommentText = ""

    private let videoId: String
    private let service: FeedServiceProtocol

    init(videoId: String, service: FeedServiceProtocol = MockFeedService()) {
        self.videoId = videoId
        self.service = service
    }

    func loadComments() async {
        isLoading = true
        defer { isLoading = false }
        do {
            comments = try await service.fetchComments(videoId: videoId)
        } catch {
            // no-op for demo
        }
    }

    func submitComment() {
        let text = newCommentText.trimmingCharacters(in: .whitespaces)
        guard !text.isEmpty, !isSubmitting else { return }
        newCommentText = ""
        isSubmitting = true

        Task {
            defer { isSubmitting = false }
            do {
                let comment = try await service.addComment(videoId: videoId, text: text)
                comments.insert(comment, at: 0)
            } catch {
                // no-op for demo
            }
        }
    }
}
