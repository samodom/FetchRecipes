import Foundation
import Model
import Providers
import SwiftData

extension RecipePreviews {
    actor PreviewRecipeProvider: RecipeProvider {
        private let modelContainer: ModelContainer

        init(modelContainer: ModelContainer) {
            self.modelContainer = modelContainer
        }

        private struct FetchError: Error {
            let description: String
        }

        func loadRecipes(at url: URL) async throws {
            try await Task.sleep(for: .seconds(2))

            guard let url = Bundle.main.url(forResource: "recipes", withExtension: "json"),
                  let json = try? String(contentsOf: url, encoding: .utf8)
            else {
                throw FetchError(description: "Cannot load sample JSON file")
            }

            guard let list = try? JSONDecoder().decode(RemoteRecipeList.self, from: Data(json.utf8))
            else {
                throw FetchError(description: "Cannot parse sample JSON file")
            }

            try await insertRecipes(from: list)
        }

        @MainActor private func insertRecipes(from list: RemoteRecipeList) async throws {
            guard let recipes = try? list.recipes.map(Recipe.init(from:))
            else { throw FetchError(description: "Cannot create model objects from sample data") }

            recipes.forEach {
                modelContainer.mainContext.insert($0)
            }
        }

        @MainActor func deleteRecipes() async throws {
            try modelContainer.mainContext.delete(model: Recipe.self)
        }

        nonisolated func queryPredicate(for searchText: String?) -> Predicate<Recipe> {
            let searchText = searchText ?? ""
            return #Predicate { recipe in
                if !searchText.isEmpty {
                    recipe.name.contains(searchText)
                }
                else {
                    true
                }
            }
        }
    }
}
