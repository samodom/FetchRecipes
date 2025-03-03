import Foundation

/// Interface for fetching data from a remote resource by URL.
public protocol RemoteResourceFetching: Sendable {
    /// Fetch the raw data from a URL.
    /// - Parameter url: The URL from which to fetch data.
    /// - Throws: A `NetworkingError`.
    /// - Returns: The raw data at the URL.
    func fetch(from url: URL) async throws(NetworkingError) -> Data
}
