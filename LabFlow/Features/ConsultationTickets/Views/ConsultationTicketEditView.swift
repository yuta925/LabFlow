import SwiftUI
import SwiftData

struct ConsultationTicketEditView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    let ticket: ConsultationTicket
    @State private var viewModel: ConsultationTicketEditViewModel?

    var body: some View {
        NavigationStack {
            Group {
                if let viewModel {
                    form(viewModel: viewModel)
                } else {
                    ProgressView()
                }
            }
            .navigationTitle("相談チケットを編集")
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
            viewModel = ConsultationTicketEditViewModel(
                ticket: ticket,
                repository: SwiftDataConsultationTicketRepository(modelContext: modelContext)
            )
        }
    }

    @ViewBuilder
    private func form(viewModel: ConsultationTicketEditViewModel) -> some View {
        @Bindable var viewModel = viewModel
        Form {
            Section("タイトル（必須）") {
                TextField("例：〇〇の実験でエラーが解消できない", text: $viewModel.title)
            }

            Section("困っていること（任意）") {
                TextField("問題の状況を具体的に記録", text: $viewModel.problem, axis: .vertical)
                    .lineLimit(3...6)
            }

            Section("試したこと（任意）") {
                TextField("試した解決策や調べたことを記録", text: $viewModel.tried, axis: .vertical)
                    .lineLimit(3...6)
            }

            Section("仮説（任意）") {
                TextField("原因や解決策の仮説を記録", text: $viewModel.hypothesis, axis: .vertical)
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
