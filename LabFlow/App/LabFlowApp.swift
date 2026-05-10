import SwiftUI
import SwiftData

@main
struct LabFlowApp: App {
    let modelContainer: ModelContainer = {
        let schema = Schema([TaskItem.self, ResearchLog.self, ConsultationTicket.self])
        do {
            return try ModelContainer(for: schema)
        } catch {
            // スキーマ変更時にストアとの不整合が発生した場合、既存ストアを削除して再作成する
            let config = ModelConfiguration(schema: schema)
            try? FileManager.default.removeItem(at: config.url)
            do {
                return try ModelContainer(for: schema)
            } catch {
                fatalError("Could not create ModelContainer: \(error)")
            }
        }
    }()

    var body: some Scene {
        WindowGroup {
            HomeView()
        }
        .modelContainer(modelContainer)
    }
}
