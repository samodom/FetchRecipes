import Model
import SwiftUI

struct RecipeView: View {
    let recipe: Recipe
    @Environment(\.imageProvider) private var imageProvider
    @State private var imageData: Data?

    var body: some View {
        HStack {
            details.contentShape(Rectangle())
            Spacer()
            videoLink
        }
        .task { await loadSmallImage() }
    }

    @ViewBuilder private var details: some View {
        let views = Group {
            image.frame(width: 60, height: 60)

            VStack(alignment: .leading) {
                Text(verbatim: recipe.name)
                    .font(.headline)
                    .lineLimit(1)

                Text(verbatim: recipe.cuisine.flag + recipe.cuisine.name)
            }
        }

        if let url = recipe.detailsURL {
            Link(destination: url) { views }
                .contentShape(Rectangle())
                .buttonStyle(.plain)
        }
        else {
            views
        }
    }

    private var image: some View {
        ZStack {
            RemoteImageView(data: imageData)
                .scaledToFit()

            if recipe.hasBeenPrepared {
                Color.white.opacity(0.8)
                Image(systemName: "checkmark")
                    .bold()
                    .foregroundStyle(.green)
            }
        }
    }

    @ViewBuilder var videoLink: some View {
        if let videoURL = recipe.videoURL {
            let image = ImageResource(name: "youtube", bundle: .main)
            Link(destination: videoURL) { Image(image) }
                .buttonStyle(.plain)
        }
    }

    private func loadSmallImage() async {
        guard let url = recipe.smallImageURL else { return }
        imageData = try? await imageProvider.loadImage(at: url)
    }
}

#Preview(traits: .recipePreviews) {
    let minimalRecipe = Recipe(
        id: .init(),
        name: "Apple Pie",
        cuisine: .american,
        largeImageURL: nil,
        smallImageURL: nil,
        detailsURL: nil,
        videoURL: nil
    )
    let maximalRecipe: Recipe = {
        let recipe = Recipe(
            id: .init(),
            name: "Apple Pie But Longer So That It Is Truncated",
            cuisine: .american,
            largeImageURL: URL(string: "https://webstockreview.net/images/goldfish-clipart-clip-art-9.png"),
            smallImageURL: URL(string: "https://webstockreview.net/images/goldfish-clipart-clip-art-9.png"),
            detailsURL: URL(string: "https://webstockreview.net/images/goldfish-clipart-clip-art-9.png"),
            videoURL: URL(string: "https://webstockreview.net/images/goldfish-clipart-clip-art-9.png")
        )
        recipe.hasBeenPrepared = true
        return recipe
    }()

    List {
        Group {
            RecipeView(recipe: minimalRecipe)
            RecipeView(recipe: maximalRecipe)
        }
        .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 16))
    }
    .listStyle(.plain)
}
