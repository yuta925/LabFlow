import Foundation

@Observable
@MainActor
final class ResearchLogListViewModel {
    var logs: [ResearchLog] = []
    var isLoading = false
    var errorMessage: String?

    private let repository: any ResearchLogRepository

    init(repository: any ResearchLogRepository) {
        self.repository = repository
    }

    func loadLogs() async {
        isLoading = true
        defer { isLoading = false }

        do {
            logs = try await repository.fetchLogs()
            errorMessage = nil
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
