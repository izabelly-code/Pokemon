import Foundation
import SwiftData

@Model
final class Favorito: Identifiable {
    @Attribute(.unique) var id: UUID
    var nome: String
    var userEmail: String

    init(id: UUID = UUID(), nome: String, userEmail: String) {
        self.id = id
        self.nome = nome
        self.userEmail = userEmail
    }
}
