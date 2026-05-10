import SwiftUI
import SwiftData

struct ConsultationTicketDetailView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    let ticket: ConsultationTicket
    @State private var viewModel: ConsultationTicketDetailViewModel?
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
        .navigationTitle(ticket.title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("編集") { isShowingEdit = true }
            }
        }
        .sheet(isPresented: $isShowingEdit) {
            ConsultationTicketEditView(ticket: ticket)
        }
        .alert("相談チケットを削除しますか？", isPresented: $isShowingDeleteAlert) {
            Button("削除", role: .destructive) {
                Task {
                    do {
                        guard let viewModel else { return }
                        try await viewModel.deleteTicket()
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
            viewModel = ConsultationTicketDetailViewModel(
                ticket: ticket,
                repository: SwiftDataConsultationTicketRepository(modelContext: modelContext)
            )
        }
    }

    @ViewBuilder
    private func content(viewModel: ConsultationTicketDetailViewModel) -> some View {
        Form {
            Section("ステータス") {
                Picker("ステータス", selection: Binding(
                    get: { viewModel.ticket.status },
                    set: { newStatus in Task { await viewModel.updateStatus(newStatus) } }
                )) {
                    ForEach(ConsultationTicketStatus.allCases, id: \.self) { status in
                        Text(status.label).tag(status)
                    }
                }
                .pickerStyle(.segmented)
            }

            if !viewModel.ticket.problem.isEmpty {
                Section("困っていること") {
                    Text(viewModel.ticket.problem)
                }
            }

            if !viewModel.ticket.tried.isEmpty {
                Section("試したこと") {
                    Text(viewModel.ticket.tried)
                }
            }

            if !viewModel.ticket.hypothesis.isEmpty {
                Section("仮説") {
                    Text(viewModel.ticket.hypothesis)
                }
            }

            if !viewModel.ticket.question.isEmpty {
                Section("質問・相談したいこと") {
                    Text(viewModel.ticket.question)
                }
            }

            Section {
                Button("チケットを削除", role: .destructive) {
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
