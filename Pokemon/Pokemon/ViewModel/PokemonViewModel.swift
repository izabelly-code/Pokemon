import Foundation
import SwiftData
import SwiftUI

@MainActor
class PokemonViewModel: ObservableObject {
    @Published var pokemons: [PokemonItem] = []
    @Published var favoritos: [Favorito] = []
    
    private let service = PokemonService()
    
    private let userEmail: String

    init(userEmail: String) {
           self.userEmail = userEmail
       }
    
    func loadPokemons() async {
        do {
            self.pokemons = try await service.fetchPokemon()
        } catch {
            print("Erro ao carregar lista: \(error)")
        }
    }

    func adicionarFavorito(pokemon: PokemonItem, context: ModelContext) {
            guard !isFavorito(pokemon: pokemon) else { return }
            let favorito = Favorito(nome: pokemon.name,  userEmail: userEmail)
            context.insert(favorito)
            favoritos.append(favorito)

            do {
                try context.save()
            } catch {
                print("Erro ao salvar favorito: \(error)")
            }
        }
    
    func removerFavorito(pokemon: PokemonItem, context: ModelContext) {
        if let favorito = favoritos.first(where: { $0.nome == pokemon.name }) {
            context.delete(favorito)
            favoritos.removeAll { $0.id == favorito.id }

            do {
                try context.save()
            } catch {
                print("Erro ao remover favorito: \(error)")
            }
        }
    }
    
    func isFavorito(pokemon: PokemonItem) -> Bool {
            favoritos.contains(where: { $0.nome == pokemon.name })
    }
    
    func loadFavoritos(context: ModelContext) {
        let descriptor = FetchDescriptor<Favorito>(
            predicate: #Predicate { $0.userEmail == userEmail }
        )

        do {
            self.favoritos = try context.fetch(descriptor)
        } catch {
            print("Erro ao carregar favoritos: \(error)")
            self.favoritos = []
        }
    }
    
}
