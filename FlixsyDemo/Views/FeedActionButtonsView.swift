import SwiftUI

// MARK: - FeedActionButtonsView

struct FeedActionButtonsView: View {

    // MARK: - Inputs

    let isLiked: Bool
    let likeCount: Int
    let commentCount: Int
    let onLike: () -> Void
    let onComment: () -> Void

    // MARK: - Private state

    @State private var likeScale: CGFloat = 1.0

    // MARK: - Body

    var body: some View {
        VStack(spacing: 20) {
            likeButton
            commentButton
            shareButton
        }
    }

    // MARK: - Like

    private var likeButton: some View {
        ActionButton(
            icon: isLiked ? "heart.fill" : "heart",
            label: likeCount.compactFormatted,
            tint: isLiked ? .pink : .white
        ) {
            withAnimation(.spring(response: 0.25, dampingFraction: 0.65)) {
                likeScale = 1.4
            }
            // Settle back after the overshoot
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.12) {
                withAnimation(.spring(response: 0.25, dampingFraction: 0.65)) {
                    likeScale = 1.0
                }
            }
            onLike()
        }
        .scaleEffect(likeScale)
    }

    // MARK: - Comment

    private var commentButton: some View {
        ActionButton(
            icon: "bubble.right",
            label: commentCount.compactFormatted,
            tint: .white,
            action: onComment
        )
    }

    // MARK: - Share

    private var shareButton: some View {
        ActionButton(
            icon: "arrowshape.turn.up.right",
            label: nil,
            tint: .white,
            action: {}
        )
    }
}

// MARK: - ActionButton

private struct ActionButton: View {
    let icon: String
    let label: String?
    let tint: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 5) {
                // Blurred circular background
                ZStack {
                    Circle()
                        .fill(.ultraThinMaterial)
                        .frame(width: 52, height: 52)
                        .shadow(color: .black.opacity(0.3), radius: 6, y: 3)

                    Image(systemName: icon)
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundStyle(tint)
                        .animation(.spring(response: 0.25, dampingFraction: 0.65), value: icon)
                }

                if let label {
                    Text(label)
                        .font(.caption2.weight(.semibold))
                        .foregroundStyle(.white)
                }
            }
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Helpers

extension Int {
    var compactFormatted: String {
        switch self {
        case 1_000_000...: return String(format: "%.1fM", Double(self) / 1_000_000)
        case 1_000...:     return String(format: "%.1fK", Double(self) / 1_000)
        default:           return "\(self)"
        }
    }
}
