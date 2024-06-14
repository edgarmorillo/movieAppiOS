

import Foundation
import SwiftUI
import Combine

class MovieViewModel: ObservableObject {
    @Published var movie: Movie

    init(movie: Movie) {
        self.movie = movie
    }
}
