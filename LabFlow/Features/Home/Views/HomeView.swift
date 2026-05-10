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
                ConsultationTicketListView()
            }
        }
    }
}


#Preview {
    HomeView()
        .modelContainer(for: [TaskItem.self, ResearchLog.self, ConsultationTicket.self], inMemory: true)
}
