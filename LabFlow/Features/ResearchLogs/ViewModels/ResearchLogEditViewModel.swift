import Foundation

@Observable
@MainActor
final class ResearchLogEditViewModel {
    var title: String
    var content: String
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
        content = log.content
    }

    func save() async throws {
        isLoading = true
        defer { isLoading = false }

        let originalTitle = log.title
        let originalContent = log.content

        log.title = title.trimmingCharacters(in: .whitespaces)
        log.content = content

        do {
            try await repository.updateLog(log)
        } catch {
            log.title = originalTitle
            log.content = originalContent
            throw error
        }
    }
}
