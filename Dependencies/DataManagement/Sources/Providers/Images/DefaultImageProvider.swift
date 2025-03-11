import CachingInterface
import Foundation
import NetworkingInterface

/// An image-providing implementation that uses any kind of remote resource fetcher and cache to
/// load and store image data.
public actor DefaultImageProvider<Cache: Caching>: ImageProvider
where Cache.Key == URL, Cache.Value == Data {
    private let fetcher: any (RemoteResourceFetching & Sendable)
    private let cache: Cache

    private var tasks = [URL: Task<Data, any Error>]()

    /// Creates an image provider using the given remote resource fetcher and cache.
    /// - Parameter fetcher: A remote resource fetching implementation of any kind.
    /// - Parameter cache: A URL-keyed data-storing implementation of any kind.
    public init(fetcher: any (RemoteResourceFetching & Sendable), cache: Cache) {
        self.fetcher = fetcher
        self.cache = cache
    }

    /// Asynchronously loads data for an image at a specified URL.
    /// - Parameter url: The URL from which to load the image data.
    /// - Returns: The retrieved and stored data if loading is successful.
    /// - Throws: Any error encountered in loading or storing image data. Even though a
    /// `NetworkingError` should be the only kind of error thrown, the `Task` API does not permit
    /// specifying a typed `throws`.
    public func loadImage(at url: URL) async throws -> Data {
        if let data = await cache.value(for: url) {
            print("♻️ Image found in cache")
            return data
        }
        else if let task = tasks[url] {
            print("⏳ Waiting on original image fetch")
            return try await task.result.get()
        }
        else {
            print("❌ Image not in cache")

            let task = Task {
                defer { tasks[url] = nil }

                print("🌐 Fetching image")
                let data = try await fetcher.fetch(from: url)
                print("✅ Fetched image")

                await cache.store(data, for: url)
                return data
            }

            tasks[url] = task
            return try await task.value
        }
    }

    /// Removes all images stored in the cache.
    public func deleteAllImages() async {
        print("Deleting all loaded images")
        await cache.clear()
    }
}
