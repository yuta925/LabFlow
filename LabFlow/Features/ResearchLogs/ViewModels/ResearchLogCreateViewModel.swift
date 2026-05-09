import Foundation

@Observable
@MainActor
final class ResearchLogCreateViewModel {
    var title = ""
    var did = ""
    var learned = ""
    var blocked = ""
    var nextAction = ""
    var question = ""
    var isLoading = false
    var errorMessage: String?

    var isValid: Bool {
        !title.trimmingCharacters(in: .whitespaces).isEmpty
    }

    private let repository: any ResearchLogRepository

    init(repository: any ResearchLogRepository) {
        self.repository = repository
    }

    func createLog() async throws {
        isLoading = true
        defer { isLoading = false }
        let log = ResearchLog(
            title: title.trimmingCharacters(in: .whitespaces),
            did: did,
            learned: learned,
            blocked: blocked,
            nextAction: nextAction,
            question: question
        )
        try await repository.createLog(log)
    }
}
