
import XCTest
import Combine
@testable import MovieAppiOS

class MovieServiceTests: XCTestCase {
    var service: MovieService!
    var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        service = MovieService()
        cancellables = []
    }

    func testFetchPopularMovies() {
        let expectation = XCTestExpectation(description: "Fetch popular movies")

        service.fetchMovies(for: .popular)
            .sink(receiveCompletion: { _ in },
                  receiveValue: { movies in
                XCTAssertFalse(movies.isEmpty)
                expectation.fulfill()
            })
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 5.0)
    }

    func testFetchTopRatedMovies() {
        let expectation = XCTestExpectation(description: "Fetch top rated movies")

        service.fetchMovies(for: .topRated)
            .sink(receiveCompletion: { _ in },
                  receiveValue: { movies in
                XCTAssertFalse(movies.isEmpty)
                expectation.fulfill()
            })
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 5.0)
    }
}
