import SwiftUI

struct FeedActionButtonsView: View {
    let video: VideoPost
    let onLike: () -> Void
    let onComment: () -> Void

    var body: some View {
        VStack(spacing: 22) {
            ActionButton(
                systemImage: video.isLiked ? "heart.fill" : "heart",
                label: video.likeCount.compactFormatted,
                tint: video.isLiked ? .red : .white,
                action: onLike
            )
            ActionButton(
                systemImage: "bubble.right",
                label: video.commentCount.compactFormatted,
                tint: .white,
                action: onComment
            )
            ActionButton(
                systemImage: "arrowshape.turn.up.right",
                label: nil,
                tint: .white,
                action: {}
            )
        }
    }
}

// MARK: - Private

private struct ActionButton: View {
    let systemImage: String
    let label: String?
    let tint: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: systemImage)
                    .font(.system(size: 30, weight: .semibold))
                    .foregroundStyle(tint)
                    .shadow(color: .black.opacity(0.4), radius: 4)
                if let label {
                    Text(label)
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.white)
                        .shadow(color: .black.opacity(0.4), radius: 2)
                }
            }
        }
        .buttonStyle(.plain)
    }
}

private extension Int {
    var compactFormatted: String {
        switch self {
        case 1_000_000...: return String(format: "%.1fM", Double(self) / 1_000_000)
        case 1_000...:     return String(format: "%.1fK", Double(self) / 1_000)
        default:           return "\(self)"
        }
    }
}
