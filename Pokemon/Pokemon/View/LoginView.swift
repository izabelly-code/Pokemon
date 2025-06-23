import SwiftUI
import SwiftData

struct LoginView: View {
    @Environment(\.modelContext) private var context

    @StateObject private var viewModel: LoginViewModel
    @State private var showRegisterScreen = false
    @State private var navigateToPokemonViewL = false
    
    init(context: ModelContext) {
        _viewModel = StateObject(wrappedValue: LoginViewModel(context: context))
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                Text("Login")
                    .font(.largeTitle)
                    .bold()
                
                TextField("Email", text: $viewModel.email)
                    .textFieldStyle(.roundedBorder)
                
                SecureField("Password", text: $viewModel.password)
                    .textFieldStyle(.roundedBorder)
                
                Button("Login") {
                    viewModel.login()
                    if viewModel.loggedUser != nil {
                        navigateToPokemonViewL = true
                    }
                }
                .buttonStyle(.borderedProminent)
                
                if !viewModel.errorMessage.isEmpty {
                    Text(viewModel.errorMessage)
                        .foregroundColor(.red)
                }
                
                Spacer()
                
                Button("Don't have an account? Register") {
                    showRegisterScreen = true
                }
                .padding(.top)
            }
            .padding()
            .navigationDestination(isPresented: $navigateToPokemonViewL) {
                PokemonView(userEmail:viewModel.email)
            }
            .navigationDestination(isPresented: $showRegisterScreen) {
                RegisterView(context: context)
            }
            
        }
    }
}
