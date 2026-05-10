import SwiftUI
import SwiftData

struct ResearchLogEditView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    let log: ResearchLog
    @State private var viewModel: ResearchLogEditViewModel?

    var body: some View {
        NavigationStack {
            Group {
                if let viewModel {
                    form(viewModel: viewModel)
                } else {
                    ProgressView()
                }
            }
            .navigationTitle("研究ログを編集")
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
            viewModel = ResearchLogEditViewModel(
                log: log,
                repository: SwiftDataResearchLogRepository(modelContext: modelContext)
            )
        }
    }

    @ViewBuilder
    private func form(viewModel: ResearchLogEditViewModel) -> some View {
        @Bindable var viewModel = viewModel
        VStack(spacing: 0) {
            Form {
                Section("タイトル（必須）") {
                    TextField("例：〇〇論文のまとめ・実験メモ", text: $viewModel.title)
                }

                if let errorMessage = viewModel.errorMessage {
                    Section {
                        Text(errorMessage)
                            .foregroundStyle(.red)
                            .font(.caption)
                    }
                }
            }
            .frame(height: 120)

            Divider()

            MarkdownTextEditor(text: $viewModel.content)
                .padding(.horizontal, 16)
                .padding(.top, 8)
        }
    }
}
