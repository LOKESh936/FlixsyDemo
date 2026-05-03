import Foundation

enum MockData {

    static let videos: [VideoPost] = [
        VideoPost(
            id: "1",
            videoURL: URL(string: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerFun.mp4")!,
            username: "@skaterboy",
            description: "Crazy trick at the park 🛹 #skating #tricks #fyp",
            likeCount: 14_200,
            commentCount: 342,
            isLiked: false
        ),
        VideoPost(
            id: "2",
            videoURL: URL(string: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4")!,
            username: "@naturelover",
            description: "Golden hour hits different 🌅 #nature #sunset #vibes",
            likeCount: 9_871,
            commentCount: 128,
            isLiked: false
        ),
        VideoPost(
            id: "3",
            videoURL: URL(string: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4")!,
            username: "@adventuretime",
            description: "New trail drop every weekend 🏔️ #hiking #outdoors",
            likeCount: 23_450,
            commentCount: 567,
            isLiked: true
        ),
        VideoPost(
            id: "4",
            videoURL: URL(string: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerJoyrides.mp4")!,
            username: "@fastlane",
            description: "Weekend ride 🚗💨 #cars #driving #weekend",
            likeCount: 8_934,
            commentCount: 211,
            isLiked: false
        ),
        VideoPost(
            id: "5",
            videoURL: URL(string: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4")!,
            username: "@animationfan",
            description: "Classic never gets old 🐰 #animation #funny #cute",
            likeCount: 45_678,
            commentCount: 1_203,
            isLiked: false
        ),
    ]

    static let comments: [String: [Comment]] = [
        "1": [
            Comment(id: "c1", username: "@mike_r",     text: "That trick was insane!! 🔥",                  timestamp: Date().addingTimeInterval(-300)),
            Comment(id: "c2", username: "@sarah_k",    text: "How long did it take to learn that?",         timestamp: Date().addingTimeInterval(-600)),
            Comment(id: "c3", username: "@jdoe",       text: "Bro the editing 👌",                          timestamp: Date().addingTimeInterval(-1200)),
            Comment(id: "c4", username: "@park_local", text: "I see you at this park every day lol",        timestamp: Date().addingTimeInterval(-3600)),
        ],
        "2": [
            Comment(id: "c5", username: "@photo_paul",     text: "The colors are unreal 😍",               timestamp: Date().addingTimeInterval(-120)),
            Comment(id: "c6", username: "@wanderer",       text: "Where is this?? Need to visit",           timestamp: Date().addingTimeInterval(-450)),
            Comment(id: "c7", username: "@goldenhourclub", text: "Perfect timing on this shot",             timestamp: Date().addingTimeInterval(-900)),
        ],
        "3": [
            Comment(id: "c8",  username: "@hiker99",       text: "Trail name??",                            timestamp: Date().addingTimeInterval(-200)),
            Comment(id: "c9",  username: "@boots_n_trails", text: "Adding this to my list 📝",             timestamp: Date().addingTimeInterval(-500)),
            Comment(id: "c10", username: "@mountainpeak",  text: "Looks tough but worth it!",              timestamp: Date().addingTimeInterval(-2000)),
        ],
        "4": [
            Comment(id: "c11", username: "@gearhead",   text: "What's the car? 👀",                        timestamp: Date().addingTimeInterval(-100)),
            Comment(id: "c12", username: "@speedfreak", text: "Need this in my life rn",                   timestamp: Date().addingTimeInterval(-800)),
        ],
        "5": [
            Comment(id: "c13", username: "@toon_fan",   text: "Pure nostalgia 💙",                         timestamp: Date().addingTimeInterval(-60)),
            Comment(id: "c14", username: "@pixar_lover", text: "Still a masterpiece",                      timestamp: Date().addingTimeInterval(-300)),
            Comment(id: "c15", username: "@bestofweb",  text: "Classic open source content!",              timestamp: Date().addingTimeInterval(-1500)),
        ],
    ]
}
