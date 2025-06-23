import Foundation
import SwiftData

@MainActor
class FavoritesViewModel: ObservableObject {
    @Published var favoritos: [Favorito] = []

    public let userEmail: String

    init(userEmail: String) {
        self.userEmail = userEmail
    }

    func loadFavorites(context: ModelContext) {
        let descriptor = FetchDescriptor<Favorito>(
            predicate: #Predicate { $0.userEmail == userEmail }
        )

        do {
            favoritos = try context.fetch(descriptor)
        } catch {
            print("Erro ao carregar favoritos: \(error)")
            favoritos = []
        }
    }
    
    func removerFavorito(favorito: Favorito, context: ModelContext) {
        context.delete(favorito)
        do {
            try context.save()
            loadFavorites(context: context)
        } catch {
            print("Erro ao remover favorito: \(error)")
        }
    }

}
