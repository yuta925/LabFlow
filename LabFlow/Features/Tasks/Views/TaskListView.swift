import SwiftUI
import SwiftData

struct TaskListView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel: TaskListViewModel?

    var body: some View {
        NavigationStack {
            Group {
                if let viewModel {
                    content(viewModel: viewModel)
                } else {
                    ProgressView()
                }
            }
            .navigationTitle("タスク")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        // #10 で作成画面への遷移を実装
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
        }
        .task {
            guard viewModel == nil else { return }
            let vm = TaskListViewModel(
                repository: SwiftDataTaskRepository(modelContext: modelContext)
            )
            viewModel = vm
            await vm.loadTasks()
        }
    }

    @ViewBuilder
    private func content(viewModel: TaskListViewModel) -> some View {
        if viewModel.isLoading {
            ProgressView()
        } else if viewModel.tasks.isEmpty {
            emptyState
        } else if let errorMessage =  viewModel.errorMessage {
            ContentUnavailableView("エラーが発生しました", systemImage: "exclamationmark.triangle",
                                   description:Text(errorMessage))
        }
        else {
            List(viewModel.tasks) { task in
                TaskRowView(task: task)
            }
        }
    }

    private var emptyState: some View {
        ContentUnavailableView(
            "タスクがありません",
            systemImage: "checklist",
            description: Text("右上の + からタスクを追加できます")
        )
    }
}

#Preview {
    TaskListView()
        .modelContainer(for: TaskItem.self, inMemory: true)
}
