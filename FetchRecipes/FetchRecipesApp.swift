import SwiftUI

@main
struct FetchRecipesApp: App {
    @State private var main = Main()

    var body: some Scene {
        WindowGroup {
            MainView(recipesURL: main.recipesURL)
        }
        .modelContainer(main.modelContainer)
        .environment(\.recipeProvider, main.recipeProvider)
        .environment(\.imageProvider, main.imageProvider)
    }
}
