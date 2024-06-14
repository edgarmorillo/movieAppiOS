

import Foundation

struct Movie: Identifiable, Codable {
    let id: Int
    let title: String
    let overview: String
    let backdropPath: String?
    let voteAverage: Double
    let originalLanguage: String
    let adult: Bool

    enum CodingKeys: String, CodingKey {
        case id, title, overview
        case backdropPath = "backdrop_path"
        case voteAverage = "vote_average"
        case originalLanguage = "original_language"
        case adult
    }
}

