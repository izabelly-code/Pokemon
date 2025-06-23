import Foundation

enum AuthError: Error, LocalizedError {
    case emailAlreadyRegistered
    case invalidCredentials

    var errorDescription: String? {
        switch self {
        case .emailAlreadyRegistered:
            return "This email is already registered."
        case .invalidCredentials:
            return "Invalid email or password."
        }
    }
}
