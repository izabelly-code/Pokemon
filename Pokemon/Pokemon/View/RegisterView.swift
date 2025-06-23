import SwiftUI
import SwiftData

struct RegisterView: View {
    @Environment(\.modelContext) private var context
    
    @StateObject private var viewModel: RegisterViewModel
    @State private var navigateToPokemonView = false
    
    init(context: ModelContext) {
        _viewModel = StateObject(wrappedValue: RegisterViewModel(context: context))
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                Text("Register")
                    .font(.largeTitle)
                    .bold()
                
                TextField("Username", text: $viewModel.userName)
                    .textFieldStyle(.roundedBorder)
                
                TextField("Email", text: $viewModel.email)
                    .textFieldStyle(.roundedBorder)
                
                SecureField("Password", text: $viewModel.password)
                    .textFieldStyle(.roundedBorder)
                
                Button("Register") {
                    viewModel.register()
                    if viewModel.success {
                        navigateToPokemonView = true
                    }
                }
                .buttonStyle(.borderedProminent)
                
                if !viewModel.errorMessage.isEmpty {
                    Text(viewModel.errorMessage)
                        .foregroundColor(.red)
                }
                
            }
            .padding()
            .navigationDestination(isPresented: $navigateToPokemonView) {
                PokemonView(userEmail:viewModel.email)
            }
        }
    }
}
