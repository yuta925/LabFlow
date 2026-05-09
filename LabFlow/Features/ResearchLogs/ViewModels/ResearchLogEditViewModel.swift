import Foundation

@Observable
@MainActor
final class ResearchLogEditViewModel {
    var title: String
    var did: String
    var learned: String
    var blocked: String
    var nextAction: String
    var question: String
    var isLoading = false
    var errorMessage: String?

    var isValid: Bool {
        !title.trimmingCharacters(in: .whitespaces).isEmpty
    }

    private let log: ResearchLog
    private let repository: any ResearchLogRepository

    init(log: ResearchLog, repository: any ResearchLogRepository) {
        self.log = log
        self.repository = repository
        title = log.title
        did = log.did
        learned = log.learned
        blocked = log.blocked
        nextAction = log.nextAction
        question = log.question
    }

    func save() async throws {
        isLoading = true
        defer { isLoading = false }

        let originalTitle = log.title
        let originalDid = log.did
        let originalLearned = log.learned
        let originalBlocked = log.blocked
        let originalNextAction = log.nextAction
        let originalQuestion = log.question

        log.title = title.trimmingCharacters(in: .whitespaces)
        log.did = did
        log.learned = learned
        log.blocked = blocked
        log.nextAction = nextAction
        log.question = question

        do {
            try await repository.updateLog(log)
        } catch {
            log.title = originalTitle
            log.did = originalDid
            log.learned = originalLearned
            log.blocked = originalBlocked
            log.nextAction = originalNextAction
            log.question = originalQuestion
            throw error
        }
    }
}
