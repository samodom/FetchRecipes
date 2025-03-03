/// A model of the JSON representation of a list of recipes provided by the server API.
public struct RemoteRecipeList: Decodable, Sendable {
    /// A list of remote recipes.
    public let recipes: [RemoteRecipe]
}
