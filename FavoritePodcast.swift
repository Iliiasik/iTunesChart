import Foundation

// MARK: - Podcast Model
struct FavoritePodcast: Identifiable {
    let id = UUID()
    let title: String
    let rssURL: String
}
