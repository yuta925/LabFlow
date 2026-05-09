import Foundation
import SwiftData

@MainActor
final class SwiftDataConsultationTicketRepository: ConsultationTicketRepository {
    private let modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    func fetchTickets() async throws -> [ConsultationTicket] {
        let descriptor = FetchDescriptor<ConsultationTicket>(
            sortBy: [SortDescriptor(\.createdAt, order: .reverse)]
        )
        return try modelContext.fetch(descriptor)
    }

    func createTicket(_ ticket: ConsultationTicket) async throws {
        modelContext.insert(ticket)
        try modelContext.save()
    }

    func updateTicket(_ ticket: ConsultationTicket) async throws {
        ticket.updatedAt = Date()
        try modelContext.save()
    }

    func deleteTicket(_ ticket: ConsultationTicket) async throws {
        modelContext.delete(ticket)
        try modelContext.save()
    }
}
