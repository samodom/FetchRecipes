import AppleNetworkingImplementation
import Foundation

/// A test double for an Apple networker that provides stubbing and spying behavior.
final class TestAppleNetworker: AppleNetworking {

    // MARK: - data(from:)

    var dataFromURLEvidence: URL?
    var dataFromURLStub: Result<(Data, URLResponse), Error>?

    func data(from url: URL) async throws -> (Data, URLResponse) {
        dataFromURLEvidence = url

        switch dataFromURLStub {
        case .failure(let error): throw error
        case .success(let result): return result
        case nil: throw MissingRequiredStubError()
        }
    }
}
