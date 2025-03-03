import Foundation

/// An error representing the failure of a network request.
public enum NetworkingError: Error {
    /// An error that occurs at the system level such as a disconnected network device. The
    /// underlying error is stored as the associated value.
    case system(any Error)

    /// An error that occurs at the service level such as a missing resource. The network response
    /// is stored as the associated value.
    case service(URLResponse)
}
