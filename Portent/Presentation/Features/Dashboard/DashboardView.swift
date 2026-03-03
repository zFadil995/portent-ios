import SwiftUI

struct DashboardView: View {
    var body: some View {
        ContentUnavailableView(
            "Dashboard",
            systemImage: "house",
            description: Text("Coming soon")
        )
    }
}

#Preview {
    DashboardView()
}
