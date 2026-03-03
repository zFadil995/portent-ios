import SwiftUI

struct ServicesView: View {
    var body: some View {
        ContentUnavailableView(
            "Services",
            systemImage: "server.rack",
            description: Text("Coming soon")
        )
    }
}

#Preview {
    ServicesView()
}
