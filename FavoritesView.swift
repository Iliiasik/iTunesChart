import SwiftUI

// MARK: - Favorites View
struct FavoritesView: View {
    @ObservedObject var viewModel: PodcastViewModel
    
    var body: some View {
        VStack {
            TextField("Search Favorites", text: $viewModel.searchQuery)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            List {
                ForEach(viewModel.filteredFavoritePodcasts) { podcast in
                    VStack(alignment: .leading) {
                        Text(podcast.title)
                            .font(.headline)
                        
                        Button("Play") {
                            viewModel.playPodcast(from: podcast.rssURL)
                        }
                        .padding(.top, 5)
                        
                        Button("Remove from Favorites") {
                            viewModel.removeFromFavorites(podcast: podcast)
                        }
                        .padding(.top, 5)
                        .foregroundColor(.red)
                    }
                }
            }
        }
        .navigationTitle("Favorites")
    }
}

