import SwiftUI
import AVKit
// MARK: - Playback Controls View
struct PlaybackControlsView: View {
    @ObservedObject var viewModel: PodcastViewModel
    
    var body: some View {
        VStack {
            if viewModel.playbackDuration > 0 {
                Slider(value: Binding(get: {
                    viewModel.playbackProgress
                }, set: { newValue in
                    viewModel.audioPlayer?.seek(to: CMTime(seconds: newValue, preferredTimescale: 1))
                }), in: 0...viewModel.playbackDuration)
                
                Text("\(formatTime(viewModel.playbackProgress)) / \(formatTime(viewModel.playbackDuration))")
                    .font(.caption)
            }
            
            HStack {
                Button("Play") {
                    viewModel.audioPlayer?.play()
                    viewModel.isPlaying = true
                }
                .padding()
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(10)
                
                Button("Pause") {
                    viewModel.pausePlayback()
                }
                .padding()
                .background(Color.red)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
        }
    }
    
    private func formatTime(_ time: Double) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

