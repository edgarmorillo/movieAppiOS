import SwiftUI

struct MovieRowView: View {
    @ObservedObject var imageLoader = ImageLoader()
    var movie: Movie
    var movieService: MovieServiceProtocol

    var body: some View {
        HStack(spacing: 10) {
            if let backdropPath = movie.backdropPath {
                MovieImage(imageLoader: imageLoader, imagePath: backdropPath, movieService: movieService)
            } else {
                PlaceholderImage()
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(movie.title)
                    .font(.headline)
                    .foregroundColor(.primary)

                Text(movie.overview)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(3)

                Text("Rating: \(movie.voteAverage, specifier: "%.1f")")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 8)
    }
}

struct MovieImage: View {
    @ObservedObject var imageLoader: ImageLoader
    var imagePath: String
    var movieService: MovieServiceProtocol

    var body: some View {
        Group {
            if let loadedImage = imageLoader.image {
                Image(uiImage: loadedImage)
                    .resizable()
                    .frame(width: 100, height: 150)
                    .cornerRadius(8)
            } else {
                Image(systemName: "photo")
                    .resizable()
                    .frame(width: 100, height: 150)
                    .cornerRadius(8)
                    .onAppear {
                        let imageUrl = movieService.imageUrl(for: imagePath)
                        imageLoader.loadImage(from: imageUrl)
                    }
                    .onDisappear {
                        imageLoader.cancel()
                    }
            }
        }
    }
}

struct PlaceholderImage: View {
    var body: some View {
        Image(systemName: "photo")
            .resizable()
            .frame(width: 100, height: 150)
            .cornerRadius(8)
    }
}

struct MovieRowView_Previews: PreviewProvider {
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

        let movieService = MovieService()

        return MovieRowView(movie: movie, movieService: movieService)
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
