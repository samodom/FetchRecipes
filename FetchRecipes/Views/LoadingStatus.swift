/// The possible statuses of loading a list of recipes.
enum LoadingStatus: Sendable {
    case inProgress
    case emptyResults
    case success
    case failure
}
