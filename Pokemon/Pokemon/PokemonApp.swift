import SwiftUI
import SwiftData

@main
struct PokemonApp: App {
    
    var body: some Scene {
        WindowGroup {
            LoginView(context: sharedModelContainer.mainContext)
                    
        }
        .modelContainer(sharedModelContainer)
    }
}

@MainActor
let sharedModelContainer: ModelContainer = {
    do {
        let schema = Schema([User.self,Favorito.self])
        let container = try ModelContainer(for: schema)
        return container
    } catch {
        fatalError("Failed to create SwiftData container: \(error)")
    }
}()
