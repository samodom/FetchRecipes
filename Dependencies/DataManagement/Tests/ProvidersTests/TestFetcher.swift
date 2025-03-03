import Foundation
import NetworkingInterface
import Testing

/// A test double for a remote resource fetcher that provides stubbing and spying behavior.
actor TestFetcher: RemoteResourceFetching, @unchecked Sendable {
    var fetchedURLs = [URL]()
    var stubbedFetchData: Data?
    var stubbedFetchError: NetworkingError?
    var isSuspended = false

    func fetch(from url: URL) async throws(NetworkingError) -> Data {
        fetchedURLs.append(url)

        while isSuspended {
            await Task.yield()
        }

        if let stubbedFetchError {
            throw stubbedFetchError
        }
        else if let stubbedFetchData {
            return stubbedFetchData
        }
        else {
            fatalError("No stubbed values provided to TestFetcher")
        }
    }

    func setStubbedValues(
        stubbedFetchData: Data? = nil,
        stubbedFetchError: NetworkingError? = nil
    ) {
        self.stubbedFetchData = stubbedFetchData
        self.stubbedFetchError = stubbedFetchError
    }

    func setIsSuspended(_ isSuspended: Bool) {
        self.isSuspended = isSuspended
    }
}
