
import Foundation
import Combine

protocol MovieServiceProtocol {
    func fetchMovies(for category: MovieCategory) -> AnyPublisher<[Movie], Error>
    func imageUrl(for path: String) -> String
}

class MovieService: MovieServiceProtocol {
    internal let apiKey = "7f3262676ed629a0e80c159c8ff18aba"
    internal let baseUrl = "https://api.themoviedb.org/3/movie/"
    internal let baseImageUrl = "https://image.tmdb.org/t/p/w300"

    func fetchMovies(for category: MovieCategory) -> AnyPublisher<[Movie], Error> {
        var urlString: String
        switch category {
        case .popular:
            urlString = "\(baseUrl)popular?api_key=\(apiKey)"
        case .topRated:
            urlString = "\(baseUrl)top_rated?api_key=\(apiKey)"
        }

        guard let url = URL(string: urlString) else {
            return Fail(error: URLError(.badURL))
                .eraseToAnyPublisher()
        }

        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: MovieResponse.self, decoder: JSONDecoder())
            .map { $0.results }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    func imageUrl(for path: String) -> String {
        return "\(baseImageUrl)\(path)"
    }
}


