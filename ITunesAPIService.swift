import Foundation

// MARK: - iTunes Search API Service
class ITunesAPIService {
    private let baseURL = "https://itunes.apple.com/search"
    
    func searchForPodcasts(query: String, completion: @escaping ([(title: String, rssURL: String)]?) -> Void) {
        guard let queryEncoded = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "\(baseURL)?term=\(queryEncoded)&media=podcast&limit=10") else {
            completion(nil)
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Ошибка iTunes API: \(error.localizedDescription)")
                completion(nil)
                return
            }

            guard let data = data else {
                completion(nil)
                return
            }

            do {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                let results = json?["results"] as? [[String: Any]]
                
                let podcastData = results?.compactMap { result -> (String, String)? in
                    if let title = result["collectionName"] as? String,
                       let rssURL = result["feedUrl"] as? String {
                        return (title, rssURL)
                    }
                    return nil
                }
                completion(podcastData)
            } catch {
                print("Ошибка обработки iTunes API: \(error)")
                completion(nil)
            }
        }
        task.resume()
    }
}

