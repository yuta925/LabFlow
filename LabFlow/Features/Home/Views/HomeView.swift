import SwiftUI
import SwiftData

struct HomeView: View {
    var body: some View {
        TabView {
            Tab("タスク", systemImage: "checklist") {
                TaskListView()
            }
            Tab("研究ログ", systemImage: "doc.text") {
                ResearchLogListView()
            }
            Tab("相談", systemImage: "bubble.left.and.bubble.right") {
                ConsultationPlaceholderView()
            }
        }
    }
}

private struct ConsultationPlaceholderView: View {
    var body: some View {
        NavigationStack {
            ContentUnavailableView(
                "相談チケット",
                systemImage: "bubble.left.and.bubble.right",
                description: Text("Sprint 3 で実装予定")
            )
            .navigationTitle("相談")
        }
    }
}

#Preview {
    HomeView()
        .modelContainer(for: [TaskItem.self, ResearchLog.self], inMemory: true)
}
