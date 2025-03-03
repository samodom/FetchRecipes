import Foundation
import NetworkingInterface

/// Remote resource fetcher that works with a provided Apple networker (e.g., an instance of
/// `URLSession`).
public final class AppleRemoteResourceFetcher: RemoteResourceFetching, Sendable {
    private let networker: any (AppleNetworking & Sendable)

    /// Creates a fetcher with an Apple networker.
    /// - Parameter networker: An Apple networker.
    public init(networker: any (AppleNetworking & Sendable)) {
        self.networker = networker
    }

    /// Fetch the raw data from a URL.
    /// - Parameter url: The URL from which to fetch data.
    /// - Throws: A `NetworkingError`.
    /// - Returns: The raw data at the URL.
    public func fetch(from url: URL) async throws(NetworkingError) -> Data {
        let data: Data
        let response: URLResponse

        do {
            (data, response) = try await networker.data(from: url)
        }
        catch {
            throw NetworkingError.system(error)
        }

        if let httpResponse = response as? HTTPURLResponse,
           !Self.isSuccessfulHTTPResponseCode(httpResponse.statusCode) {
            throw NetworkingError.service(response)
        }
        else {
            return data
        }
    }

    private static let successfulHTTPResponseCodes = 200 ... 299

    private static func isSuccessfulHTTPResponseCode(_ statusCode: Int) -> Bool {
        successfulHTTPResponseCodes.contains(statusCode)
    }
}
