import AppleNetworkingImplementation
import Foundation
import NetworkingInterface
import Testing

struct AppleRemoteResourceFetcherTests {
    let fetcher: RemoteResourceFetching
    let networker = TestAppleNetworker()

    init() {
        fetcher = AppleRemoteResourceFetcher(networker: networker)
    }

    @Test func invokingSession() async throws {
        _ = try? await fetcher.fetch(from: .sample)
        #expect(networker.dataFromURLEvidence == .sample, .invokesSession)
    }

    @Test func throwingSystemError() async {
        let expectedError = TestError()
        networker.dataFromURLStub = .failure(expectedError)

        await #expect(.throwsSystemError) {
            _ = try await fetcher.fetch(from: .sample)
        }
        throws: { error in
            guard let networkingError = error as? NetworkingError else { return false }

            switch networkingError {
            case .system(let actualError):
                return actualError as? TestError == expectedError
            default:
                return false
            }
        }
    }

    @Test func throwingHTTPServiceError() async {
        let expectedResponse = createHTTPURLResponse(succeeds: false)
        networker.dataFromURLStub = .success((Data(), expectedResponse))

        await #expect(.throwsServiceError) {
            _ = try await fetcher.fetch(from: .sample)
        }
        throws: { error in
            guard let networkingError = error as? NetworkingError else { return false }

            switch networkingError {
            case .service(let actualResponse):
                return actualResponse == expectedResponse
            default:
                return false
            }
        }
    }

    @Test func successfulNonHTTPFetch() async throws {
        networker.dataFromURLStub = .success((.sampleText, URLResponse()))
        let data = try #require(await fetcher.fetch(from: .sample))
        #expect(data == .sampleText, .fetchesData)
    }

    @Test func successfulHTTPFetch() async throws {
        networker.dataFromURLStub = .success((.sampleText, createHTTPURLResponse(succeeds: true)))
        let data = try #require(await fetcher.fetch(from: .sample))
        #expect(data == .sampleText, .fetchesData)
    }

    // MARK: - Helpers

    private func createHTTPURLResponse(succeeds: Bool) -> URLResponse {
        HTTPURLResponse(
            url: .sample,
            statusCode: succeeds ? .randomSuccessfulResponse() : .randomErrorResponse(),
            httpVersion: nil,
            headerFields: nil
        )!
    }
}

// MARK: - Assertions

fileprivate extension Comment {
    static let invokesSession: Self = "A fetcher asks its networker to fetch the data at a URL"
    static let throwsSystemError: Self =
        "A fetcher throws a networking error after a system failure"
    static let throwsServiceError: Self =
        "A fetcher throws a networking error after a service failure"
    static let fetchesData: Self = "A fetcher returns the data that it fetches"
}

// MARK: - Test Data

fileprivate extension URL {
    static let sample = URL(string: "nowhere")!
}

fileprivate extension Data {
    static let sampleText = Data("sample text response".utf8)
}

fileprivate extension Int {
    static func randomErrorResponse() -> Int {
        ClosedRange<Self>.errorResponses.randomElement()!.randomElement()!
    }

    static func randomSuccessfulResponse() -> Int {
        ClosedRange<Self>.successfulResponses.randomElement()!
    }
}

fileprivate extension ClosedRange where Bound == Int {
    static let informationalResponses = 100 ... 199
    static let successfulResponses = 200 ... 299
    static let redirectionResponses = 300 ... 399
    static let clientErrorResponses = 400 ... 499
    static let serverErrorResponses = 500 ... 599

    static let errorResponses: Set<Self> = [
        informationalResponses,
        redirectionResponses,
        clientErrorResponses,
        serverErrorResponses,
    ]
}

// MARK: - Test Data

private struct TestError: Error, Equatable {
    let id = UUID()
}
