import Foundation

struct Comment: Identifiable {
    let id: String
    let username: String
    let text: String
    let timestamp: Date

    var timeAgo: String {
        let diff = Date().timeIntervalSince(timestamp)
        switch diff {
        case ..<60:    return "just now"
        case ..<3600:  return "\(Int(diff / 60))m ago"
        case ..<86400: return "\(Int(diff / 3600))h ago"
        default:       return "\(Int(diff / 86400))d ago"
        }
    }
}
