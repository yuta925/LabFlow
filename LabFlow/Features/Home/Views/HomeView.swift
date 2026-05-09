import SwiftUI
import SwiftData

struct HomeView: View {
    var body: some View {
        TabView {
            Tab("タスク", systemImage: "checklist") {
                TaskListView()
            }
            Tab("研究ログ", systemImage: "doc.text") {
                ResearchLogPlaceholderView()
            }
            Tab("相談", systemImage: "bubble.left.and.bubble.right") {
                ConsultationPlaceholderView()
            }
        }
    }
}

private struct ResearchLogPlaceholderView: View {
    var body: some View {
        NavigationStack {
            ContentUnavailableView(
                "研究ログ",
                systemImage: "doc.text",
                description: Text("Sprint 2 で実装予定")
            )
            .navigationTitle("研究ログ")
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
        .modelContainer(for: TaskItem.self, inMemory: true)
}
