import SwiftUI
import SwiftData

struct ConsultationTicketListView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel: ConsultationTicketListViewModel?
    @State private var isShowingCreate = false

    var body: some View {
        NavigationStack {
            Group {
                if let viewModel {
                    content(viewModel: viewModel)
                } else {
                    ProgressView()
                }
            }
            .navigationTitle("相談")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        isShowingCreate = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $isShowingCreate) {
                Task { await viewModel?.loadTickets() }
            } content: {
                ConsultationTicketCreateView()
            }
        }
        .task {
            guard viewModel == nil else { return }
            let vm = ConsultationTicketListViewModel(
                repository: SwiftDataConsultationTicketRepository(modelContext: modelContext)
            )
            viewModel = vm
            await vm.loadTickets()
        }
    }

    @ViewBuilder
    private func content(viewModel: ConsultationTicketListViewModel) -> some View {
        if viewModel.isLoading {
            ProgressView()
        } else if viewModel.tickets.isEmpty {
            emptyState
        } else if let errorMessage = viewModel.errorMessage {
            ContentUnavailableView("エラーが発生しました", systemImage: "exclamationmark.triangle",
                                   description: Text(errorMessage))
        } else {
            List(viewModel.tickets) { ticket in
                NavigationLink {
                    Text("相談チケット詳細画面（#35で実装）")
                        .navigationTitle(ticket.title)
                } label: {
                    ConsultationTicketRowView(ticket: ticket)
                }
            }
            .onAppear {
                Task { await viewModel.loadTickets() }
            }
        }
    }

    private var emptyState: some View {
        ContentUnavailableView(
            "相談チケットがありません",
            systemImage: "bubble.left.and.bubble.right",
            description: Text("右上の + から相談チケットを追加できます")
        )
    }
}

#Preview {
    ConsultationTicketListView()
        .modelContainer(for: ConsultationTicket.self, inMemory: true)
}
