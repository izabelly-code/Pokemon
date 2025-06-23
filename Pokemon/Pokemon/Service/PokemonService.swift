import Foundation

class PokemonService {
    func fetchPokemon() async throws -> [PokemonItem] {
        
        let  urlString = "https://pokeapi.co/api/v2/pokemon?limit=6";
        
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }

        let (data, _) = try await URLSession.shared.data(from: url)
        let pokemonList = try JSONDecoder().decode(PokemonListResponse.self, from: data)
        return pokemonList.results
    }
    func fetchPokemonDetail(from urlString: String) async throws -> Pokemon {
            guard let url = URL(string: urlString) else {
                throw URLError(.badURL)
            }
            
            let (data, _) = try await URLSession.shared.data(from: url)
            let pokemon = try JSONDecoder().decode(Pokemon.self, from: data)
            return pokemon
        }
    
    
}
