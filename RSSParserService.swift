
import Foundation

// MARK: - RSS Parser Service
class RSSParserService {
    func fetchPodcastAudioURL(from rssURL: String, completion: @escaping (String?) -> Void) {
        guard let url = URL(string: rssURL) else {
            completion(nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Ошибка RSS: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let data = data else {
                completion(nil)
                return
            }
            
            let xmlString = String(data: data, encoding: .utf8)
            let audioURL = self.extractAudioURL(from: xmlString)
            completion(audioURL)
        }
        task.resume()
    }
    
    private func extractAudioURL(from xml: String?) -> String? {
        guard let xml = xml else { return nil }
        let pattern = "<enclosure url=\"(.*?)\""
        let regex = try? NSRegularExpression(pattern: pattern, options: [])
        let range = NSRange(location: 0, length: xml.utf16.count)
        
        if let match = regex?.firstMatch(in: xml, options: [], range: range),
           let audioURLRange = Range(match.range(at: 1), in: xml) {
            return String(xml[audioURLRange])
        }
        return nil
    }
}
