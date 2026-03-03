import SwiftUI

struct SearchView: View {
    var body: some View {
        ContentUnavailableView(
            "Search",
            systemImage: "magnifyingglass",
            description: Text("Coming soon")
        )
    }
}

#Preview {
    SearchView()
}
