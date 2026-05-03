# FlixsyDemo

A TikTok-style vertical short-video feed built entirely with SwiftUI and AVKit. Swipe through posts, like videos, and browse comments — all backed by an in-memory mock service so the app runs with zero network setup.

---

## Features

- **Full-screen vertical paging feed** — native `scrollTargetBehavior(.paging)` on iOS 17+, no rotation hacks
- **Looping video playback** — `AVQueuePlayer` + `AVPlayerLooper`, muted by default, plays only the visible cell
- **Like / unlike** — instant optimistic update with spring-pop animation, rolls back on failure
- **Comments sheet** — bottom sheet with `.presentationDetents([.medium, .large])`, live comment list, keyboard-safe input bar
- **Mock API layer** — async/await service protocol with simulated network delay and in-memory comment store
- **Graceful placeholder** — dark gradient + icon shown when a video file is absent from the bundle

---

## Tech Stack

| Layer | Technology |
|---|---|
| UI | SwiftUI (iOS 17+) |
| Video | AVFoundation / AVKit |
| State | `@StateObject`, `@Published`, `@MainActor` |
| Async | Swift Concurrency (`async`/`await`, `Task`) |
| Architecture | MVVM |
| Data | In-memory mock service |

---

## Architecture

```
FlixsyDemo/
├── App/
│   └── FlixsyDemoApp.swift        # @main entry point
├── Models/
│   ├── VideoPost.swift            # Feed post model (Identifiable, Equatable)
│   └── Comment.swift              # Comment model with timeAgo helper
├── Services/
│   ├── FeedServiceProtocol.swift  # Async service contract
│   └── MockFeedService.swift      # In-memory implementation
├── MockData/
│   └── MockData.swift             # Sample videos and comments
├── ViewModels/
│   ├── FeedViewModel.swift        # Feed state, paging, like/comment actions
│   └── CommentsViewModel.swift    # Comment list, optimistic add
└── Views/
    ├── FeedView.swift             # Root paging scroll view + sheet
    ├── VideoFeedCellView.swift    # Full-screen cell: video + overlays
    ├── VideoPlayerView.swift      # AVKit UIViewRepresentable player
    ├── FeedActionButtonsView.swift# Right-side action rail (like / comment / share)
    └── CommentsSheetView.swift    # Bottom sheet with comment list and input
```

**Data flow:**
1. `FeedView` owns `FeedViewModel` via `@StateObject`.
2. Each `VideoFeedCellView` receives a snapshot of its `VideoPost` plus closures — it never writes to the ViewModel directly.
3. `FeedViewModel.currentVersion(of:)` ensures cells always reflect the latest like/comment counts after optimistic updates.
4. `selectedVideo` in `FeedViewModel` drives the comments sheet; setting it to `nil` dismisses the sheet.

---

## How to Run

1. **Clone the repo**
   ```bash
   git clone https://github.com/LOKESh936/FlixsyDemo.git
   cd FlixsyDemo
   ```

2. **Open in Xcode**
   ```bash
   open FlixsyDemo.xcodeproj
   ```

3. **Select a simulator or device** running iOS 17 or later (tested on iOS 26.2 simulator).

4. **Build and run** (`⌘R`).

> The app works out of the box with the mock data. No API keys or accounts required.

### Adding real video files

The mock data references video names `sample1` through `sample6`. Drop `.mp4` files with those names into the `FlixsyDemo/` folder and add them to the Xcode target to see actual video playback. Until then, each cell shows a dark gradient placeholder.

---

## Future Improvements

- **Real backend API** — replace `MockFeedService` with a `NetworkFeedService` backed by a REST or GraphQL API; the protocol boundary makes this a drop-in swap
- **Video caching** — pre-buffer the next cell using `AVAsset` loading while the current one plays
- **Pagination** — load videos in pages as the user approaches the end of the feed
- **AVPlayer reuse pool** — maintain a small pool of `AVQueuePlayer` instances rather than creating one per cell to reduce memory and startup latency
- **Authentication** — add Sign in with Apple or email/password flow; "You" avatar in the comments input bar is currently a static placeholder
- **Video upload flow** — camera capture + video trimmer + metadata entry sheet before posting
- **Push notifications** — notify users of new likes and comments using APNs
- **Explore / Search tab** — hashtag and user search over a server-side index
- **Accessibility** — VoiceOver labels for all action buttons and video descriptions
