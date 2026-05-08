import SwiftUI
import SwiftData

struct TaskDetailView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    let task: TaskItem
    @State private var viewModel: TaskDetailViewModel?
    @State private var isShowingEdit = false
    @State private var isShowingDeleteAlert = false

    var body: some View {
        Group {
            if let viewModel {
                content(viewModel: viewModel)
            } else {
                ProgressView()
            }
        }
        .navigationTitle(task.title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("編集") { isShowingEdit = true }
            }
        }
        .sheet(isPresented: $isShowingEdit) {
            TaskEditView(task: task)
        }
        .alert("タスクを削除しますか？", isPresented: $isShowingDeleteAlert) {
            Button("削除", role: .destructive) {
                Task {
                    do {
                        guard let viewModel else { return }
                        try await viewModel.deleteTask()
                        dismiss()
                    } catch {
                        viewModel?.errorMessage = error.localizedDescription
                    }
                }
            }
            Button("キャンセル", role: .cancel) {}
        }
        .task {
            guard viewModel == nil else { return }
            viewModel = TaskDetailViewModel(
                task: task,
                repository: SwiftDataTaskRepository(modelContext: modelContext)
            )
        }
    }

    @ViewBuilder
    private func content(viewModel: TaskDetailViewModel) -> some View {
        Form {
            Section("ステータス") {
                Picker("ステータス", selection: Binding(
                    get: { viewModel.task.status },
                    set: { newStatus in Task { await viewModel.updateStatus(newStatus) } }
                )) {
                    ForEach(TaskStatus.allCases, id: \.self) { status in
                        Text(status.label).tag(status)
                    }
                }
                .pickerStyle(.segmented)
            }

            if !viewModel.task.memo.isEmpty {
                Section("メモ") {
                    Text(viewModel.task.memo)
                }
            }

            if let dueDate = viewModel.task.dueDate {
                Section("期限日") {
                    Text(dueDate, style: .date)
                }
            }

            Section {
                Button("タスクを削除", role: .destructive) {
                    isShowingDeleteAlert = true
                }
            }

            if let errorMessage = viewModel.errorMessage {
                Section {
                    Text(errorMessage)
                        .foregroundStyle(.red)
                        .font(.caption)
                }
            }
        }
    }
}
