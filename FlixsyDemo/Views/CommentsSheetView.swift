import SwiftUI

// MARK: - CommentsSheetView

struct CommentsSheetView: View {

    @StateObject private var viewModel: CommentsViewModel
    @FocusState  private var inputFocused: Bool
    @Environment(\.dismiss) private var dismiss

    init(video: VideoPost, service: FeedServiceProtocol = MockFeedService()) {
        _viewModel = StateObject(wrappedValue: CommentsViewModel(video: video, service: service))
    }

    // MARK: - Body

    var body: some View {
        VStack(spacing: 0) {
            dragHandle
            header
            Divider()
            commentList
        }
        // Input bar floats above the keyboard automatically
        .safeAreaInset(edge: .bottom, spacing: 0) {
            inputBar
        }
        .task { await viewModel.loadComments() }
    }

    // MARK: - Drag handle

    private var dragHandle: some View {
        RoundedRectangle(cornerRadius: 3)
            .fill(Color(.systemGray4))
            .frame(width: 36, height: 5)
            .padding(.top, 10)
            .padding(.bottom, 6)
    }

    // MARK: - Header

    private var header: some View {
        HStack(alignment: .center) {
            // Count badge
            if !viewModel.comments.isEmpty {
                Text("\(viewModel.comments.count) comments")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.secondary)
            } else {
                Text("Comments")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.secondary)
            }

            Spacer()

            // Close button
            Button {
                dismiss()
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .font(.title3)
                    .foregroundStyle(Color(.systemGray3))
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 12)
    }

    // MARK: - Comment list

    @ViewBuilder
    private var commentList: some View {
        if viewModel.isLoading {
            Spacer()
            ProgressView()
                .frame(maxWidth: .infinity)
            Spacer()
        } else if viewModel.comments.isEmpty {
            Spacer()
            emptyState
            Spacer()
        } else {
            ScrollViewReader { proxy in
                ScrollView(showsIndicators: false) {
                    LazyVStack(alignment: .leading, spacing: 0) {
                        ForEach(viewModel.comments) { comment in
                            CommentRow(comment: comment)
                                .id(comment.id)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                }
                .onChange(of: viewModel.comments.first?.id) { _, newId in
                    // Scroll to newest comment when it appears at the top
                    if let id = newId {
                        withAnimation(.easeOut(duration: 0.3)) {
                            proxy.scrollTo(id, anchor: .top)
                        }
                    }
                }
            }
        }
    }

    // MARK: - Empty state

    private var emptyState: some View {
        VStack(spacing: 10) {
            Image(systemName: "bubble.right")
                .font(.system(size: 36))
                .foregroundStyle(Color(.systemGray4))
            Text("No comments yet")
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.primary)
            Text("Be the first to comment")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }

    // MARK: - Input bar

    private var inputBar: some View {
        VStack(spacing: 0) {
            Divider()
            HStack(spacing: 10) {
                // Current user avatar
                Circle()
                    .fill(LinearGradient(
                        colors: [Color(hex: "#FF315F"), Color(hex: "#8B5CF6")],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ))
                    .frame(width: 32, height: 32)
                    .overlay(
                        Text("Y")
                            .font(.caption2.weight(.bold))
                            .foregroundStyle(.white)
                    )

                // Text field
                TextField("Add a comment…", text: $viewModel.inputText, axis: .vertical)
                    .font(.subheadline)
                    .lineLimit(4)
                    .focused($inputFocused)
                    .submitLabel(.send)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(Color(.systemGray6), in: RoundedRectangle(cornerRadius: 20))
                    .onSubmit { Task { await viewModel.addComment() } }

                // Send button
                Button {
                    Task { await viewModel.addComment() }
                } label: {
                    Image(systemName: "arrow.up.circle.fill")
                        .font(.system(size: 30))
                        .foregroundStyle(viewModel.inputText.trimmed.isEmpty
                            ? Color(.systemGray4)
                            : Color(hex: "#FF315F")
                        )
                }
                .disabled(viewModel.inputText.trimmed.isEmpty)
                .buttonStyle(.plain)
                .animation(.easeInOut(duration: 0.15), value: viewModel.inputText.trimmed.isEmpty)
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
            .background(Color(.systemBackground))
        }
    }
}

// MARK: - Comment Row

private struct CommentRow: View {
    let comment: Comment

    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            avatar
            VStack(alignment: .leading, spacing: 3) {
                HStack(alignment: .firstTextBaseline, spacing: 6) {
                    Text(comment.username)
                        .font(.subheadline.weight(.semibold))
                    Text(comment.timeAgo)
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
                Text(comment.text)
                    .font(.subheadline)
                    .foregroundStyle(.primary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            Spacer(minLength: 0)
        }
        .padding(.vertical, 8)
    }

    private var avatar: some View {
        Circle()
            .fill(comment.username.avatarGradient)
            .frame(width: 36, height: 36)
            .overlay(
                Text(comment.username.avatarInitials)
                    .font(.caption2.weight(.bold))
                    .foregroundStyle(.white)
            )
    }
}

// MARK: - Helpers

private extension String {
    var trimmed: String {
        trimmingCharacters(in: .whitespaces)
    }

    var avatarInitials: String {
        let clean = hasPrefix("@") ? String(dropFirst()) : self
        return String(clean.prefix(2)).uppercased()
    }

    /// Deterministic gradient per username so each commenter has a consistent color.
    var avatarGradient: LinearGradient {
        let palettes: [(Color, Color)] = [
            (Color(hex: "#FF315F"), Color(hex: "#FF6B6B")),
            (Color(hex: "#8B5CF6"), Color(hex: "#A78BFA")),
            (Color(hex: "#06B6D4"), Color(hex: "#3B82F6")),
            (Color(hex: "#10B981"), Color(hex: "#34D399")),
            (Color(hex: "#F59E0B"), Color(hex: "#FBBF24")),
            (Color(hex: "#EC4899"), Color(hex: "#F472B6")),
        ]
        let index = abs(self.hashValue) % palettes.count
        return LinearGradient(
            colors: [palettes[index].0, palettes[index].1],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}
