import Foundation

@Observable
@MainActor
final class ResearchLogDetailViewModel {
    var log: ResearchLog
    var isLoading = false
    var errorMessage: String?

    private let repository: any ResearchLogRepository

    init(log: ResearchLog, repository: any ResearchLogRepository) {
        self.log = log
        self.repository = repository
    }

    func deleteLog() async throws {
        isLoading = true
        defer { isLoading = false }
        try await repository.deleteLog(log)
    }
}
