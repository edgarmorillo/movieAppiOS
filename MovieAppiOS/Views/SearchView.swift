

import SwiftUI

struct SearchView: View {
    @EnvironmentObject var viewModel: MovieListViewModel
    @State private var query: String = ""

    var body: some View {
        VStack {
            TextField("Search", text: $query, onCommit: {
                viewModel.searchMovies(query: query)
            })
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding()

            List {
                ForEach(viewModel.searchResults.keys.sorted(by: { $0.rawValue < $1.rawValue }), id: \.self) { category in
                    Section(header: Text(category.rawValue)) {
                        ForEach(viewModel.searchResults[category] ?? []) { movie in
                            MovieRowView(movie: movie, movieService: viewModel.movieService)
                        }
                    }
                }
            }
        }
        .navigationTitle("Search Movies")
    }
}
