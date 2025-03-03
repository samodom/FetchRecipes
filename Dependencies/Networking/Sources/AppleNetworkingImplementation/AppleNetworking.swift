import Foundation

/// The networking API provided by Apple via `URLSession`.
public protocol AppleNetworking {
    /// From Apple:
    ///
    /// Convenience method to load data using an URL, creates and resumes an URLSessionDataTask
    /// internally.
    ///
    /// - Parameter url: The URL for which to load data.
    /// - Returns: Data and response.
    func data(from url: URL) async throws -> (Data, URLResponse)
}

extension URLSession: AppleNetworking {}
