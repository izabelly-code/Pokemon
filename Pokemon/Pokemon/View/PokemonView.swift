import SwiftUI

struct PokemonView: View {
    @Environment(\.modelContext) private var context
    @StateObject private var viewModel: PokemonViewModel
    @State private var selectedPokemon: PokemonItem? = nil
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
            List(viewModel.pokemons) { pokemon in
                LazyVGrid(columns: columns, spacing: 16) {
                    NavigationLink(destination: PokemonDetailView(pokemon: pokemon)) {
                        Text(pokemon.name.capitalized)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue.opacity(0.2))
                            .cornerRadius(8)
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
                    .buttonStyle(PlainButtonStyle())
                    .padding(.top, 8)
                }
            }
            .padding(.vertical)
        }
    
            .listStyle(PlainListStyle())
            .navigationTitle("Pokémons")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: FavoritesView(userEmail: userEmail)) {
                        Image(systemName: "heart.fill")
                            .foregroundColor(.red)
                    }
                }
            }
            .onAppear {
                Task {
                    await viewModel.loadPokemons()
                    viewModel.loadFavoritos(context: context)
                }
            }
        }
    
}
