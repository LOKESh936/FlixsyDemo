import SwiftUI

// MARK: - Constants

private enum FlixsyColor {
    static let accent   = Color(hex: "#FF315F")
    static let purple   = Color(hex: "#8B5CF6")
    static let glass    = Color.white.opacity(0.15)
}

// MARK: - VideoFeedCellView

struct VideoFeedCellView: View {

    let video: VideoPost
    let isVisible: Bool
    let onLike: () -> Void
    let onComment: () -> Void


    var body: some View {
        ZStack {
            // ── Video layer ──────────────────────────────────────────────
            Color.black.ignoresSafeArea()

            VideoPlayerView(videoName: video.videoName, isVisible: isVisible)
                .ignoresSafeArea()

            // ── Gradient overlay ─────────────────────────────────────────
            gradientOverlay

            // ── UI layers ────────────────────────────────────────────────
            VStack(spacing: 0) {
                topHeader
                Spacer()
                bottomSection
            }
            .ignoresSafeArea(edges: .top)
        }
    }

    // MARK: - Gradient

    private var gradientOverlay: some View {
        VStack(spacing: 0) {
            // top fade — keeps header readable
            LinearGradient(
                colors: [.black.opacity(0.55), .clear],
                startPoint: .top,
                endPoint: .bottom
            )
            .frame(height: 140)

            Spacer()

            // bottom fade — keeps creator info and action rail readable
            LinearGradient(
                colors: [.clear, .black.opacity(0.85)],
                startPoint: .top,
                endPoint: .bottom
            )
            .frame(height: 380)
        }
        .ignoresSafeArea()
    }

    // MARK: - Top header

    private var topHeader: some View {
        HStack {
            Text("Flixsy")
                .font(.title3.weight(.black))
                .foregroundStyle(.white)
                .tracking(1)

            Spacer()

            Text("For You")
                .font(.caption.weight(.semibold))
                .foregroundStyle(.white)
                .padding(.horizontal, 12)
                .padding(.vertical, 5)
                .background(.white.opacity(0.2), in: Capsule())
                .overlay(Capsule().stroke(.white.opacity(0.35), lineWidth: 1))
        }
        .padding(.horizontal, 20)
        .padding(.top, 56)
    }

    // MARK: - Bottom section

    private var bottomSection: some View {
        HStack(alignment: .bottom, spacing: 0) {
            creatorSection
            Spacer()
            actionRail
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 36)
    }

    // MARK: - Creator section (bottom-left)

    private var creatorSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            // Avatar + username row
            HStack(spacing: 10) {
                avatarView
                VStack(alignment: .leading, spacing: 1) {
                    Text(video.username)
                        .font(.subheadline.weight(.bold))
                        .foregroundStyle(.white)
                    Text("Flixsy creator")
                        .font(.caption2)
                        .foregroundStyle(.white.opacity(0.6))
                }

                followButton
            }

            // Caption
            Text(video.caption)
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.95))
                .lineLimit(2)
                .shadow(color: .black.opacity(0.4), radius: 3)

            // Audio title
            HStack(spacing: 5) {
                Image(systemName: "music.note")
                    .font(.caption2.weight(.semibold))
                Text(video.audioTitle)
                    .font(.caption)
                    .lineLimit(1)
            }
            .foregroundStyle(.white.opacity(0.8))
        }
        .frame(maxWidth: UIScreen.main.bounds.width * 0.68, alignment: .leading)
    }

    // MARK: - Avatar

    private var avatarView: some View {
        ZStack {
            Circle()
                .fill(
                    LinearGradient(
                        colors: [FlixsyColor.accent, FlixsyColor.purple],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 42, height: 42)

            Text(String(video.username.dropFirst().prefix(1)).uppercased())
                .font(.headline.weight(.bold))
                .foregroundStyle(.white)
        }
        .overlay(
            Circle()
                .stroke(.white, lineWidth: 1.5)
        )
    }

    // MARK: - Follow button

    private var followButton: some View {
        Text("Follow")
            .font(.caption.weight(.bold))
            .foregroundStyle(.white)
            .padding(.horizontal, 12)
            .padding(.vertical, 5)
            .background(FlixsyColor.accent, in: Capsule())
    }

    // MARK: - Action rail (right side)

    private var actionRail: some View {
        FeedActionButtonsView(
            isLiked:      video.isLiked,
            likeCount:    video.likeCount,
            commentCount: video.commentCount,
            onLike:       onLike,
            onComment:    onComment
        )
        .padding(.bottom, 8)
    }
}


