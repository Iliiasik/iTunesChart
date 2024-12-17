import SwiftUI

@main
struct PodcastApp: App {
    @StateObject private var viewModel = PodcastViewModel()
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                VStack {
                    NavigationLink(destination: FavoritesView(viewModel: viewModel)) {
                        Text("Go to Favorites")
                            .foregroundColor(.blue)
                            .padding()
                    }
                    PodcastSearchView(viewModel: viewModel)
                }
            }
        }
    }
}

