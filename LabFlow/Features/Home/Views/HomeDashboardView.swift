import SwiftUI
import SwiftData

struct HomeDashboardView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel: HomeDashboardViewModel?

    var body: some View {
        NavigationStack {
            Group {
                if let viewModel {
                    content(viewModel: viewModel)
                } else {
                    ProgressView()
                }
            }
            .navigationTitle("ホーム")
        }
        .task {
            guard viewModel == nil else { return }
            let vm = HomeDashboardViewModel(
                taskRepository: SwiftDataTaskRepository(modelContext: modelContext),
                logRepository: SwiftDataResearchLogRepository(modelContext: modelContext),
                ticketRepository: SwiftDataConsultationTicketRepository(modelContext: modelContext)
            )
            viewModel = vm
            await vm.load()
        }
    }

    @ViewBuilder
    private func content(viewModel: HomeDashboardViewModel) -> some View {
        if viewModel.isLoading {
            ProgressView()
        } else if viewModel.isEmpty {
            ContentUnavailableView(
                "まだデータがありません",
                systemImage: "house",
                description: Text("タスク・研究ログ・相談チケットを追加すると\nここに表示されます")
            )
        } else {
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 24) {
                    if !viewModel.inProgressTasks.isEmpty {
                        DashboardSection(title: "進行中のタスク", systemImage: "checklist") {
                            ForEach(viewModel.inProgressTasks.prefix(3)) { task in
                                NavigationLink {
                                    TaskDetailView(task: task)
                                } label: {
                                    DashboardRow(title: task.title, subtitle: task.status.label)
                                }
                            }
                        }
                    }

                    if !viewModel.recentLogs.isEmpty {
                        DashboardSection(title: "最近の研究ログ", systemImage: "doc.text") {
                            ForEach(viewModel.recentLogs) { log in
                                NavigationLink {
                                    ResearchLogDetailView(log: log)
                                } label: {
                                    DashboardRow(
                                        title: log.title,
                                        subtitle: log.createdAt.formatted(date: .abbreviated, time: .omitted)
                                    )
                                }
                            }
                        }
                    }

                    if !viewModel.openTickets.isEmpty {
                        DashboardSection(title: "相談中のチケット", systemImage: "bubble.left.and.bubble.right") {
                            ForEach(viewModel.openTickets.prefix(3)) { ticket in
                                NavigationLink {
                                    ConsultationTicketDetailView(ticket: ticket)
                                } label: {
                                    DashboardRow(title: ticket.title, subtitle: ticket.status.label)
                                }
                            }
                        }
                    }
                }
                .padding()
            }
            .onAppear {
                Task { await viewModel.load() }
            }
        }
    }
}

private struct DashboardSection<Content: View>: View {
    let title: String
    let systemImage: String
    @ViewBuilder let content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Label(title, systemImage: systemImage)
                .font(.headline)
                .foregroundStyle(.primary)

            VStack(spacing: 0) {
                content
            }
            .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12))
        }
    }
}

private struct DashboardRow: View {
    let title: String
    let subtitle: String

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.body)
                    .foregroundStyle(.primary)
                Text(subtitle)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundStyle(.tertiary)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }
}

#Preview {
    HomeDashboardView()
        .modelContainer(for: [TaskItem.self, ResearchLog.self, ConsultationTicket.self], inMemory: true)
}
