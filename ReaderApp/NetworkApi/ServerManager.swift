import Foundation

// MARK: - Server Manager

struct ServerManager {

    static let shared = ServerManager()

    static func newsApiServer(_handler: @escaping (NewsResponse?, String?) -> Void) {

        let urlString = "https://newsapi.org/v2/everything?q=bitcoin&apiKey=098b1d64a17d476e8f21d15f986afa5e"

        guard let url = URL(string: urlString) else {
            _handler(nil, "Invalid URL")
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in

            if let error = error {
                _handler(nil, "Error: \(error.localizedDescription)")
                return
            }

            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                _handler(nil, "Invalid response: \(response.debugDescription)")
                return
            }

            guard let data = data else {
                _handler(nil, "No data received")
                return
            }

             do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                decoder.dateDecodingStrategy = .iso8601
                let apiData = try decoder.decode(NewsResponse.self, from: data)
                _handler(apiData, nil)
            } catch {
                _handler(nil, "Decoding error: \(error.localizedDescription)")
             }

        }.resume()
    }
}
