import AVKit
import SwiftUI

// MARK: - ViewModel
class PodcastViewModel: ObservableObject {
    @Published var searchQuery = ""
    @Published var podcasts: [(title: String, rssURL: String)]? = nil
    @Published var audioPlayer: AVPlayer? = nil
    @Published var currentPlayingURL: String? = nil
    @Published var isPlaying = false
    @Published var playbackProgress: Double = 0
    @Published var playbackDuration: Double = 0
    
    // Массив избранных подкастов
    @Published var favoritePodcasts: [FavoritePodcast] = []
    
    // Фильтруем избранные подкасты по поисковому запросу
    var filteredFavoritePodcasts: [FavoritePodcast] {
        if searchQuery.isEmpty {
            return favoritePodcasts
        } else {
            return favoritePodcasts.filter { $0.title.lowercased().contains(searchQuery.lowercased()) }
        }
    }
    
    private let itunesService = ITunesAPIService()
    private let rssParserService = RSSParserService()
    private var playerObserver: Any?
    
    func searchPodcasts() {
        itunesService.searchForPodcasts(query: searchQuery) { [weak self] podcasts in
            DispatchQueue.main.async {
                self?.podcasts = podcasts
            }
        }
    }
    
    func playPodcast(from rssURL: String) {
        // Останавливаем предыдущий подкаст
        if let audioPlayer = audioPlayer {
            audioPlayer.pause()
            self.audioPlayer = nil
            self.currentPlayingURL = nil
            self.playbackProgress = 0
            self.playbackDuration = 0
        }
        
        // Загружаем и воспроизводим новый подкаст
        rssParserService.fetchPodcastAudioURL(from: rssURL) { [weak self] audioURL in
            DispatchQueue.main.async {
                guard let self = self, let audioURL = audioURL, let url = URL(string: audioURL) else {
                    print("Аудиофайл не найден")
                    return
                }
                
                self.audioPlayer = AVPlayer(url: url)
                self.currentPlayingURL = audioURL
                self.audioPlayer?.play()
                self.isPlaying = true
                self.setupPlaybackObserver()
            }
        }
    }
    
    func pausePlayback() {
        audioPlayer?.pause()
        isPlaying = false
    }
    
    func setupPlaybackObserver() {
        guard let player = audioPlayer else { return }
        playerObserver = player.addPeriodicTimeObserver(forInterval: CMTime(seconds: 1, preferredTimescale: 1), queue: .main) { [weak self] time in
            self?.playbackProgress = time.seconds
            self?.playbackDuration = player.currentItem?.duration.seconds ?? 0
        }
    }
    
    // Добавление подкаста в избранное
    func addToFavorites(podcast: (title: String, rssURL: String)) {
        // Проверка, существует ли уже этот подкаст в избранном
        if !favoritePodcasts.contains(where: { $0.rssURL == podcast.rssURL }) {
            let favoritePodcast = FavoritePodcast(title: podcast.title, rssURL: podcast.rssURL)
            favoritePodcasts.append(favoritePodcast)
        }
    }
    
    // Удаление подкаста из избранного
    func removeFromFavorites(podcast: FavoritePodcast) {
        favoritePodcasts.removeAll { $0.id == podcast.id }
    }
}

