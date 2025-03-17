import Model
import SwiftData
import SwiftUI

struct MainView: View {
    @Environment(\.recipeProvider) private var recipeProvider
    @Environment(\.imageProvider) private var imageProvider
    @State private var searchText = ""
    @State private var loadingStatus = LoadingStatus.emptyResults
    private let recipesURL: URL

    init(recipesURL: URL) {
        self.recipesURL = recipesURL
    }

    var body: some View {
        NavigationStack {
            RecipeListView(query: makeQuery(), loadingStatus: loadingStatus)
                .navigationTitle("Recipes")
                .searchable(text: $searchText, prompt: "Find recipes")
                .toolbar { deleteButton }
                .task { await fetchRecipes() } // onAppear doesn't take an asynchronous action
                .refreshable { await fetchRecipes() }
        }
    }

    private var deleteButton: some View {
        Button {
            Task {
                await deleteAllData()
                loadingStatus = .emptyResults
            }
        }
        label: {
            Image(systemName: "trash")
        }
    }

    private func deleteAllData() async {
        await withThrowingTaskGroup(of: Void.self) { group in
            group.addTask {
                try await recipeProvider.deleteRecipes()
            }
            group.addTask {
                await imageProvider.deleteAllImages()
            }
        }
    }

    private func fetchRecipes() async {
        guard loadingStatus != .inProgress else { return }

        do {
            loadingStatus = .inProgress
            try await recipeProvider.loadRecipes(at: recipesURL)
            loadingStatus = .success
        }
        catch {
            loadingStatus = .failure
        }
    }

    private func makeQuery() -> Query<Recipe, [Recipe]> {
        Query(
            filter: recipeProvider.queryPredicate(for: searchText),
            sort: [SortDescriptor(\.name)]
        )
    }
}

#Preview(traits: .recipePreviews) {
    MainView(recipesURL: URL(string: "https://somewhere.com/something")!)
}
