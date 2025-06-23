import SwiftData
import Foundation
import SwiftUI

class LoginViewModel: ObservableObject {
    let context: ModelContext

    init(context: ModelContext) {
        self.context = context
    }

    @Published var email: String = ""
    @Published var password: String = ""
    @Published var errorMessage: String = ""
    @Published var loggedUser: User? = nil

    func login() {
        let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedPassword = password.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmedEmail.isEmpty, !trimmedPassword.isEmpty else {
                errorMessage = "E-mail e senha são obrigatórios."
                loggedUser = nil
                return
        }
        let auth = AuthService(context: context)
        do {
            loggedUser = try auth.login(email: trimmedEmail, password: trimmedPassword)
            errorMessage = ""
        } catch {
            errorMessage = error.localizedDescription
            loggedUser = nil
        }
    }
}
