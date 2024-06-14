
import SwiftUI

struct MovieListView: View {
    @EnvironmentObject var viewModel: MovieListViewModel
    var category: MovieCategory

    var body: some View {
        List {
            ForEach(filteredMovies(for: category)) { movie in
                MovieRowView(movie: movie, movieService: viewModel.movieService)
            }
        }
        .onAppear {
            viewModel.fetchMovies()
        }
        .navigationTitle(category.rawValue)
    }

    private func filteredMovies(for category: MovieCategory) -> [Movie] {
        let movies = category == .popular ? viewModel.popularMovies : viewModel.topRatedMovies
        return movies.filter { movie in
            (viewModel.filterOptions.adult == nil || movie.adult == viewModel.filterOptions.adult!) &&
            (viewModel.filterOptions.originalLanguage == nil || movie.originalLanguage == viewModel.filterOptions.originalLanguage!) &&
            (viewModel.filterOptions.voteAverageRange == nil || (movie.voteAverage >= viewModel.filterOptions.voteAverageRange!.lowerBound && movie.voteAverage <= viewModel.filterOptions.voteAverageRange!.upperBound))
        }
    }
}


