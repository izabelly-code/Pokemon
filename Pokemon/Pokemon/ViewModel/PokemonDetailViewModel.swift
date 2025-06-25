import Foundation

@MainActor
class PokemonDetailViewModel: ObservableObject {
    @Published var detail: Pokemon?

    private let service = PokemonService()

    func loadDetails(for pokemon: PokemonItem) async {
        do {
            let result = try await service.fetchPokemonDetail(from: pokemon.url)
            
            await MainActor.run {
                        self.detail = result
            }
        } catch {
            print("Erro ao carregar detalhes: \(error)")
        }
    }
}
