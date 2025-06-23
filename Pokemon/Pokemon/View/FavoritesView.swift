import SwiftUI
import SwiftData

struct FavoritesView: View {
    @Environment(\.modelContext) private var context
    @StateObject private var viewModel: FavoritesViewModel
    @State private var email: String
    @Query var favoritos: [Favorito]

    init(userEmail: String) {
        _viewModel = StateObject(wrappedValue: FavoritesViewModel(userEmail: userEmail))
        self._email = State(initialValue: userEmail)
        self._favoritos = Query(
            filter: #Predicate<Favorito> { favorito in
                favorito.userEmail == userEmail
            },
            sort: [SortDescriptor(\.nome)]
        )
    }

    var body: some View {
        VStack {
            Text("Seus Favoritos")
                .font(.largeTitle)
                .padding()

            if favoritos.isEmpty {
                Text("Nenhum favorito encontrado.")
                    .foregroundColor(.gray)
                    .padding()
            } else {
                List {
                    ForEach(favoritos) { favorito in
                        HStack {
                            Text(favorito.nome.capitalized)
                            Spacer()
                            Button(action: {
                                context.delete(favorito)
                                try? context.save()
                            }) {
                                Image(systemName: "trash")
                                    .foregroundColor(.red)
                            }
                            .buttonStyle(BorderlessButtonStyle())
                        }
                    }
                }
            }
        }
    }
}
