import Foundation

@Observable
@MainActor
final class ConsultationTicketListViewModel {
    var tickets: [ConsultationTicket] = []
    var isLoading = false
    var errorMessage: String?

    private let repository: any ConsultationTicketRepository

    init(repository: any ConsultationTicketRepository) {
        self.repository = repository
    }

    func loadTickets() async {
        isLoading = true
        defer { isLoading = false }

        do {
            tickets = try await repository.fetchTickets()
            errorMessage = nil
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
