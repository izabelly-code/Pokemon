import SwiftData
import Foundation

@Model
class User {
    @Attribute(.unique) var id: UUID
    var userName: String
    var email: String
    var password: String

    init(id: UUID = UUID(), userName: String, email: String, password: String) {
        self.id = id
        self.userName = userName
        self.email = email
        self.password = password
    }
}
