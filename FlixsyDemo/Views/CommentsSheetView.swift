import SwiftUI

struct CommentsSheetView: View {
    @StateObject private var viewModel: CommentsViewModel
    @FocusState private var isInputFocused: Bool

    init(postID: String) {
        _viewModel = StateObject(wrappedValue: CommentsViewModel(postID: postID))
    }

    var body: some View {
        VStack(spacing: 0) {
            sheetHeader
            Divider()
            commentList
            Divider()
            commentInput
        }
        .task { await viewModel.loadComments() }
    }

    // MARK: - Subviews

    private var sheetHeader: some View {
        HStack {
            Text("Comments")
                .font(.headline)
            Spacer()
            if !viewModel.comments.isEmpty {
                Text("\(viewModel.comments.count)")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 12)
    }

    @ViewBuilder
    private var commentList: some View {
        if viewModel.isLoading {
            ProgressView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else if viewModel.comments.isEmpty {
            Text("No comments yet. Be first!")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else {
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 18) {
                    ForEach(viewModel.comments) { comment in
                        CommentRowView(comment: comment)
                    }
                }
                .padding()
            }
        }
    }

    private var commentInput: some View {
        HStack(spacing: 10) {
            TextField("Add a comment…", text: $viewModel.newCommentText)
                .textFieldStyle(.roundedBorder)
                .focused($isInputFocused)
                .submitLabel(.send)
                .onSubmit { viewModel.submitComment() }

            Button(action: viewModel.submitComment) {
                Image(systemName: "paperplane.fill")
                    .font(.system(size: 18))
                    .foregroundStyle(viewModel.newCommentText.isEmpty ? .gray : .blue)
            }
            .disabled(viewModel.newCommentText.isEmpty)
        }
        .padding()
    }
}

// MARK: - Comment Row

private struct CommentRowView: View {
    let comment: Comment

    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            avatarCircle
            VStack(alignment: .leading, spacing: 3) {
                HStack {
                    Text(comment.username)
                        .font(.caption.weight(.semibold))
                    Spacer()
                    Text(comment.timeAgo)
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
                Text(comment.text)
                    .font(.subheadline)
            }
        }
    }

    private var avatarCircle: some View {
        Circle()
            .fill(Color.gray.opacity(0.3))
            .frame(width: 38, height: 38)
            .overlay(
                Text(String(comment.username.dropFirst().prefix(2)).uppercased())
                    .font(.caption2.weight(.bold))
                    .foregroundStyle(.white)
            )
    }
}
