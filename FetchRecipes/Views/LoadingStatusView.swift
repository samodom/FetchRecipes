import SwiftUI

struct LoadingStatusView: View {
    let loadingStatus: LoadingStatus

    var body: some View {
        switch loadingStatus {
        case .inProgress:
            inProgress
        case .emptyResults:
            emptyResults
        case .success:
            EmptyView()
        case .failure:
            failed
        }
    }

    private var inProgress: some View {
        ContentUnavailableView {
            Label { Text("Loading recipes...") } icon: { ProgressView() }
        }
    }

    private var emptyResults: some View {
        ContentUnavailableView {
            Label { Text("No results") } icon: { Image(systemName: "list.bullet") }
        }
        description: { refreshText }
    }

    private var failed: some View {
        ContentUnavailableView {
            Label { Text("Loading failed") } icon: { Image(systemName: "exclamationmark.triangle") }
        }
        description: { refreshText }
    }

    private var refreshText: some View {
        Text("You may need to refresh the recipe list")
    }
}
