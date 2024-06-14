

import Foundation
import Combine

struct FilterOptions {
    var adult: Bool?
    var originalLanguage: String?
    var voteAverageRange: ClosedRange<Double>?
}

class MovieListViewModel: ObservableObject {
    @Published var popularMovies: [Movie] = []
    @Published var topRatedMovies: [Movie] = []
    @Published var searchResults: [MovieCategory: [Movie]] = [:]
    @Published var filterOptions = FilterOptions()

    private var cancellables: Set<AnyCancellable> = []
    internal let movieService: MovieServiceProtocol

    init(movieService: MovieServiceProtocol) {
        self.movieService = movieService
        fetchMovies()
    }

    func fetchMovies() {
        movieService.fetchMovies(for: .popular)
            .sink(receiveCompletion: { _ in },
                  receiveValue: { [weak self] movies in
                    self?.popularMovies = movies
                    self?.filterMovies()
            })
            .store(in: &cancellables)

        movieService.fetchMovies(for: .topRated)
            .sink(receiveCompletion: { _ in },
                  receiveValue: { [weak self] movies in
                    self?.topRatedMovies = movies
                    self?.filterMovies()
            })
            .store(in: &cancellables)
    }

    func filterMovies() {
        let allMovies = popularMovies + topRatedMovies
        let filteredMovies = allMovies.filter { movie in
            (filterOptions.adult == nil || movie.adult == filterOptions.adult!) &&
            (filterOptions.originalLanguage == nil || movie.originalLanguage == filterOptions.originalLanguage!) &&
            (filterOptions.voteAverageRange == nil || (movie.voteAverage >= filterOptions.voteAverageRange!.lowerBound && movie.voteAverage <= filterOptions.voteAverageRange!.upperBound))
        }
        self.popularMovies = filteredMovies.filter { movie in popularMovies.contains(where: { $0.id == movie.id }) }
        self.topRatedMovies = filteredMovies.filter { movie in topRatedMovies.contains(where: { $0.id == movie.id }) }
    }

    func searchMovies(query: String) {
        let popularResults = popularMovies.filter { $0.title.contains(query) }
        let topRatedResults = topRatedMovies.filter { $0.title.contains(query) }

        searchResults = [
            .popular: popularResults,
            .topRated: topRatedResults
        ]
    }
}


