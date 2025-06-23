import SwiftData
import Foundation
import SwiftUI

class RegisterViewModel: ObservableObject {
    let context: ModelContext

    init(context: ModelContext) {
        self.context = context
    }

    @Published var userName: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var errorMessage: String = ""
    @Published var success: Bool = false

    func register() {
        guard !userName.isEmpty, !email.isEmpty, !password.isEmpty else {
            errorMessage = "Todos os campos devem ser preenchidos."
            success = false
            return
        }
        
        guard isEmailValid(email) else {
            errorMessage = "E-mail inválido."
            success = false
            return
        }

        guard isPasswordStrong(password) else {
            errorMessage = """
            A senha deve ter pelo menos 8 caracteres, incluindo:
            - Uma letra maiúscula
            - Uma letra minúscula
            - Um número
            - Um caractere especial
            """
            success = false
            return
        }
        let auth = AuthService(context: context)
        do {
            try auth.registerUser(
                userName: userName,
                email: email,
                password: password
            )
            success = true
            errorMessage = ""
        } catch {
            errorMessage = error.localizedDescription
            success = false
        }
    }
    
    private func isEmailValid(_ email: String) -> Bool {
        let emailRegex = #"^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
    }

    private func isPasswordStrong(_ password: String) -> Bool {
        let passwordRegex = #"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#$&*._%])[A-Za-z\d!@#$&*._%]{8,}$"#
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: password)
    }

}
