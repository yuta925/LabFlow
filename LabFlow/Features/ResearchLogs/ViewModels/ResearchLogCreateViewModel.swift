import Foundation

@Observable
@MainActor
final class ResearchLogCreateViewModel {
    var title = ""
    var content = ""
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
            content: content
        )
        try await repository.createLog(log)
    }
}
