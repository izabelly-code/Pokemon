import Foundation

struct Pokemon: Codable,Identifiable {
    let id: Int
    let name: String
    let height: Int
    let weight: Int
    let abilities: [PokemonAbility]
    let moves: [PokemonMove]
    let sprites: PokemonSprites
    let types: [PokemonType]
}

struct PokemonType: Codable {
    let slot: Int
    let type: NamedAPIResource
}
struct PokemonSprites: Codable {
    let front_default: String?
}
struct PokemonAbility : Codable{
    let ability: NamedAPIResource
    let is_hidden: Bool
    
}
struct PokemonMove: Codable {
    let move: NamedAPIResource
}

struct NamedAPIResource: Codable {
    let name: String
    let url: String
}

struct PokemonListResponse: Codable {
    let results: [PokemonItem]
}

struct PokemonItem: Codable, Identifiable, Hashable {
    let name: String
    let url: String
    
    var id: Int {
            if let number = url.split(separator: "/").last,
               let id = Int(number) {
                return id
            }
            return UUID().hashValue 
        }
    
}



