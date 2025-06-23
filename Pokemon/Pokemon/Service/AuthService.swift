import SwiftData
import Foundation

class AuthService {
    let context: ModelContext

    init(context: ModelContext) {
        self.context = context
    }

    func registerUser(userName: String, email: String, password: String) throws {
        let descriptor = FetchDescriptor<User>(
            predicate: #Predicate { $0.email == email }
        )

        let usersDB = try context.fetch(descriptor)

        guard usersDB.isEmpty else {
            throw AuthError.emailAlreadyRegistered
        }

        let newUser = User(
            userName: userName,
            email: email,
            password: password
        )

        context.insert(newUser)
        try context.save()
    }

    func login(email: String, password: String) throws -> User {
        let descriptor = FetchDescriptor<User>(
            predicate: #Predicate { $0.email == email && $0.password == password }
        )

        let users = try context.fetch(descriptor)

        guard let user = users.first else {
            throw AuthError.invalidCredentials
        }

        return user
    }
}
