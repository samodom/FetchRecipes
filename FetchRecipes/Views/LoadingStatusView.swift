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
            Label { Text("Loading recipes...") } icon: { EmptyView() }
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

#Preview(traits: .sizeThatFitsLayout) {
    VStack {
        Group {
            LoadingStatusView(loadingStatus: .inProgress)
            LoadingStatusView(loadingStatus: .emptyResults)
            LoadingStatusView(loadingStatus: .failure)
            LoadingStatusView(loadingStatus: .success)
        }
        .background(Color.white)
    }
    .background(Color.orange)
}
