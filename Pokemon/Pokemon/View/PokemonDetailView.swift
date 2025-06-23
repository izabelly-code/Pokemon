import SwiftUI

struct PokemonDetailView: View {
    let pokemon: PokemonItem
    @StateObject private var viewModel = PokemonDetailViewModel()

    var body: some View {
        ScrollView {
            if let detail = viewModel.detail {
                VStack(alignment: .leading, spacing: 12) {
                    Spacer()
                    AsyncImage(url: URL(string: detail.sprites.front_default ?? "")) { image in
                       image
                           .resizable()
                           .scaledToFit()
                           .frame(width: 150, height: 150)
                    } placeholder: {
                       ProgressView()
                    }
                   Spacer()
                    Text(detail.name.capitalized)
                        .font(.largeTitle)
                        .bold()

                    Text("Height: \(detail.height)")
                    Text("Weight: \(detail.weight)")
                    Divider()
                    Text("Types")
                        .font(.headline)

                    HStack {
                        ForEach(detail.types, id: \.type.name) { pokeType in
                            Text(pokeType.type.name.capitalized)
                                .padding(6)
                                .background(Color.blue.opacity(0.2))
                                .cornerRadius(8)
                        }
                    }

                    Divider()

                    Text("Abilities")
                        .font(.headline)
                    ForEach(detail.abilities, id: \.ability.name) { ability in
                        Text(ability.ability.name.capitalized)
                    }

                    Divider()

                    Text("Moves")
                        .font(.headline)
                    ForEach(detail.moves.prefix(10), id: \.move.name) { move in
                        Text(move.move.name.capitalized)
                    }
                    
                }
                .padding()
            } else {
                ProgressView()
                    .task {
                        await viewModel.loadDetails(for: pokemon)
                    }
            }
        }
        .navigationTitle(pokemon.name.capitalized)
        .navigationBarTitleDisplayMode(.inline)
    }
}
