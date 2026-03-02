//
//  CalendarView.swift
//  portent
//

import SwiftUI

struct CalendarView: View {
    var body: some View {
        ContentUnavailableView(
            "Calendar",
            systemImage: "calendar",
            description: Text("Coming soon")
        )
    }
}

#Preview {
    CalendarView()
}
