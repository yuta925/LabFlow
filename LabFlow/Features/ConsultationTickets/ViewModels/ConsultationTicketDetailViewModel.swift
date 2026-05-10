import Foundation

@Observable
@MainActor
final class ConsultationTicketDetailViewModel {
    var ticket: ConsultationTicket
    var isLoading = false
    var errorMessage: String?

    private let repository: any ConsultationTicketRepository

    init(ticket: ConsultationTicket, repository: any ConsultationTicketRepository) {
        self.ticket = ticket
        self.repository = repository
    }

    func updateStatus(_ status: ConsultationTicketStatus) async {
        ticket.status = status
        do {
            try await repository.updateTicket(ticket)
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func deleteTicket() async throws {
        isLoading = true
        defer { isLoading = false }
        try await repository.deleteTicket(ticket)
    }
}
