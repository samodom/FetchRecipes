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
            RecipeListView(query: makeQuery(), loadingStatus: immutableLoadingStatus)
                .navigationTitle("Recipes")
                .searchable(text: $searchText, prompt: "Find recipes")
                .toolbar { deleteButton }
                .task {
                    fetchRecipes()
                }
                .refreshable {
                    fetchRecipes()
                }
        }
    }

    private var deleteButton: some View {
        Button { @MainActor in
            loadingStatus = .emptyResults
            deleteAllData()
        }
        label: {
            Image(systemName: "trash")
        }
    }

    private func deleteAllData() {
        Task {
            await withThrowingTaskGroup(of: Void.self) { group in
                group.addTask {
                    try await recipeProvider.deleteRecipes()
                }
                group.addTask {
                    await imageProvider.deleteAllImages()
                }
            }
        }
    }

    private func fetchRecipes() {
        guard loadingStatus != .inProgress else { return }

        Task { @MainActor in
            do {
                loadingStatus = .inProgress
                try await recipeProvider.loadRecipes(at: recipesURL)
                loadingStatus = .success
            }
            catch {
                loadingStatus = .failure
            }
        }
    }

    private func makeQuery() -> Query<Recipe, [Recipe]> {
        Query(
            filter: recipeProvider.queryPredicate(for: searchText),
            sort: [SortDescriptor(\.name)]
        )
    }

    private var immutableLoadingStatus: Binding<LoadingStatus> {
        Binding(
            get: { loadingStatus },
            set: { _ in }
        )
    }
}

extension ReferenceWritableKeyPath: @retroactive @unchecked Sendable {}

#Preview {
    let data = PreviewData()
    MainView(recipesURL: URL(string: "https://somewhere.com/something")!)
        .modelContainer(data.modelContainer)
        .environment(\.recipeProvider, data.recipeProvider)
}
