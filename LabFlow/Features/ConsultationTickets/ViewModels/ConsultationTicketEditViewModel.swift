import Foundation

@Observable
@MainActor
final class ConsultationTicketEditViewModel {
    var title: String
    var problem: String
    var tried: String
    var hypothesis: String
    var question: String
    var isLoading = false
    var errorMessage: String?

    var isValid: Bool {
        !title.trimmingCharacters(in: .whitespaces).isEmpty
    }

    private let ticket: ConsultationTicket
    private let repository: any ConsultationTicketRepository

    init(ticket: ConsultationTicket, repository: any ConsultationTicketRepository) {
        self.ticket = ticket
        self.repository = repository
        title = ticket.title
        problem = ticket.problem
        tried = ticket.tried
        hypothesis = ticket.hypothesis
        question = ticket.question
    }

    func save() async throws {
        isLoading = true
        defer { isLoading = false }

        let originalTitle = ticket.title
        let originalProblem = ticket.problem
        let originalTried = ticket.tried
        let originalHypothesis = ticket.hypothesis
        let originalQuestion = ticket.question

        ticket.title = title.trimmingCharacters(in: .whitespaces)
        ticket.problem = problem
        ticket.tried = tried
        ticket.hypothesis = hypothesis
        ticket.question = question

        do {
            try await repository.updateTicket(ticket)
        } catch {
            ticket.title = originalTitle
            ticket.problem = originalProblem
            ticket.tried = originalTried
            ticket.hypothesis = originalHypothesis
            ticket.question = originalQuestion
            throw error
        }
    }
}
