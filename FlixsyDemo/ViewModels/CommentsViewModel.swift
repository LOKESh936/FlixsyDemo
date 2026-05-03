import Foundation
import Combine

@MainActor
final class CommentsViewModel: ObservableObject {

    // MARK: - Published state

    @Published private(set) var comments: [Comment] = []
    @Published private(set) var isLoading = false
    @Published private(set) var errorMessage: String?
    @Published var inputText = ""

    // MARK: - Dependencies

    private let video: VideoPost
    private let service: FeedServiceProtocol

    init(video: VideoPost, service: FeedServiceProtocol = MockFeedService()) {
        self.video = video
        self.service = service
    }

    // MARK: - Load

    func loadComments() async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            comments = try await service.fetchComments(videoId: video.id)
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    // MARK: - Add comment

    func addComment() async {
        let text = inputText.trimmingCharacters(in: .whitespaces)
        guard !text.isEmpty else { return }

        // Optimistic insert — show comment immediately before the network call
        let optimistic = Comment(
            id: UUID().uuidString,
            videoId: video.id,
            username: "@you",
            text: text,
            createdAt: Date()
        )
        comments.insert(optimistic, at: 0)
        inputText = ""

        do {
            let confirmed = try await service.addComment(videoId: video.id, text: text)
            // Replace the placeholder with the server-confirmed comment
            if let index = comments.firstIndex(where: { $0.id == optimistic.id }) {
                comments[index] = confirmed
            }
        } catch {
            // Rollback on failure — remove the optimistic comment
            comments.removeAll { $0.id == optimistic.id }
            inputText = text
            errorMessage = error.localizedDescription
        }
    }
}
