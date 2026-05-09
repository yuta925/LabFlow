import SwiftUI
import SwiftData

struct ResearchLogDetailView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    let log: ResearchLog
    @State private var viewModel: ResearchLogDetailViewModel?
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
        .navigationTitle(log.title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("編集") { isShowingEdit = true }
            }
        }
        .sheet(isPresented: $isShowingEdit) {
            ResearchLogEditView(log: log)
        }
        .alert("研究ログを削除しますか？", isPresented: $isShowingDeleteAlert) {
            Button("削除", role: .destructive) {
                Task {
                    do {
                        guard let viewModel else { return }
                        try await viewModel.deleteLog()
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
            viewModel = ResearchLogDetailViewModel(
                log: log,
                repository: SwiftDataResearchLogRepository(modelContext: modelContext)
            )
        }
    }

    @ViewBuilder
    private func content(viewModel: ResearchLogDetailViewModel) -> some View {
        Form {
            if !viewModel.log.did.isEmpty {
                Section("今日やったこと") {
                    Text(viewModel.log.did)
                }
            }

            if !viewModel.log.learned.isEmpty {
                Section("学んだこと") {
                    Text(viewModel.log.learned)
                }
            }

            if !viewModel.log.blocked.isEmpty {
                Section("詰まっていること") {
                    Text(viewModel.log.blocked)
                }
            }

            if !viewModel.log.nextAction.isEmpty {
                Section("次にやること") {
                    Text(viewModel.log.nextAction)
                }
            }

            if !viewModel.log.question.isEmpty {
                Section("質問・相談したいこと") {
                    Text(viewModel.log.question)
                }
            }

            Section {
                Button("研究ログを削除", role: .destructive) {
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
