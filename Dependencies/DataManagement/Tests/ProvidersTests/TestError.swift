import Foundation

/// A test double representing an error that can be checked for equality.
struct TestError: Error, Equatable {
    let id = UUID()
}
