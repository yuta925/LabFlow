import SwiftUI
import SwiftData

struct ResearchLogListView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel: ResearchLogListViewModel?
    @State private var isShowingCreate = false

    var body: some View {
        NavigationStack {
            Group {
                if let viewModel {
                    content(viewModel: viewModel)
                } else {
                    ProgressView()
                }
            }
            .navigationTitle("研究ログ")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        isShowingCreate = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $isShowingCreate) {
                Task { await viewModel?.loadLogs() }
            } content: {
                ResearchLogCreateView()
            }
        }
        .task {
            guard viewModel == nil else { return }
            let vm = ResearchLogListViewModel(
                repository: SwiftDataResearchLogRepository(modelContext: modelContext)
            )
            viewModel = vm
            await vm.loadLogs()
        }
    }

    @ViewBuilder
    private func content(viewModel: ResearchLogListViewModel) -> some View {
        if viewModel.isLoading {
            ProgressView()
        } else if viewModel.logs.isEmpty {
            emptyState
        } else if let errorMessage = viewModel.errorMessage {
            ContentUnavailableView("エラーが発生しました", systemImage: "exclamationmark.triangle",
                                   description: Text(errorMessage))
        } else {
            List(viewModel.logs) { log in
                NavigationLink {
                    ResearchLogDetailView(log: log)
                } label: {
                    ResearchLogRowView(log: log)
                }
            }
            .onAppear {
                Task { await viewModel.loadLogs() }
            }
        }
    }

    private var emptyState: some View {
        ContentUnavailableView(
            "研究ログがありません",
            systemImage: "doc.text",
            description: Text("右上の + から研究ログを追加できます")
        )
    }
}

#Preview {
    ResearchLogListView()
        .modelContainer(for: ResearchLog.self, inMemory: true)
}
