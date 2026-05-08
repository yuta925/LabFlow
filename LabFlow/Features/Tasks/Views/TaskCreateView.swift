import SwiftUI
import SwiftData

struct TaskCreateView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @State private var viewModel: TaskCreateViewModel?

    var body: some View {
        NavigationStack {
            Group {
                if let viewModel {
                    form(viewModel: viewModel)
                } else {
                    ProgressView()
                }
            }
            .navigationTitle("タスクを追加")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("キャンセル") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    if let viewModel {
                        Button("保存") {
                            Task {
                                do {
                                    try await viewModel.createTask()
                                    dismiss()
                                } catch {
                                    viewModel.errorMessage = error.localizedDescription
                                }
                            }
                        }
                        .disabled(!viewModel.isValid || viewModel.isLoading)
                    }
                }
            }
        }
        .task {
            guard viewModel == nil else { return }
            viewModel = TaskCreateViewModel(
                repository: SwiftDataTaskRepository(modelContext: modelContext)
            )
        }
    }

    @ViewBuilder
    private func form(viewModel: TaskCreateViewModel) -> some View {
        @Bindable var viewModel = viewModel
        Form {
            Section("タイトル（必須）") {
                TextField("例：論文を読む", text: $viewModel.title)
            }

            Section("メモ（任意）") {
                TextField("補足や詳細を入力", text: $viewModel.memo, axis: .vertical)
                    .lineLimit(3...6)
            }

            Section {
                Toggle("期限日を設定する", isOn: $viewModel.hasDueDate)
                if viewModel.hasDueDate {
                    DatePicker(
                        "期限日",
                        selection: $viewModel.dueDate,
                        displayedComponents: .date
                    )
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

#Preview {
    TaskCreateView()
        .modelContainer(for: TaskItem.self, inMemory: true)
}
