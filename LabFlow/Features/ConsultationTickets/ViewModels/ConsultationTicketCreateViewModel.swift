import Foundation

@Observable
@MainActor
final class ConsultationTicketCreateViewModel {
    var title = ""
    var problem = ""
    var tried = ""
    var hypothesis = ""
    var question = ""
    var isLoading = false
    var errorMessage: String?

    var isValid: Bool {
        !title.trimmingCharacters(in: .whitespaces).isEmpty
    }

    private let repository: any ConsultationTicketRepository

    init(repository: any ConsultationTicketRepository) {
        self.repository = repository
    }

    func createTicket() async throws {
        isLoading = true
        defer { isLoading = false }
        let ticket = ConsultationTicket(
            title: title.trimmingCharacters(in: .whitespaces),
            problem: problem,
            tried: tried,
            hypothesis: hypothesis,
            question: question
        )
        try await repository.createTicket(ticket)
    }
}
