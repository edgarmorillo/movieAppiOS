import XCTest
import Combine
import SwiftUI
@testable import MovieAppiOS

class MovieAppTests: XCTestCase {

    var cancellables = Set<AnyCancellable>()

    func testFetchMovies() {
        let expectation = XCTestExpectation(description: "Fetch movies expectation")

        let movieService = MovieService()

        movieService.fetchMovies(for: .popular)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    XCTFail("Fetching movies failed with error: \(error)")
                }
                expectation.fulfill()
            }, receiveValue: { movies in
                // Assert that we receive exactly 20 movies for 'popular'
                XCTAssertEqual(movies.count, 20, "Expected exactly 20 movies for popular category")
            })
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 5.0)
    }

    func testSearchMovies() {
        let expectation = XCTestExpectation(description: "Search movies expectation")

        let movieService = MovieService()

        movieService.fetchMovies(for: .topRated)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    XCTFail("Fetching movies failed with error: \(error)")
                }
                expectation.fulfill()
            }, receiveValue: { movies in
                // Assert that we receive exactly 20 movies for 'topRated'
                XCTAssertEqual(movies.count, 20, "Expected exactly 20 movies for topRated category in search results")
            })
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 5.0)
    }


    

    override func tearDown() {
        cancellables.removeAll()
    }
}

// Preview

struct MovieAppTests_Previews: PreviewProvider {
    static var previews: some View {
        let movie = Movie(
            id: 1,
            title: "Sample Movie",
            overview: "This is a sample movie overview. It is meant to give a brief description of the movie.",
            backdropPath: "/sample.jpg",
            voteAverage: 8.5,
            originalLanguage: "en",
            adult: false
        )
        return MovieRowView(movie: movie, movieService: MovieService())
            .previewLayout(.sizeThatFits)
            .padding()
    }
}

