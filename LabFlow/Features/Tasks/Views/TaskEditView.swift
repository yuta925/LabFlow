import SwiftUI
import SwiftData

struct TaskEditView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    let task: TaskItem
    @State private var viewModel: TaskEditViewModel?

    var body: some View {
        NavigationStack {
            Group {
                if let viewModel {
                    form(viewModel: viewModel)
                } else {
                    ProgressView()
                }
            }
            .navigationTitle("タスクを編集")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("キャンセル") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    if let viewModel {
                        if viewModel.isLoading {
                            ProgressView().controlSize(.small)
                        } else {
                            Button("保存") {
                                Task {
                                    do {
                                        viewModel.errorMessage = nil
                                        try await viewModel.save()
                                        dismiss()
                                    } catch {
                                        viewModel.errorMessage = error.localizedDescription
                                    }
                                }
                            }
                            .disabled(!viewModel.isValid)
                        }
                    }
                }
            }
        }
        .task {
            guard viewModel == nil else { return }
            viewModel = TaskEditViewModel(
                task: task,
                repository: SwiftDataTaskRepository(modelContext: modelContext)
            )
        }
    }

    @ViewBuilder
    private func form(viewModel: TaskEditViewModel) -> some View {
        @Bindable var viewModel = viewModel
        Form {
            Section("タイトル（必須）") {
                TextField("例：論文を読む", text: $viewModel.title)
            }

            Section("ステータス") {
                Picker("ステータス", selection: $viewModel.status) {
                    ForEach(TaskStatus.allCases, id: \.self) { status in
                        Text(status.label).tag(status)
                    }
                }
                .pickerStyle(.segmented)
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
