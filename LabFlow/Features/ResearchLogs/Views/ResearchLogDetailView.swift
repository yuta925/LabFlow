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
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text(viewModel.log.createdAt, style: .date)
                    .font(.caption)
                    .foregroundStyle(.secondary)

                MarkdownViewer(content: viewModel.log.content)

                Divider()

                Button("研究ログを削除", role: .destructive) {
                    isShowingDeleteAlert = true
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.vertical, 4)

                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundStyle(.red)
                        .font(.caption)
                }
            }
            .padding()
        }
    }
}
