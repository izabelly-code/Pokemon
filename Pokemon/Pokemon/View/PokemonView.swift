import SwiftUI

struct PokemonView: View {
    @Environment(\.modelContext) private var context
    @StateObject private var viewModel: PokemonViewModel
    private var userEmail: String

    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    init(userEmail: String) {
        _viewModel = StateObject(wrappedValue: PokemonViewModel(userEmail: userEmail))
        self.userEmail = userEmail
    }

    var body: some View {
        NavigationView {
            List {
                Section {
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(viewModel.pokemons) { pokemon in
                            VStack {
                                NavigationLink(destination: PokemonDetailView(pokemon: pokemon)) {
                                    Text(pokemon.name.capitalized)
                                        .font(.headline)
                                        .foregroundColor(.blue)
                                        .frame(maxWidth: .infinity) // Make text tappable across the width
                                        .contentShape(Rectangle()) // Make the entire text area tappable
                                }

                                Button(action: {
                                    withAnimation {
                                        viewModel.adicionarFavorito(pokemon: pokemon, context: context)
                                    }
                                }) {
                                    Image(systemName: viewModel.isFavorito(pokemon: pokemon) ? "heart.fill" : "heart")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 24, height: 24)
                                        .foregroundColor(viewModel.isFavorito(pokemon: pokemon) ? .red : .gray)
                                        .scaleEffect(viewModel.isFavorito(pokemon: pokemon) ? 1.2 : 1.0)
                                        .animation(.easeInOut, value: viewModel.isFavorito(pokemon: pokemon))
                                }
                                .buttonStyle(PlainButtonStyle()) // Ensure button doesn't have default styling that might interfere
                                .padding(.top, 8)
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(12)
                        }
                    }
                    .padding(.vertical)
                }
            }
            .navigationTitle("Pokémons")
            .task {
                await viewModel.loadPokemons()
                viewModel.loadFavoritos(context: context)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: FavoritesView(userEmail: userEmail)) {
                        Image(systemName: "heart.fill")
                            .foregroundColor(.red)
                    }
                }
            }
        }
    }
}
