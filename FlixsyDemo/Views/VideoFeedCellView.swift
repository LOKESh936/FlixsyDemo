import SwiftUI

// MARK: - Brand colors (used across feed UI)

enum FlixsyColor {
    static let accent = Color(hex: "#FF315F")   // primary pink/red
    static let purple = Color(hex: "#8B5CF6")   // secondary purple
}

// MARK: - VideoFeedCellView

struct VideoFeedCellView: View {

    let video: VideoPost
    let isVisible: Bool
    let onLike: () -> Void
    let onComment: () -> Void

    var body: some View {
        ZStack {
            // Base fill in case the player hasn't loaded yet
            Color.black.ignoresSafeArea()

            // Full-screen looping video (or dark gradient placeholder if file missing)
            VideoPlayerView(videoName: video.videoName, isVisible: isVisible)
                .ignoresSafeArea()

            // Two-zone gradient: darkens top for header and bottom for creator info
            gradientOverlay

            // All interactive UI sits above the video
            VStack(spacing: 0) {
                topHeader
                Spacer()
                bottomSection
            }
            .ignoresSafeArea(edges: .top)
        }
    }

    // MARK: - Gradient overlay

    private var gradientOverlay: some View {
        VStack(spacing: 0) {
            // Top zone: keeps "Flixsy" + "For You" readable over bright video
            LinearGradient(
                colors: [.black.opacity(0.55), .clear],
                startPoint: .top,
                endPoint: .bottom
            )
            .frame(height: 140)

            Spacer()

            // Bottom zone: keeps creator info and action rail readable
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
                .background(.white.opacity(0.18), in: Capsule())
                .overlay(Capsule().stroke(.white.opacity(0.3), lineWidth: 1))
        }
        .padding(.horizontal, 20)
        .padding(.top, 56)
    }

    // MARK: - Bottom section

    private var bottomSection: some View {
        HStack(alignment: .bottom, spacing: 0) {
            creatorSection
            Spacer(minLength: 12)
            actionRail
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 40)
    }

    // MARK: - Creator section

    private var creatorSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            // Avatar row: avatar + username + subtitle + follow pill
            HStack(spacing: 10) {
                avatarView

                VStack(alignment: .leading, spacing: 2) {
                    Text(video.username)
                        .font(.subheadline.weight(.bold))
                        .foregroundStyle(.white)
                    Text("Flixsy creator")
                        .font(.caption2)
                        .foregroundStyle(.white.opacity(0.55))
                }

                followButton
            }

            // Caption — up to 2 lines
            Text(video.caption)
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.95))
                .lineLimit(2)
                .shadow(color: .black.opacity(0.45), radius: 3)

            // Scrolling audio title
            HStack(spacing: 5) {
                Image(systemName: "music.note")
                    .font(.caption2.weight(.semibold))
                Text(video.audioTitle)
                    .font(.caption)
                    .lineLimit(1)
            }
            .foregroundStyle(.white.opacity(0.8))
        }
        // containerRelativeFrame replaces the deprecated UIScreen.main approach.
        // 2/3 of the horizontal container ≈ 66 % — leaves room for the action rail.
        .containerRelativeFrame(.horizontal, count: 3, span: 2, spacing: 0, alignment: .leading)
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

            // First letter of the @handle (drop the @)
            Text(String(video.username.dropFirst().prefix(1)).uppercased())
                .font(.headline.weight(.bold))
                .foregroundStyle(.white)
        }
        .overlay(Circle().stroke(.white, lineWidth: 1.5))
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

    // MARK: - Action rail

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
