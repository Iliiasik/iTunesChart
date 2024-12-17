import SwiftUI

// MARK: - Podcast Search View
struct PodcastSearchView: View {
    @ObservedObject var viewModel: PodcastViewModel
    
    var body: some View {
        VStack {
            TextField("Enter podcast topic", text: $viewModel.searchQuery)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            Button("Search Podcasts") {
                viewModel.searchPodcasts()
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
            
            if let podcasts = viewModel.podcasts {
                List(podcasts, id: \.rssURL) { podcast in
                    VStack(alignment: .leading) {
                        Text(podcast.title)
                            .font(.headline)
                        
                        Button("Play") {
                            viewModel.playPodcast(from: podcast.rssURL)
                        }
                        .padding(.top, 5)
                        
                        // Кнопка для добавления в избранное
                        Button(viewModel.favoritePodcasts.contains(where: { $0.rssURL == podcast.rssURL }) ? "Already in Favorites" : "Add to Favorites") {
                            viewModel.addToFavorites(podcast: podcast)
                        }
                        .padding(.top, 5)
                        .foregroundColor(.green)
                    }
                }
            }
            
            if viewModel.audioPlayer != nil {
                PlaybackControlsView(viewModel: viewModel)
                    .padding()
            }
        }
        .padding()
        .navigationTitle("Podcast Search")
    }
}
