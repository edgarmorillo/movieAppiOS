

import SwiftUI

struct FilterView: View {
    @EnvironmentObject var viewModel: MovieListViewModel

    
    @State private var lowerBound: Double
    @State private var upperBound: Double

    
    init() {
        
        _lowerBound = State(initialValue: 0.0)
        _upperBound = State(initialValue: 10.0)
    }

    var body: some View {
        Form {
            Section(header: Text("Adult Content")) {
                Toggle(isOn: Binding(
                    get: { viewModel.filterOptions.adult ?? false },
                    set: { viewModel.filterOptions.adult = $0 ? true : nil }
                )) {
                    Text("Show Adult Content")
                }
            }
            Section(header: Text("Original Language")) {
                TextField("Language Code", text: Binding(
                    get: { viewModel.filterOptions.originalLanguage ?? "" },
                    set: { viewModel.filterOptions.originalLanguage = $0.isEmpty ? nil : $0.lowercased() }
                ))
                .autocapitalization(.none)
            }
            Section(header: Text("Vote Average")) {
                HStack {
                    Slider(value: $lowerBound, in: 0...10, step: 0.1)
                    Text("\(lowerBound, specifier: "%.1f")")
                }
                HStack {
                    Slider(value: $upperBound, in: 0...10, step: 0.1)
                    Text("\(upperBound, specifier: "%.1f")")
                }
            }
            Button(action: {
                
                guard lowerBound <= upperBound else {
                    
                    return
                }
                
                
                viewModel.filterOptions.voteAverageRange = lowerBound...upperBound
                viewModel.filterMovies()
            }) {
                Text("Apply Filters")
            }

        }
        .navigationTitle("Filters")
    }
}

