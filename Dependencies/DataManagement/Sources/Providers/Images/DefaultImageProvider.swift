import CachingInterface
import Foundation
import NetworkingInterface

/// An image-providing implementation that uses any kind of remote resource fetcher and cache to
/// load and store image data.
public actor DefaultImageProvider<Cache: Caching>: ImageProvider
where Cache.Key == URL, Cache.Value == Data {
    private let fetcher: any RemoteResourceFetching
    private let cache: Cache

    private var tasks = [URL: Task<Data, any Error>]()

    /// Creates an image provider using the given remote resource fetcher and cache.
    /// - Parameter fetcher: A remote resource fetching implementation of any kind.
    /// - Parameter cache: A URL-keyed data-storing implementation of any kind.
    public init(fetcher: any RemoteResourceFetching, cache: Cache) {
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
        if let data = cache.value(for: url) {
            return data
        }
        else if let task = tasks[url] {
            return try await task.result.get()
        }
        else {
            let task = Task {
                print("Beginning image fetch")
                defer { tasks[url] = nil }

                let data = try await fetcher.fetch(from: url)
                cache.store(data, for: url)
                return data
            }

            tasks[url] = task
            return try await task.value
        }
    }

    /// Removes all images stored in the cache.
    public func deleteAllImages() {
        print("Deleting all loaded images")
        cache.clear()
    }
}
