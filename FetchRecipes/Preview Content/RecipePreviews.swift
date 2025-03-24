import Model
import Providers
import SwiftData
import SwiftUI

struct RecipePreviews: PreviewModifier {
    typealias Context = PreviewData

    final class PreviewData {
        let modelContainer: ModelContainer
        let recipeProvider: any RecipeProvider
        let imageProvider: any (ImageProvider & Sendable)

        init() {
            modelContainer = try! ModelContainer(
                for: Recipe.self,
                configurations: ModelConfiguration(isStoredInMemoryOnly: true)
            )
            recipeProvider = PreviewRecipeProvider(modelContainer: modelContainer)
            imageProvider = PreviewImageProvider()
        }
    }

    static func makeSharedContext() async throws -> Context {
        PreviewData()
    }

    func body(content: Content, context: Context) -> some View {
        content
            .modelContainer(context.modelContainer)
            .environment(\.recipeProvider, context.recipeProvider)
            .environment(\.imageProvider, context.imageProvider)
    }
}

extension PreviewTrait where T == Preview.ViewTraits {
    static var recipePreviews = Self.modifier(RecipePreviews())
}
