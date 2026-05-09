import SwiftUI
import SwiftData

struct ResearchLogCreateView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @State private var viewModel: ResearchLogCreateViewModel?

    var body: some View {
        NavigationStack {
            Group {
                if let viewModel {
                    form(viewModel: viewModel)
                } else {
                    ProgressView()
                }
            }
            .navigationTitle("研究ログを追加")
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
                                        try await viewModel.createLog()
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
            viewModel = ResearchLogCreateViewModel(
                repository: SwiftDataResearchLogRepository(modelContext: modelContext)
            )
        }
    }

    @ViewBuilder
    private func form(viewModel: ResearchLogCreateViewModel) -> some View {
        @Bindable var viewModel = viewModel
        Form {
            Section("タイトル（必須）") {
                TextField("例：〇〇の実験・文献調査", text: $viewModel.title)
            }

            Section("今日やったこと（任意）") {
                TextField("実施した作業や活動を記録", text: $viewModel.did, axis: .vertical)
                    .lineLimit(3...6)
            }

            Section("学んだこと（任意）") {
                TextField("気づきや知見を記録", text: $viewModel.learned, axis: .vertical)
                    .lineLimit(3...6)
            }

            Section("詰まっていること（任意）") {
                TextField("困っていること・障壁を記録", text: $viewModel.blocked, axis: .vertical)
                    .lineLimit(3...6)
            }

            Section("次にやること（任意）") {
                TextField("次のアクションを記録", text: $viewModel.nextAction, axis: .vertical)
                    .lineLimit(3...6)
            }

            Section("質問・相談したいこと（任意）") {
                TextField("指導教員や先輩に聞きたいことを記録", text: $viewModel.question, axis: .vertical)
                    .lineLimit(3...6)
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
    ResearchLogCreateView()
        .modelContainer(for: ResearchLog.self, inMemory: true)
}
