import Foundation

class PokemonDetailViewModel: ObservableObject {
    @Published var detail: Pokemon?

    private let service = PokemonService()

    func loadDetails(for pokemon: PokemonItem) async {
        do {
            self.detail = try await service.fetchPokemonDetail(from: pokemon.url)
        } catch {
            print("Erro ao carregar detalhes: \(error)")
        }
    }
}
