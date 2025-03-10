import AppleNetworkingImplementation
import CachingInterface
import CachingImplementations
import Foundation
import Model
import NetworkingInterface
import Providers
import SwiftData

/// A top-level bundle of dependencies use in this application. It is owned by the `App` instance.
final class Main {
    let modelContainer: ModelContainer
    let recipeProvider: any (RecipeProvider & Sendable)
    let imageProvider: any (ImageProvider & Sendable)
    let recipesURL = URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json")!

    init() {
        let fetcher = AppleRemoteResourceFetcher(networker: Self.createURLSession())

        do {
            modelContainer = try ModelContainer(
                for: Recipe.self,
                configurations: ModelConfiguration(for: Recipe.self, isStoredInMemoryOnly: true)
            )
        }
        catch {
            print(error.localizedDescription)
            fatalError("Unable to launch app")
        }

        recipeProvider = DefaultRecipeProvider(
            fetcher: fetcher,
            modelContainer: modelContainer
        )

        let cache = DefaultRemoteDataCache(urlCache: Self.createURLCache())
        imageProvider = DefaultImageProvider(
            fetcher: fetcher,
            cache: cache
        )
    }

    private static func createURLSession() -> URLSession {
        // Using a custom session with this configuration is an attempt to keep the cache from
        // failing to clear all items. Images load immediately despite attempting to clear them.
        let urlSessionConfiguration = URLSessionConfiguration.ephemeral
        urlSessionConfiguration.requestCachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        urlSessionConfiguration.urlCache?.diskCapacity = 0
        urlSessionConfiguration.urlCache?.memoryCapacity = 0
        return URLSession(configuration: urlSessionConfiguration)
    }

    private static func createURLCache() -> URLCache {
        let directory = FileManager.default.temporaryDirectory.standardizedFileURL
            .appending(path: "images")
        let megabytes = Measurement(value: 10, unit: UnitInformationStorage.megabytes)
        let bytes = Int(megabytes.converted(to: .bytes).value)
        return URLCache(memoryCapacity: bytes, diskCapacity: bytes, directory: directory)
    }
}
