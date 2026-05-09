import SwiftUI
import SwiftData

@main
struct LabFlowApp: App {
    let modelContainer: ModelContainer = {
        let schema = Schema([TaskItem.self, ResearchLog.self])
        do {
            return try ModelContainer(for: schema)
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            HomeView()
        }
        .modelContainer(modelContainer)
    }
}
