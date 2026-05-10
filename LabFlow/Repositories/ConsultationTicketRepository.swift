import Foundation

@MainActor
protocol ConsultationTicketRepository {
    func fetchTickets() async throws -> [ConsultationTicket]
    func createTicket(_ ticket: ConsultationTicket) async throws
    func updateTicket(_ ticket: ConsultationTicket) async throws
    func deleteTicket(_ ticket: ConsultationTicket) async throws
}
