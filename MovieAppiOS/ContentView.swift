
import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = MovieListViewModel(movieService: MovieService())

    var body: some View {
        NavigationView {
            VStack {
                NavigationLink("Popular", destination: MovieListView(category: .popular).environmentObject(viewModel))
                NavigationLink("Top Rated", destination: MovieListView(category: .topRated).environmentObject(viewModel))
                NavigationLink("Filters", destination: FilterView().environmentObject(viewModel))
                NavigationLink("Search", destination: SearchView().environmentObject(viewModel))
            }
            .navigationBarTitle("Movies")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


