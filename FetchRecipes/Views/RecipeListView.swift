import Model
import SwiftData
import SwiftUI

struct RecipeListView: View {
    @Query private var recipes: [Recipe]
    @Environment(\.modelContext) private var modelContext
    @Binding private var loadingStatus: LoadingStatus

    init(query: Query<Recipe, [Recipe]>, loadingStatus: Binding<LoadingStatus>) {
        _recipes = query
        _loadingStatus = loadingStatus
    }

    var body: some View {
        List {
            Group {
                if loadingStatus != .success {
                    LoadingStatusView(loadingStatus: loadingStatus)
                }
                else {
                    rows
                }
            }
            .listRowSeparator(loadingStatus == .success ? .visible : .hidden)
        }
        .listStyle(.plain)
    }

    private var rows: some View {
        ForEach(recipes) { recipe in
            RecipeView(recipe: recipe)
                .swipeActions{ button(for: recipe) }
        }
        .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 16))
    }

    private func button(for recipe: Recipe) -> some View {
        Button {
            recipe.hasBeenPrepared.toggle()
            try? modelContext.save()
        }
        label: {
            Image(systemName: recipe.hasBeenPrepared ? "xmark.seal" : "checkmark.seal")
                .tint(recipe.hasBeenPrepared ? Color.red : .green)
        }
    }
}
