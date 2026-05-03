import SwiftUI

// MARK: - FeedActionButtonsView
//
// Reusable right-side action rail. Accepts primitives instead of VideoPost
// so it can be embedded anywhere without coupling to the feed data model.

struct FeedActionButtonsView: View {

    let isLiked:      Bool
    let likeCount:    Int
    let commentCount: Int
    let onLike:       () -> Void
    let onComment:    () -> Void

    // likeScale is local — the animation lives entirely inside this component.
    @State private var likeScale: CGFloat = 1.0

    var body: some View {
        VStack(spacing: 22) {
            likeButton
            commentButton
            shareButton
        }
    }

    // MARK: - Like

    private var likeButton: some View {
        ActionButton(
            icon:  isLiked ? "heart.fill" : "heart",
            label: likeCount.compactFormatted,
            tint:  isLiked ? Color(hex: "#FF315F") : .white
        ) {
            // Pop: overshoot up, then spring back
            withAnimation(.spring(response: 0.25, dampingFraction: 0.65)) {
                likeScale = 1.4
            }
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
            icon:   "bubble.right",
            label:  commentCount.compactFormatted,
            tint:   .white,
            action: onComment
        )
    }

    // MARK: - Share (no-op in demo)

    private var shareButton: some View {
        ActionButton(
            icon:   "arrowshape.turn.up.right",
            label:  nil,
            tint:   .white,
            action: {}
        )
    }
}

// MARK: - ActionButton

private struct ActionButton: View {
    let icon:   String
    let label:  String?
    let tint:   Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 5) {
                ZStack {
                    // Blurred circle adapts to any video content behind it
                    Circle()
                        .fill(.ultraThinMaterial)
                        .frame(width: 52, height: 52)
                        .shadow(color: .black.opacity(0.3), radius: 6, y: 3)

                    Image(systemName: icon)
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundStyle(tint)
                        // Crossfade when icon name changes (heart ↔ heart.fill)
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

// MARK: - Int formatting

extension Int {
    /// Compact display: 14200 → "14.2K", 1500000 → "1.5M"
    var compactFormatted: String {
        switch self {
        case 1_000_000...: return String(format: "%.1fM", Double(self) / 1_000_000)
        case 1_000...:     return String(format: "%.1fK", Double(self) / 1_000)
        default:           return "\(self)"
        }
    }
}
