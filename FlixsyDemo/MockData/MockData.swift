import Foundation

// MARK: - MockData
// Videos reference bundle resource names ("sample1" … "sample6").
// Add the matching .mp4 files to the Xcode project bundle before running.

enum MockData {

    // MARK: Videos

    static let videos: [VideoPost] = [
        VideoPost(
            id: "v1",
            videoName: "sample1",
            username: "@skaterboy",
            userDisplayName: "Jake Miller",
            caption: "Crazy trick at the park 🛹 #skating #tricks #fyp",
            audioTitle: "Skate Culture Mix — DJ Phantom",
            likeCount: 14_200,
            commentCount: 4,
            isLiked: false
        ),
        VideoPost(
            id: "v2",
            videoName: "sample2",
            username: "@naturelover",
            userDisplayName: "Sophia Green",
            caption: "Golden hour hits different 🌅 #nature #sunset #vibes",
            audioTitle: "Golden Hour — JVKE",
            likeCount: 9_871,
            commentCount: 3,
            isLiked: false
        ),
        VideoPost(
            id: "v3",
            videoName: "sample3",
            username: "@adventuretime",
            userDisplayName: "Lena Trails",
            caption: "New trail drop every weekend 🏔️ #hiking #outdoors",
            audioTitle: "Into The Wild — Bear Grylls Beats",
            likeCount: 23_450,
            commentCount: 3,
            isLiked: true
        ),
        VideoPost(
            id: "v4",
            videoName: "sample4",
            username: "@fastlane",
            userDisplayName: "Marco Rossi",
            caption: "Weekend ride 🚗💨 #cars #driving #weekend",
            audioTitle: "Fast Life — Midnight Club",
            likeCount: 8_934,
            commentCount: 2,
            isLiked: false
        ),
        VideoPost(
            id: "v5",
            videoName: "sample5",
            username: "@chefmode",
            userDisplayName: "Priya Kapoor",
            caption: "5-minute pasta that actually slaps 🍝 #cooking #food #quickrecipe",
            audioTitle: "Cooking Lo-Fi — Café Sessions",
            likeCount: 31_060,
            commentCount: 3,
            isLiked: false
        ),
        VideoPost(
            id: "v6",
            videoName: "sample6",
            username: "@animationfan",
            userDisplayName: "Chris Byte",
            caption: "Classic never gets old 🐰 #animation #funny #cute",
            audioTitle: "Big Buck Bunny OST — Sacha Goedegebure",
            likeCount: 45_678,
            commentCount: 3,
            isLiked: false
        ),
    ]

    // MARK: Comments

    static let comments: [String: [Comment]] = [
        "v1": [
            Comment(id: "c1",  videoId: "v1", username: "@mike_r",     text: "That trick was insane!! 🔥",             createdAt: Date().addingTimeInterval(-300)),
            Comment(id: "c2",  videoId: "v1", username: "@sarah_k",    text: "How long did it take to learn that?",    createdAt: Date().addingTimeInterval(-600)),
            Comment(id: "c3",  videoId: "v1", username: "@jdoe",       text: "Bro the editing 👌",                     createdAt: Date().addingTimeInterval(-1200)),
            Comment(id: "c4",  videoId: "v1", username: "@park_local", text: "I see you at this park every day lol",   createdAt: Date().addingTimeInterval(-3600)),
        ],
        "v2": [
            Comment(id: "c5",  videoId: "v2", username: "@photo_paul",      text: "The colors are unreal 😍",          createdAt: Date().addingTimeInterval(-120)),
            Comment(id: "c6",  videoId: "v2", username: "@wanderer",        text: "Where is this?? Need to visit",      createdAt: Date().addingTimeInterval(-450)),
            Comment(id: "c7",  videoId: "v2", username: "@goldenhourclub",  text: "Perfect timing on this shot",        createdAt: Date().addingTimeInterval(-900)),
        ],
        "v3": [
            Comment(id: "c8",  videoId: "v3", username: "@hiker99",        text: "Trail name??",                       createdAt: Date().addingTimeInterval(-200)),
            Comment(id: "c9",  videoId: "v3", username: "@boots_n_trails", text: "Adding this to my list 📝",          createdAt: Date().addingTimeInterval(-500)),
            Comment(id: "c10", videoId: "v3", username: "@mountainpeak",   text: "Looks tough but worth it!",          createdAt: Date().addingTimeInterval(-2000)),
        ],
        "v4": [
            Comment(id: "c11", videoId: "v4", username: "@gearhead",   text: "What's the car? 👀",                    createdAt: Date().addingTimeInterval(-100)),
            Comment(id: "c12", videoId: "v4", username: "@speedfreak", text: "Need this in my life rn",               createdAt: Date().addingTimeInterval(-800)),
        ],
        "v5": [
            Comment(id: "c13", videoId: "v5", username: "@foodie_nyc",  text: "Making this tonight no cap 🔥",        createdAt: Date().addingTimeInterval(-90)),
            Comment(id: "c14", videoId: "v5", username: "@pasta_stan",  text: "What cheese did you use??",             createdAt: Date().addingTimeInterval(-400)),
            Comment(id: "c15", videoId: "v5", username: "@homecook44",  text: "My family loved this recipe!",          createdAt: Date().addingTimeInterval(-1800)),
        ],
        "v6": [
            Comment(id: "c16", videoId: "v6", username: "@toon_fan",    text: "Pure nostalgia 💙",                    createdAt: Date().addingTimeInterval(-60)),
            Comment(id: "c17", videoId: "v6", username: "@pixar_lover", text: "Still a masterpiece",                  createdAt: Date().addingTimeInterval(-300)),
            Comment(id: "c18", videoId: "v6", username: "@bestofweb",   text: "Classic open source content!",         createdAt: Date().addingTimeInterval(-1500)),
        ],
    ]
}
